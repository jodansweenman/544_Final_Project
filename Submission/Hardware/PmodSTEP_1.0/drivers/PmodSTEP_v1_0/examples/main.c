/***************************************************************************
 *
 * main.c -- Sample program for PmodSTEP Driver
 * Author: Josiah Sweeney
 * Revision History:
 * 	06/05/2022	Create	
 ***************************************************************************/

#include "xparameters.h"
#include "xil_printf.h"
#include "sleep.h"
#include "PmodSTEP.h"

#define DURATION 5

PmodSTEP mySTEP; //PmodSTEP object

int main(){

	print("Initialize Device \n");
	STEP_init(&mySTEP,XPAR_PMODSTEP_1_S00_AXI_BASEADDR);

	print("Activate motor clockwise for 5 sec \n");
	STEP_start(&mySTEP,0);
	sleep(DURATION);

	print("Activate motor counter-clockwise for 5 sec \n");
	STEP_start(&mySTEP,1);
	sleep(DURATION);

	print("Stop motor \n");
	STEP_stop(&mySTEP);

	return 0;
}
