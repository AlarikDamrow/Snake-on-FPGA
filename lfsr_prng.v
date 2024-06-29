`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2021 08:46:49 PM
// Design Name: 
// Module Name: lfsr_prng
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


module lfsr_prng(
    input clk,
    input rst,
    input load,
    input [3:0] seed,
    output num
    );
    
    wire [3:0] state_out;
    wire [3:0] state_in;
    
    dff lfsr_dff[3:0] (.clk(clk), .rst(rst), .d(state_in), .q(state_out));
    mux_2to1 lfsr_mux[3:0] (.s(load), .a(seed), .b({state_out[2], state_out[1], state_out[0], nextbit}), .out(state_in));
    
    xor g1(nextbit, state_out[2], state_out[3]);
    assign num = nextbit;
    
endmodule
