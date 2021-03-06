//@author Josiah Sweeney


//The application Runs an X,Y,Z CNC machine with feedback.

//Application - Glow LED[7:0] for first interrupt and Glow LED[15:8] for next interrupt --> Repeat

//Flow diagram
// GPIO Interrupt (DIP Switch) --> ( ISR )Send a Semaphore --> Task 1 (Catch the Semaphore) -->
// -->Task 1 - Send a Queue to Task -2 --> Task 2 Receive the queue --> Write to GPIO (LED)
//
// Assumptions:
//   o GPIO_0 is a 16-bit, output-only GPIO port connected to the LEDs.
//   o GPIO_1 is capable of generating an interrupt and is connect to the switches and buttons
//     (see project #2 write-up for details)
//   o AXI Timer 0 is a dual 32-bit timer with the Timer 0 interrupt used to generate
//     the FreeRTOS systick.

/* Kernel includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "timers.h"
#include "semphr.h"

/* BSP includes. */
#include "xtmrctr.h"
#include "xgpio.h"
#include "sleep.h"
#include "nexys4io.h"
#include "PmodOLEDrgb.h"
#include "PMODStep.h"
#include "PmodJSTK2.h"
#include "xwdttb.h"
#include "platform.h"

#define mainQUEUE_LENGTH					( 1 )

/* A block time of 0 simply means, "don't block". */
#define mainDONT_BLOCK						( portTickType ) 0

// Clock frequencies
#define CPU_CLOCK_FREQ_HZ		XPAR_CPU_CORE_CLOCK_FREQ_HZ
#define AXI_CLOCK_FREQ_HZ		XPAR_CPU_M_AXI_DP_FREQ_HZ

// AXI timer parameters
#define AXI_TIMER_DEVICE_ID		XPAR_AXI_TIMER_0_DEVICE_ID
#define AXI_TIMER_BASEADDR		XPAR_AXI_TIMER_0_BASEADDR
#define AXI_TIMER_HIGHADDR		XPAR_AXI_TIMER_0_HIGHADDR
#define TmrCtrNumber			0

// Definitions for peripheral NEXYS4IO
#define NX4IO_DEVICE_ID		XPAR_NEXYS4IO_0_DEVICE_ID
#define NX4IO_BASEADDR		XPAR_NEXYS4IO_0_S00_AXI_BASEADDR
#define NX4IO_HIGHADDR		XPAR_NEXYS4IO_0_S00_AXI_HIGHADDR

// Definitions for peripheral PMODOLEDRGB
#define RGBDSPLY_DEVICE_ID		XPAR_PMODOLEDRGB_0_DEVICE_ID
#define RGBDSPLY_GPIO_BASEADDR	XPAR_PMODOLEDRGB_0_AXI_LITE_GPIO_BASEADDR
#define RGBDSPLY_GPIO_HIGHADDR	XPAR_PMODOLEDRGB_0_AXI_LITE_GPIO_HIGHADD
#define RGBDSPLY_SPI_BASEADDR	XPAR_PMODOLEDRGB_0_AXI_LITE_SPI_BASEADDR
#define RGBDSPLY_SPI_HIGHADDR	XPAR_PMODOLEDRGB_0_AXI_LITE_SPI_HIGHADDR

// Definitions for peripheral PMODJSTK2
#define PMODJSTK_DEVICE_ID		XPAR_PMODJSTK2_0_DEVICE_ID
#define PMODJSTK_BASEADDR		XPAR_PMODJSTK2_0_AXI_LITE_SPI_BASEADDR
#define PMODJSTK_HIGHADDR		XPAR_PMODJSTK2_0_AXI_LITE_GPIO_BASEADDR

// Definitions for peripheral PMODSTEP devices
#define PMODSTEP_X_BASEADDR		XPAR_PMODSTEP_X_DIR_S00_AXI_BASEADDR
#define PMODSTEP_X_HIGHADDR		XPAR_PMODSTEP_X_DIR_S00_AXI_HIGHADDR

#define PMODSTEP_Y_BASEADDR		XPAR_PMODSTEP_Y_DIR_S00_AXI_BASEADDR
#define PMODSTEP_Y_HIGHADDR		XPAR_PMODSTEP_Y_DIR_S00_AXI_HIGHADDR

