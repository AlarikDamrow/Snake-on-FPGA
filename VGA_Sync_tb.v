`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2021 12:45:31 AM
// Design Name: 
// Module Name: VGA_Sync_tb
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


module VGA_Sync_tb();

    reg clk,reset;
    wire h_sync,v_sync,video_IsOn, pixel_tick;
    wire [9:0] x,y;
    
    vga_sync uut(.clk(clk),.reset(reset),.hsync(h_sync),.vsync(v_sync),.video_on(video_IsOn),.p_tick(pixel_tick),.x(x),.y(y));
    
    localparam period = 5;
    
    
    initial begin
    clk = 0;
    reset = 1;
    #period;
    reset = 0;
        forever begin
            clk = ~clk;
            #period;
            if(v_sync == 1)begin
                //$finish;
            end
        end
    end

endmodule
