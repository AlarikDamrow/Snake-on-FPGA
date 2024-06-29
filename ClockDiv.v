`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2021 11:31:13 PM
// Design Name: 
// Module Name: ClockDiv4
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


module ClockDiv(
    input clk_in,
    input [31:0] clk_div,
    output reg clk_out
    );
    
    reg [31:0] cnt = 1;
    
    always @ (posedge clk_in) begin
        if(cnt == clk_div * 2)begin
            cnt = 0;
        end
        clk_out <= (cnt < clk_div) ?1'b1:1'b0;
        cnt = cnt + 1;
    end
endmodule