#define PMODSTEP_Z_BASEADDR		XPAR_PMODSTEP_Z_DIR_S00_AXI_BASEADDR
#define PMODSTEP_Z_HIGHADDR		XPAR_PMODSTEP_Z_DIR_S00_AXI_HIGHADDR



// Definitions for GPIOs
#define BTN_SW_GPIO				XPAR_AXI_GPIO_BTN_SW_DEVICE_ID
#define BTN_SW_GPIO_BASEADDR	XPAR_GPIO_0_BASEADDR

#define LED_GPIO				XPAR_AXI_GPIO_LED_DEVICE_ID

// Definitions for the relay operation on JA PORT for EAOT
#define RELAY_BASEADDR			XPAR_AXI_GPIO_RLY_BASEADDR
#define RELAY_GPIO				XPAR_AXI_GPIO_RLY_DEVICE_ID

#define X_COUNT_GPIO			XPAR_AXI_GPIO_X_CNT_DEVICE_ID

#define Y_COUNT_GPIO			XPAR_AXI_GPIO_Y_CNT_DEVICE_ID

#define Z_COUNT_GPIO			XPAR_AXI_GPIO_Z_CNT_DEVICE_ID


// Watchdog definitions
#define WDTTB_DEVICE_ID		XPAR_WDTTB_0_DEVICE_ID
#define INTC_DEVICE_ID		XPAR_INTC_0_DEVICE_ID
#define WDTTB_IRPT_INTR		XPAR_INTC_0_WDTTB_0_WDT_INTERRUPT_VEC_ID

#define SW_14_MASK			0x4000u

struct STEP_Instructions{
	uint8_t xDir;
	uint8_t xEnable;
	uint8_t yDir;
	uint8_t yEnable;
	uint8_t zDir;
	uint8_t zEnable;
	uint8_t toolRelay;
} STEP_Instruction_Read;

//Create Instances
static XGpio xLEDGPIOInstance, xBtnSwGPIOInstance, xRlyGPIOInstance, xXCountGPIOInstance, xYCountGPIOInstance, xZCountGPIOInstance;
XWdtTb WDTInst;
PmodOLEDrgb	pmodOLEDrgb_inst;
PmodJSTK2 joystick;
PmodSTEP xSTEP, ySTEP, zSTEP;


//Declare a Semaphore
xSemaphoreHandle binary_sem;

/* The queue used by the queue send and queue receive tasks. */
static xQueueHandle xQueueMotorCmd = NULL;

volatile uint8_t buttons = 0;
volatile uint16_t switches = 0;
volatile uint8_t pressed = 0;

volatile uint8_t xJoystick = 0;
volatile uint8_t yJoystick = 0;

volatile uint16_t xSteps = 0;
volatile uint16_t ySteps = 0;
volatile uint16_t zSteps = 0;

volatile uint16_t xStepsOld = 0;
volatile uint16_t yStepsOld = 0;
volatile uint16_t zStepsOld = 0;

volatile uint32_t xCount = 0;
volatile uint32_t yCount = 0;
volatile uint32_t zCount = 0;

volatile uint16_t leds = 0;

volatile uint16_t wdt_switch = 0;
volatile uint16_t relay_switch = 0;
volatile uint8_t  sys_flag = 1;

volatile uint16_t switch_values = 0;

//Function Declarations
static void prvSetupHardware( void );
void PMDIO_itoa(int32_t value, char *string, int32_t radix);
void PMDIO_putnum(PmodOLEDrgb* InstancePtr, int32_t num, int32_t radix);
void Update_Seven_Seg(uint16_t DesiredRPM);
void Reset_Seven_Seg();
void master_thread ();
void parameter_input_thread (void *p);
void display_thread (void *p);
void step_thread (void *p);

