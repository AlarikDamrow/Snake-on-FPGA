`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2021 11:26:45 PM
// Design Name: 
// Module Name: vga_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: adapted from "Driving a VGA Monitor Using an FPGA" by embeddedthoughts, (2016),
//                      https://embeddedthoughts.com/2016/07/29/driving-a-vga-monitor-using-an-fpga/,
//                      accessed on 10/27/2021
// 
//////////////////////////////////////////////////////////////////////////////////


module simple_Snake
	(
		input wire clk, reset,
		input wire [3:0] buttons,
		output wire hsync, vsync,
		output wire [11:0] rgb,
		output wire [7:0] CA,
		output wire [7:0] AN
	);
	
	// random xy for apple
	wire cllsn;
	wire apple_cllsn;
	reg rand_ld;
	wire [4:0] rand_x,rand_y;
	wire refr_tick;
	
	// stat
	reg [26:0] stat_time_reg;
    reg score_ld;
    reg [13:0]score_reg;
    reg score_ld;
    wire [26:0] stat;
    
	// timer param
	wire timer_clk;
	localparam SEC = 50000000; // 100Mhz * 50000000 = 1Hz
	
	// register for Basys 2 8-bit RGB DAC 
	reg [11:0] rgb_reg;
	wire [11:0] rgb_next;
	
	// video status output from vga_sync to tell when to route out rgb signal to DAC
	wire video_on, pixel_tick;
	wire [9:0] pixel_x,pixel_y;

    // instantiate vga_sync
    vga_sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                            .video_on(video_on), .p_tick(pixel_tick), .x(pixel_x), .y(pixel_y));
    //intantiate graphics                        
    snake_graphics graphics (.clk(pixel_tick),.rst(reset),.buttons(buttons),.video_on(video_on),
                             .pixel_x(pixel_x),.pixel_y(pixel_y),.rand_x(rand_x),.rand_y(rand_y),
                             .cllsn(cllsn),.apple_cllsn(apple_cllsn),.rgb(rgb_next));
    //instantiate 7-seg display
    arr7seg_top svnseg_stat (.clk(pixel_tick),.rst(reset),.in(stat),.CA(CA),.AN(AN));
       
    //intantiate random num generators
    lfsr_prng_6bit randgen1(.clk(clk),.rst(reset),.load(rand_ld),.num(rand_x));
    lfsr_prng_5bit randgen2(.clk(clk),.rst(reset),.load(rand_ld),.num(rand_y));
       
    //instantiate clk div for 1Hz clk
    ClockDiv div1sec (.clk_in(clk),.clk_div(SEC),.clk_out(timer_clk));

    // reset score upon collision, latch apple collision to only allow 1pt per collision
    // update time by 1s
    always @ (posedge apple_cllsn, posedge timer_clk, posedge reset,posedge cllsn) begin
         if(reset || cllsn)begin
             stat_time_reg <= 0;
             score_reg <= 0;
             rand_ld <= 1;
             score_ld <= 0;
         end
         else if(apple_cllsn)begin
                    score_ld <= 1;
         end
         else if(timer_clk) begin
             stat_time_reg = stat_time_reg + 10000;
             rand_ld = 0;
             if(score_ld)begin
                score_reg = score_reg + 1;
                score_ld = 0;
            end
        end
    end
       
   // update current pixel rgb
   always @ (posedge clk)begin
     if (pixel_tick)begin
         rgb_reg <= rgb_next;
     end
   end
       
   // set stat time/score for 7-seg
   assign stat = stat_time_reg + score_reg;
   // set rgb out
   assign rgb = rgb_reg;
       
endmodule

