`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2021 09:17:46 PM
// Design Name: 
// Module Name: lfsr_prng_tb
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


module lfsr_prng_tb(

    );
    
    reg clk, rst, load;
    wire [4:0]num;
    
    lfsr_prng_5bit uut(.clk(clk), .rst(rst), .load(load), .num(num));
    
    always #50 clk = ~clk;
    
    // init - apply reset pulse
    initial begin
        clk = 0;
        load = 0;
        rst = 0;
        #10 rst = 1;
        #10 rst = 0;
    end
    
    // program pseudorandom number generator
    initial begin
        load = 1;
        #100 load = 0;
    end
    
endmodule