//ISR, to handle interrupt of GPIO dip switch
//Can also use Push buttons.
//Give a Semaphore
static void gpio_intr (void *pvUnused) {
	//xSemaphoreGiveFromISR(binary_sem,NULL);
	pressed = 1;

	buttons = XGpio_DiscreteRead(&xBtnSwGPIOInstance, 1);
	switches = XGpio_DiscreteRead(&xBtnSwGPIOInstance, 2);

	if((switches & (1<<3)) == (1<<3) ){
		//Motor relay on
		xil_printf("\r\n ON \r\n");
		XGpio_DiscreteWrite( &xRlyGPIOInstance, 2, 0x00);
	}else{
		//Motor Relay off
		xil_printf("\r\n OFF \r\n");
		XGpio_DiscreteWrite( &xRlyGPIOInstance, 2, 0xFF);
	}


	XGpio_InterruptClear( &xBtnSwGPIOInstance, 1 );
	XGpio_InterruptClear( &xBtnSwGPIOInstance, 2 );

}

void wdt_handler(void *pvUnused) {
    //if system running flag is set, restart the watch dog timer
	leds = (leds & 0xFFFF) | 0x8000;
	XGpio_DiscreteWrite( &xLEDGPIOInstance, 1, leds );
	usleep(10000);
	leds = (leds & 0x0FFF);
	XGpio_DiscreteWrite( &xLEDGPIOInstance, 1, leds );
    if(sys_flag == 1)
    {
        XWdtTb_RestartWdt(&WDTInst);
        sys_flag = 0;
    }
}

void master_thread ()
{
	//Create Semaphore
	//vSemaphoreCreateBinary(binary_sem);

	//Write to OLED.
	OLEDrgb_SetFontColor(&pmodOLEDrgb_inst,OLEDrgb_BuildRGB(200, 12, 44));
	OLEDrgb_Clear(&pmodOLEDrgb_inst);
	OLEDrgb_SetCursor(&pmodOLEDrgb_inst, 0, 1);
	OLEDrgb_PutString(&pmodOLEDrgb_inst,"X:");
	OLEDrgb_SetCursor(&pmodOLEDrgb_inst, 3, 1);
	PMDIO_putnum(&pmodOLEDrgb_inst, xSteps, 10);

	OLEDrgb_SetCursor(&pmodOLEDrgb_inst, 0, 3);
	OLEDrgb_PutString(&pmodOLEDrgb_inst,"Y:");
	OLEDrgb_SetCursor(&pmodOLEDrgb_inst, 3, 3);
	PMDIO_putnum(&pmodOLEDrgb_inst, ySteps, 10);

	OLEDrgb_SetCursor(&pmodOLEDrgb_inst, 0, 5);
	OLEDrgb_PutString(&pmodOLEDrgb_inst,"Z:");
	OLEDrgb_SetCursor(&pmodOLEDrgb_inst, 3, 5);
	PMDIO_putnum(&pmodOLEDrgb_inst, zSteps, 10);

	/* Create the queue */
	xQueueMotorCmd = xQueueCreate( mainQUEUE_LENGTH, sizeof( struct STEP_Instructions ) );

	/* Sanity check that the queue was created. */
	configASSERT( xQueueMotorCmd );

	//Create Task1
	xTaskCreate( parameter_input_thread,
				 ( const char * ) "TX",
				 2048,
				 NULL,
				 1,
				 NULL );

	//Create Task2

	xTaskCreate( display_thread,
				"RX",
				2048,
				NULL,
				1,
				NULL );

	xTaskCreate( step_thread,
				"Vroom",
				2048,
				NULL,
				1,
				NULL );



	//Start the Scheduler
	xil_printf("Starting the scheduler\r\n");
	vTaskStartScheduler();

}

