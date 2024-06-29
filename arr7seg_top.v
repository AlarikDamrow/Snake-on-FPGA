`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2021 03:09:13 AM
// Design Name: 
// Module Name: arr7seg_top
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


module arr7seg_top(
    input clk,
    input rst,
    input [26:0] in,
    output [7:0] CA,
    output [7:0] AN
    );
    
    integer divNum = 1000;
    wire clk_div;
    
    ClockDiv div1000(.clk_in(clk),.clk_div(divNum),.clk_out(clk_div));
    arr7seg seg(.clk(clk_div),.rst(rst),.in(in),.CA(CA),.AN(AN));
    
    
endmodule
