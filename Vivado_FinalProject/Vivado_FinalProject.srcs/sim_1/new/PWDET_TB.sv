`timescale 1ns / 1ps //100MHz clock
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2021 02:45:56 PM
// Design Name: 
// Module Name: Testbench_pwm_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Testbench_pwm_generator();

reg 		    reset;
reg 		    clk;
reg             RGB1_Red;
logic	        [31:0] PWM_L_o;
logic           [31:0] PWM_H_o;

//Note to change sim run time in the settings file, overrides stop
//Also note delays here are double of real time due to clk changing every other cycle
initial begin
    clk <= 0;
    RGB1_Red <= 0;
    reset <= 1;
    
    #5 reset <= 0;
    #5 RGB1_Red <= 1;
    #25
    #5 RGB1_Red <= 0;
    #10
    
    #5 reset <= 0;
    #20 RGB1_Red <= 1;
    #25
    #25 RGB1_Red <= 0;
    #10
    
    #5 reset <= 0;
    #40 RGB1_Red <= 1;
    #25
    #15 RGB1_Red <= 0;
    #10
    
    #5 reset <= 0;
    #5 RGB1_Red <= 1;
    #25
    #5 RGB1_Red <= 0;
    #10
    
    #5 reset <= 0;
    #55 RGB1_Red <= 1;
    #25
    #70 RGB1_Red <= 0;
    #10
    $stop;     //150ms 

end

//Generates 100 MHZ clock
always begin
#5 clk =! clk;
end

PWDET DUT_PWDET_RED(
    .clk(clk),			// 100Mhz clock input
    .reset(reset),
    .PWM_In(RGB1_Red), 
    .High_Count_Out(PWM_H_o),
    .Low_Count_Out(PWM_L_o)
    );

endmodule