//A task which takes the Interrupt Semaphore and sends a queue to task 2.
void parameter_input_thread (void *p)
{
	struct 		STEP_Instructions uSTEPInstructionsToSend;
	JSTK2_Position position;
	while(1){
		if(wdt_switch == 1){
			sys_flag = 0;
		}
		else{
			sys_flag = 1;
		}
		if(pressed==1){
			pressed = 0;
			wdt_switch = (switches &SW_14_MASK)>>14;
			relay_switch = (switches & 0x0001u);
			xil_printf("Joystick Y: %d\r\n",wdt_switch);
		}
		position = JSTK2_getPosition(&joystick);
		xJoystick = position.XData;
		yJoystick = position.YData;

		if(xJoystick > 150){
			uSTEPInstructionsToSend.xDir = 1;
			uSTEPInstructionsToSend.xEnable = 1;
			//xil_printf("XEnabled\r\n");
		}else if (xJoystick < 106){
			uSTEPInstructionsToSend.xDir = 0;
			uSTEPInstructionsToSend.xEnable = 1;
		}else{
			uSTEPInstructionsToSend.xEnable = 0;
		}

		if(yJoystick > 150){
			uSTEPInstructionsToSend.yDir = 1;
			uSTEPInstructionsToSend.yEnable = 1;
			//xil_printf("XEnabled\r\n");
		}else if (yJoystick < 106){
			uSTEPInstructionsToSend.yDir = 0;
			uSTEPInstructionsToSend.yEnable = 1;
		}else{
			uSTEPInstructionsToSend.yEnable = 0;
		}

		if(buttons == 4){
			uSTEPInstructionsToSend.zDir = 1;
			uSTEPInstructionsToSend.zEnable = 1;
		}else if (buttons == 8){
			uSTEPInstructionsToSend.zDir = 0;
			uSTEPInstructionsToSend.zEnable = 1;
		}else{
			uSTEPInstructionsToSend.zEnable = 0;
		}

		//xil_printf("Joystick X: %d\r\n",xJoystick);
		//xil_printf("Joystick Y: %d\r\n",yJoystick);

		xQueueSend( xQueueMotorCmd, &uSTEPInstructionsToSend, mainDONT_BLOCK );
	}


	//Could use to take rotary encoder values (A trick, coz pmodENC dosen't support interrupt.)
}

void display_thread (void *p)
{
	struct 		STEP_Instructions uSTEPInstructionsReceived;
	while(1){
		xStepsOld = xSteps;
		yStepsOld = ySteps;
		zStepsOld = zSteps;


		xCount = XGpio_DiscreteRead(&xXCountGPIOInstance, 1);
		yCount = XGpio_DiscreteRead(&xYCountGPIOInstance, 1);
		zCount = XGpio_DiscreteRead(&xZCountGPIOInstance, 1);

		xSteps = (xCount>>16)-(xCount&0x0000FFFFu);
		ySteps = (yCount>>16)-(yCount&0x0000FFFFu);
		zSteps = (zCount>>16)-(zCount&0x0000FFFFu);

		if(xSteps != xStepsOld || zSteps != zStepsOld || zSteps != zStepsOld)
		{
			//Write to OLED.
			OLEDrgb_SetFontColor(&pmodOLEDrgb_inst,OLEDrgb_BuildRGB(200, 12, 44));
			OLEDrgb_Clear(&pmodOLEDrgb_inst);
			OLEDrgb_SetCursor(&pmodOLEDrgb_inst, 0, 1);
			OLEDrgb_PutString(&pmodOLEDrgb_inst,"X:");
			OLEDrgb_SetCursor(&pmodOLEDrgb_inst, 3, 1);
			PMDIO_putnum(&pmodOLEDrgb_inst, xSteps, 10);

			OLEDrgb_SetCursor(&pmodOLEDrgb_inst, 0, 3);
			OLEDrgb_PutString(&pmodOLEDrgb_inst,"Y:");
			OLEDrgb_SetCursor(&pmodOLEDrgb_inst, 3, 3);
			PMDIO_putnum(&pmodOLEDrgb_inst, ySteps, 10);

			OLEDrgb_SetCursor(&pmodOLEDrgb_inst, 0, 5);
			OLEDrgb_PutString(&pmodOLEDrgb_inst,"Z:");
			OLEDrgb_SetCursor(&pmodOLEDrgb_inst, 3, 5);
			PMDIO_putnum(&pmodOLEDrgb_inst, zSteps, 10);
		}

		//Update_Seven_Seg((uint16_t)(ulDesSpdDirReceived)&0x0000FFFF);

		//leds = (leds & 0xFFF0) | (0xFFFF&(ulKParamsReceived>>24));
		XGpio_DiscreteWrite( &xLEDGPIOInstance, 1, leds );

	}
}


