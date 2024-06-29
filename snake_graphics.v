`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2021 09:44:05 PM
// Design Name: 
// Module Name: snake_graphics
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


module snake_graphics(
    input clk,
    input rst,
    input [3:0] buttons, // L,R,U,D
    input video_on,
    input [9:0]pixel_x, //current pixel x/y
    input [9:0]pixel_y,
    input [9:0]rand_x, // apple random x/y
    input [9:0]rand_y,
    output wire cllsn, //collision with boundary
    output wire apple_cllsn, //collision with apple
    output reg [11:0]rgb
    );
    
    localparam MAX_X = 640;
    localparam MAX_Y = 480;
    wire refr_tick;
    wire collision;

    //  play area boundary
    localparam RIGHT_BOUNDARY = 512;
    localparam LEFT_BOUNDARY = 32;
    localparam BOTTOM_BOUNDARY = 440;
    localparam TOP_BOUNDARY = 40;
    
    //  snake head (square)
    wire [9:0] head_x_left,head_x_right;
    wire [9:0] head_y_top,head_y_bottom;
    localparam SNAKE_HEAD_SIZE = 16;
    // registers to store snake head bounds
    reg [9:0] head_x_reg, head_y_reg;
    reg [9:0] head_x_next, head_y_next;
    // snake velocity
    localparam HEAD_V = 1;
    reg [1:0] heading;
    // head/bodyshape
    wire [3:0] rom_addr, rom_col;
    reg [15:0] rom_data;
    wire rom_bit;
    // obj enable
    wire snake_sq_on, snake_shape_on;
    wire bounds_on;
    // obj rgb
    wire[11:0] snake_rgb,bounds_rgb,apple_rgb;
    //  snake head image
    always @(*)begin
        case (rom_addr)
             4'd0: rom_data = 16'b0000000000000000;
             4'd1: rom_data = 16'b0000000000000000;
             4'd2: rom_data = 16'b0000000000000000;
             4'd3: rom_data = 16'b0000000000000000;
             4'd4: rom_data = 16'b0000000000000000;
             4'd5: rom_data = 16'b0000000000000000;
             4'd6: rom_data = 16'b0000000110000000;
             4'd7: rom_data = 16'b0000001111000000;
             4'd8: rom_data = 16'b0000001111000000;
             4'd9: rom_data = 16'b0000000110000000;
            4'd10: rom_data = 16'b0000000000000000;
            4'd11: rom_data = 16'b0000000000000000;
            4'd12: rom_data = 16'b0000000000000000;
            4'd13: rom_data = 16'b0000000000000000;
            4'd14: rom_data = 16'b0000000000000000;
            4'd15: rom_data = 16'b0000000000000000;
        default:
            rom_data = 16'h0000;
        endcase
    end
     
     // 1 when full image drawn
     assign refr_tick = (pixel_y == 481) && (pixel_x == 0);
     
     // exterior of snake head
     assign head_x_left = head_x_reg;
     assign head_y_top = head_y_reg;
     assign head_x_right = head_x_left + SNAKE_HEAD_SIZE - 1;
     assign head_y_bottom = head_y_top + SNAKE_HEAD_SIZE - 1;
     
    // pixels within square boundary
    assign snake_sq_on = (head_x_left <= pixel_x) && (pixel_x <= head_x_right) &&
                         (head_y_top <=pixel_y) && (pixel_y <= head_y_bottom);
                      
    // map current pixel location to ROM address/column                 
    assign rom_addr = pixel_y[3:0] - head_y_top[3:0];
    assign rom_col = pixel_x[3:0] - head_x_left[3:0];
    assign rom_bit = rom_data[rom_col];
    
    //  pixel within snake head
    assign snake_shape_on = snake_sq_on & rom_bit;

    // head velocity
    always @ (*) begin
        head_x_next = head_x_reg;
        head_y_next = head_y_reg;
        if(refr_tick)begin
        // set head direction
           if(buttons[0])
                heading = 2'b00;
           else if(buttons[1])
                heading = 2'b01;
           else if(buttons[2])
                heading = 2'b10;
           else if(buttons[3])
                heading = 2'b11;
           case(heading)
                2'b00: 
                        head_y_next = head_y_reg + HEAD_V;
                2'b01:
                        head_y_next = head_y_reg - HEAD_V;
                2'b10: 
                        head_x_next = head_x_reg + HEAD_V;
                2'b11: 
                        head_x_next = head_x_reg - HEAD_V;
                        
                default: 
                    begin
                        head_x_next = head_x_reg; 
                        head_y_next = head_y_reg;
                    end
           endcase
       end
    end
    
    // apple size and position
    localparam apple_size = 16;
    wire [9:0] apple_x,apple_y;
    reg [9:0] apple_x_next,apple_y_next;
    reg [9:0] apple_x_reg,apple_y_reg;
    wire apple_on;
    
    assign apple_x = apple_x_reg;
    assign apple_y = apple_y_reg;
    
    assign apple_on = (apple_x <= pixel_x && pixel_x <= apple_x + apple_size -1) &&
                      (apple_y <= pixel_y && pixel_y <= apple_y + apple_size -1);
     
    assign apple_cllsn = snake_shape_on && apple_on;
    
    // if snake and apple share same pixel, reposition apple at rand
    always @ (refr_tick) begin
        apple_x_next = apple_x_reg;
        apple_y_next = apple_y_reg;
        if(apple_cllsn)begin
            apple_x_next <= (rand_x * 10) + 100;
            apple_y_next <= (rand_y * 10) + 100;
        end
    end
    
    
    // boundary logic
    assign bounds_on = (pixel_x <= LEFT_BOUNDARY ) || (RIGHT_BOUNDARY <= pixel_x) ||
                       (pixel_y <= TOP_BOUNDARY) || (BOTTOM_BOUNDARY <= pixel_y);
    
    // collision logic
    assign collision = snake_shape_on && bounds_on;
    assign cllsn = collision;
    
    //reset/default conditions
    always @ (posedge clk, posedge rst) begin
        if(rst || collision)begin
            head_y_reg <= 224;
            head_x_reg <= 288;
            apple_y_reg <= 100;
            apple_x_reg <= 288;
        end
        else begin
            head_y_reg <= head_y_next;
            head_x_reg <= head_x_next;
            apple_y_reg <= apple_y_next;
            apple_x_reg <= apple_x_next;
        end
     end
    
    // rgb 
    assign snake_rgb = 12'h00F;
    assign bounds_rgb = 12'h0F0;
    assign apple_rgb = 12'hF00;
    
    // set rgb val when obj pixel active
    always @(*)begin
        if(~video_on)begin
            rgb = 12'h000;
        end
        else if(snake_shape_on)
            rgb = snake_rgb;
        else if(bounds_on)
            rgb = bounds_rgb;
        else if(apple_on)
            rgb = apple_rgb;
        else
            rgb = 12'h000; // black background
     end
        
        
endmodule
