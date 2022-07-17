`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Portland State
// Engineer: Alex Beaulier
// 
// Create Date: 04/17/2022 02:45:19 PM
// Design Name: Pulse Width Detection Module
// Module Name: PWDET
// Project Name: Project 1
// Target Devices: Nexys A7 with Microblaze
// Tool Versions: none
//
// Description: 
// PWDET inputs single PWM input, likely from an LED or motor
// and reads each to output the respective duty cycle.
// Additional goal for project 1 is to read the output on the OLED.
//
// Dependencies: 
// None
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PWDET(
    input logic         clk,			// 100Mhz clock input
    input logic         reset,
    input logic         PWM_In, 
    output logic [31:0] High_Count_Out,
    output logic [31:0] Low_Count_Out
    );
    
//Internal logic tracking
logic [31:0] High_Signal_Count = 0;
logic [31:0] Low_Signal_Count = 0;
//logic [31:0] Duty_Cycle = 0;
//logic [1:0]  PWM_Steps; //Counts first or second high/low signal STAGE (00 -> 10)
logic        low_signal;
logic        high_signal;
//PWM generation has a rising edge, falling edge then rising edge
//First rising edge is the start of the high sig count
//Falling edge is end of high sig count
//Next rising edge should send the ratio of the  100 * (high / (high + low)) signal
//This output is the duty cycle -> % of time on
//A PWM signal can be broken into three stages, 1:adding high signal, 2:adding low signal, 3:output & reset signal & start adding high sig again

always_ff@(posedge clk) begin
    if(reset == 1'b1) begin
		//Reset all registers and counts
        Low_Signal_Count <= 0;
        High_Signal_Count <= 0;
		Low_Count_Out <= 0;
		High_Count_Out <= 0;
    end
    else begin
        //Signal high, add to high count, reset if low has finished
        if(PWM_In == 1'b1) begin
            if(low_signal == 1'b1 && high_signal == 1'b1) begin //STAGE 3 - Completed cycle, send outputs, reset counts
                low_signal <= 1'b0;        //Reset the high to first start
                high_signal <= 1'b0;
                High_Count_Out <= High_Signal_Count;
                Low_Count_Out  <= Low_Signal_Count;
                //Duty_Cycle <= 100 * (High_Signal_Count / (High_Signal_Count + Low_Signal_Count));
                Low_Signal_Count <= 1'b0; //Reset the lowcount, go to stage 1 again
                High_Signal_Count <= 1'b1; // First cycle of new start
            end
            else begin //Stage 1 - First location the signal can enter to start counting
                High_Signal_Count <= High_Signal_Count + 1;
                high_signal <= 1'b1;
            end
        end//EOPWM == 1
        else if (PWM_In == 1'b0) begin //PWM signal is low, count low period depending if high duty cycle completed
            if(high_signal == 1'b1) begin //STAGE 2 - First high is complete, start counting low signal
                Low_Signal_Count <= Low_Signal_Count + 1;
                low_signal <= 1'b1; //Head to Stage 3 once signal goes high again, controlled by input signal
            end
            else begin
                //PWM_Steps <= 2'b00; //Stage 0 - When input is stagnate, don't want to add to counter
                low_signal <= 1'b0;
            end
        end//EOelse
    end //EOElse
end //EO Always FF begin
endmodule