void step_thread (void *p) {
	struct 		STEP_Instructions uSTEPInstructionsReceived;
	struct 		STEP_Instructions uSTEPInstructionsPrev;

	while(1) {
		xQueueReceive(xQueueMotorCmd, &uSTEPInstructionsReceived, portMAX_DELAY);


		//STEP_start(&xSTEP,0x1);
		//STEP_start(&ySTEP,0x1);
		//STEP_start(&zSTEP,0x1);
		//usleep(8000);
		//STEP_stop(&xSTEP);
		//STEP_stop(&ySTEP);
		//STEP_stop(&zSTEP);
		//usleep(1300);


		if( uSTEPInstructionsPrev.xDir != uSTEPInstructionsReceived.xDir || uSTEPInstructionsPrev.xEnable != uSTEPInstructionsReceived.xEnable){
			if(uSTEPInstructionsReceived.xEnable == 1){
				xil_printf("Enable X: %d\r\n");
				STEP_start(&xSTEP, uSTEPInstructionsReceived.xDir);
			}
			else {
				xil_printf("Stop X: %d\r\n");
				STEP_stop(&xSTEP);
			}
		}

		if( uSTEPInstructionsPrev.yDir != uSTEPInstructionsReceived.yDir || uSTEPInstructionsPrev.yEnable != uSTEPInstructionsReceived.yEnable){
			if(uSTEPInstructionsReceived.yEnable == 1){
				xil_printf("Enable Y: %d\r\n");
				STEP_start(&ySTEP, uSTEPInstructionsReceived.yDir);
			}
			else {
				xil_printf("Stop Y: %d\r\n");
				STEP_stop(&ySTEP);
			}
		}

		if( uSTEPInstructionsPrev.zDir != uSTEPInstructionsReceived.zDir || uSTEPInstructionsPrev.zEnable != uSTEPInstructionsReceived.zEnable){
			if(uSTEPInstructionsReceived.zEnable == 1){
				xil_printf("Enable Z: %d\r\n");
				STEP_start(&zSTEP, uSTEPInstructionsReceived.zDir);
			}
			else {
				xil_printf("Stop Z: %d\r\n");
				STEP_stop(&zSTEP);
			}
		}

		uSTEPInstructionsPrev = uSTEPInstructionsReceived;

	}
}



int main(void)
{
	uint16_t sw = 0;
	// Announcement
	xil_printf("ECE 544 Final CNC Machine\r\n");

	init_platform();

	//Initialize the HW
	prvSetupHardware();

	 if (XWdtTb_IsWdtExpired(&WDTInst)) {
		 // instead of having a print, the user will know that the
	     // WDT triggered a reset if the Seven Segment display still
	     // displays "ECE 544"
		 do
		 {
			 sw = NX4IO_getSwitches() & SW_14_MASK;
		 }while(sw);
	 }

	Reset_Seven_Seg();

	master_thread();

	// cleanup and exit
	cleanup_platform();
	exit(0);
}


