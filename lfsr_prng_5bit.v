`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2021 10:52:42 PM
// Design Name: 
// Module Name: lfsr_prng_5bit
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


module lfsr_prng_5bit(
    input clk,
    input rst,
    input load,
    output [4:0] num
    );
    
    localparam sd = 1;
    
    lfsr_prng lfsr0 (.clk(clk),.rst(rst),.load(load),.seed(sd),.num(num[0]));
    lfsr_prng lfsr1 (.clk(clk),.rst(rst),.load(load),.seed(sd+1),.num(num[1]));
    lfsr_prng lfsr2 (.clk(clk),.rst(rst),.load(load),.seed(sd+2),.num(num[2]));
    lfsr_prng lfsr3 (.clk(clk),.rst(rst),.load(load),.seed(sd+3),.num(num[3]));
    lfsr_prng lfsr4 (.clk(clk),.rst(rst),.load(load),.seed(sd+4),.num(num[4]));
    
endmodule
