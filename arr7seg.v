`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2021 10:28:38 PM
// Design Name: 
// Module Name: arr7seg
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


module arr7seg(
    input clk,
    input rst,
    input [26:0] in,
    output reg[7:0] CA, // individual cathodes: 0 - top center, 1 - top right, 2 - bottom right, 3 - bottom center
                     // 4 - bottom left, 5 - top left, 6 - center, 7 - decimal point
    output reg [7:0] AN  // digit being displayed
    );
    
    reg [26:0] num = 26'd0;
    integer count = 0;
    
    always @ (posedge clk) begin
        if(rst)begin
            CA = ~8'b11111111;
            num = in;
        end
        if(num == 0 && count == 0)begin
            num = in;
        end
        case(num%10)
                0: CA = 8'b11000000;
                1: CA = 8'b11111001;
                2: CA = 8'b10100100;
                3: CA = 8'b10110000;
                4: CA = 8'b10011001;
                5: CA = 8'b10010010;
                6: CA = 8'b10000010;
                7: CA = 8'b11111000;
                8: CA = 8'b10000000;
                9: CA = 8'b10011000;
                    
            default: CA = ~8'b01111101; // Error
        endcase
        num = num / 10;
    end
    
    always @ (posedge clk) begin //anode 
        if(rst)begin
            AN = 8'b11111111;
            count = 0;
        end
        if(count == 0)begin
            AN = 8'b11111110;
            count = count + 1;
        end
        else if(count < 9)begin
            AN = ~(~AN << 1);
            count = count + 1;
        end
        if(count == 9)begin
            count = 0;
        end
    end
    
    
endmodule