static void prvSetupHardware( void )
{
portBASE_TYPE xStatus;
uint32_t status;
const unsigned char ucSetToOutput = 0U;
const unsigned char ucSetToInput = 0xFFU;

	/* Initialize watchdog timer */
	xil_printf("Initializing watchdog timer\r\n");
	xStatus = XWdtTb_Initialize(&WDTInst, XPAR_AXI_TIMEBASE_WDT_0_DEVICE_ID);
	if (xStatus == XST_FAILURE) {
		xil_printf("Failed to initialize watchdog timer\r\n");
	}
	if( xStatus == XST_SUCCESS ) {
		xStatus = xPortInstallInterruptHandler( XPAR_MICROBLAZE_0_AXI_INTC_AXI_TIMEBASE_WDT_0_WDT_INTERRUPT_INTR, wdt_handler, NULL );

		if(xStatus == pdPASS) {
			xil_printf("Watchdog Timer interrupt handler installed\r\n");

			vPortEnableInterrupt( XPAR_MICROBLAZE_0_AXI_INTC_AXI_TIMEBASE_WDT_0_WDT_INTERRUPT_INTR );

			XWdtTb_Start(&WDTInst);
		}
	}


	/* Initialize the Nexys4IO. */
	xil_printf("Initializing GPIO's\r\n");
	status = (uint32_t) NX4IO_initialize(NX4IO_BASEADDR);
	if (status != XST_SUCCESS){
		return XST_FAILURE;
	}

	NX4IO_SSEG_setSSEG_DATA(SSEGHI, 0x0058E30E);
	NX4IO_SSEG_setSSEG_DATA(SSEGLO, 0x00144116);


	/* Initialize the PMOD OLED rgb. */
	OLEDrgb_begin(&pmodOLEDrgb_inst, RGBDSPLY_GPIO_BASEADDR, RGBDSPLY_SPI_BASEADDR);

	/* Initialize the PMOD JSTK 2. */
	JSTK2_begin(&joystick, PMODJSTK_BASEADDR, PMODJSTK_HIGHADDR);


	/* Initialize the PMOD STEP Motors. */
	STEP_init(&xSTEP,PMODSTEP_X_BASEADDR);
	STEP_init(&ySTEP,PMODSTEP_Y_BASEADDR);
	STEP_init(&zSTEP,PMODSTEP_Z_BASEADDR);

	// Initialize Relay
	xStatus = XGpio_Initialize( &xRlyGPIOInstance, XPAR_AXI_GPIO_RLY_DEVICE_ID );
	if( xStatus == XST_SUCCESS )
	{
		/* All bits on this channel are going to be inputs */
		XGpio_SetDataDirection( &xRlyGPIOInstance, 1, ucSetToInput );
		/* All bits on this channel are going to be outputs */
		XGpio_SetDataDirection( &xRlyGPIOInstance, 2, ucSetToOutput );
	}

	// Initialize Step Counter GPIOs
	xStatus = XGpio_Initialize( &xXCountGPIOInstance, XPAR_AXI_GPIO_X_CNT_DEVICE_ID );
	if( xStatus == XST_SUCCESS )
	{
		/* All bits on this channel are going to be inputs */
		XGpio_SetDataDirection( &xXCountGPIOInstance, 1, ucSetToInput );
	}

	xStatus = XGpio_Initialize( &xYCountGPIOInstance, XPAR_AXI_GPIO_Y_CNT_DEVICE_ID );
	if( xStatus == XST_SUCCESS )
	{
		/* All bits on this channel are going to be inputs */
		XGpio_SetDataDirection( &xYCountGPIOInstance, 1, ucSetToInput );
	}

	xStatus = XGpio_Initialize( &xZCountGPIOInstance, XPAR_AXI_GPIO_Z_CNT_DEVICE_ID );
	if( xStatus == XST_SUCCESS )
	{
		/* All bits on this channel are going to be inputs */
		XGpio_SetDataDirection( &xZCountGPIOInstance, 1, ucSetToInput );
	}

	/* Initialize the GPIO for the LEDs. */
	xStatus = XGpio_Initialize( &xLEDGPIOInstance, XPAR_AXI_GPIO_LED_DEVICE_ID );
	if( xStatus == XST_SUCCESS )
	{
		/* All bits on this channel are going to be outputs (LEDs). */
		XGpio_SetDataDirection( &xLEDGPIOInstance, 1, ucSetToOutput );
		xil_printf("Check that LEDs work\r\n");
		XGpio_DiscreteWrite( &xLEDGPIOInstance, 1, 0x5555 );
		usleep(10000);
		XGpio_DiscreteWrite( &xLEDGPIOInstance, 1, 0xAAAA );
		usleep(10000);

	}

	/* Initialize the GPIO for the button and switch inputs. */
	if( xStatus == XST_SUCCESS )
	{
		xStatus = XGpio_Initialize( &xBtnSwGPIOInstance, XPAR_AXI_GPIO_BTN_SW_DEVICE_ID );
	}

	/* Install the interrupt for the GPIO Switches and Buttons */
	if( xStatus == XST_SUCCESS )
	{
		/* Install the handler defined in this task for the button input.
		*NOTE* The FreeRTOS defined xPortInstallInterruptHandler() API function
		must be used for this purpose. */
		xStatus = xPortInstallInterruptHandler( XPAR_MICROBLAZE_0_AXI_INTC_AXI_GPIO_BTN_SW_IP2INTC_IRPT_INTR, gpio_intr, NULL );


		if( xStatus == pdPASS )
		{
			xil_printf("Buttons and Switches interrupt handler installed\r\n");

			/* Set switches and buttons to input. */
			XGpio_SetDataDirection( &xBtnSwGPIOInstance, 1, ucSetToInput );
			XGpio_SetDataDirection( &xBtnSwGPIOInstance, 2, ucSetToInput );

			/* Enable the button input interrupts in the interrupt controller.
			*NOTE* The vPortEnableInterrupt() API function must be used for this
			purpose. */

			vPortEnableInterrupt( XPAR_MICROBLAZE_0_AXI_INTC_AXI_GPIO_BTN_SW_IP2INTC_IRPT_INTR );

			/* Enable GPIO channel interrupts. */
			XGpio_InterruptEnable( &xBtnSwGPIOInstance, 1 );
			XGpio_InterruptEnable( &xBtnSwGPIOInstance, 2 );
			XGpio_InterruptGlobalEnable( &xBtnSwGPIOInstance );
		}
	}

	configASSERT( ( xStatus == pdPASS ) );
}

