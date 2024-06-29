`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2021 08:54:08 PM
// Design Name: 
// Module Name: dff
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


module dff(
    input clk,
    input rst,
    input d,
    output q
    );
    
    reg q;
    
    always @(posedge clk or posedge rst)
        begin
        if(rst)
            #2 q = 0;
        else
            q = #3 d;
        end
        
    specify
        $setup(d, clk, 2);
        $hold(clk, d, 0);
    endspecify
endmodule