/****************************************************************************/
/**
* Write a 32-bit number in Radix "radix" to LCD display
*
* Writes a 32-bit number to the LCD display starting at the current
* cursor position. "radix" is the base to output the number in.
*
* @param num is the number to display
*
* @param radix is the radix to display number in
*
* @return *NONE*
*
* @note
* No size checking is done to make sure the string will fit into a single line,
* or the entire display, for that matter.  Watch your string sizes.
*****************************************************************************/
void PMDIO_putnum(PmodOLEDrgb* InstancePtr, int32_t num, int32_t radix)
{
  char  buf[16];

  PMDIO_itoa(num, buf, radix);
  OLEDrgb_PutString(InstancePtr,buf);

  return;
}

void PMDIO_itoa(int32_t value, char *string, int32_t radix)
{
	char tmp[33];
	char *tp = tmp;
	int32_t i;
	uint32_t v;
	int32_t  sign;
	char *sp;

	if (radix > 36 || radix <= 1)
	{
		return;
	}

	sign = ((10 == radix) && (value < 0));
	if (sign)
	{
		v = -value;
	}
	else
	{
		v = (uint32_t) value;
	}

  	while (v || tp == tmp)
  	{
		i = v % radix;
		v = v / radix;
		if (i < 10)
		{
			*tp++ = i+'0';
		}
		else
		{
			*tp++ = i + 'a' - 10;
		}
	}
	sp = string;

	if (sign)
		*sp++ = '-';

	while (tp > tmp)
		*sp++ = *--tp;
	*sp = 0;

  	return;
}

//Reset the Seven Segment Display Decimal points
void Reset_Seven_Seg()
{
	NX4IO_SSEG_setSSEG_DATA(SSEGHI, 0xFFFFFFFF);
	NX4IO_SSEG_setSSEG_DATA(SSEGLO, 0xFFFFFFFF);
	NX4IO_SSEG_setDecPt(SSEGLO,DIGIT7,false);
	NX4IO_SSEG_setDecPt(SSEGLO,DIGIT6,false);
	NX4IO_SSEG_setDecPt(SSEGLO,DIGIT5,false);
	NX4IO_SSEG_setDecPt(SSEGLO,DIGIT4,false);
	NX4IO_SSEG_setDecPt(SSEGHI,DIGIT3,false);
	NX4IO_SSEG_setDecPt(SSEGHI,DIGIT2,false);
	NX4IO_SSEG_setDecPt(SSEGHI,DIGIT1,false);
	NX4IO_SSEG_setDecPt(SSEGHI,DIGIT0,false);
}

void Update_Seven_Seg(uint16_t DesiredRPM)
{
	NX4IO_SSEG_setDigit(SSEGLO,DIGIT3,((DesiredRPM/1000)%10));
	NX4IO_SSEG_setDigit(SSEGLO,DIGIT2,((DesiredRPM/100)%10));
	NX4IO_SSEG_setDigit(SSEGLO,DIGIT1,((DesiredRPM/10)%10));
	NX4IO_SSEG_setDigit(SSEGLO,DIGIT0,(DesiredRPM%10));
	usleep(5000);
}
