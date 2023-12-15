`timescale 1ns / 1ps

//input clk,
//    input wire rst,
//    input wire ps2d,
//    input wire ps2c,
 
//    output h_sync,
//    output v_sync,
//    output [3:0] red,
//    output [3:0] green,
//    output [3:0] blue,
//    output [0:6] seg,
//    output [3:0] an  
//module our_keyboard(
//    input wire clk, reset,
//    input wire ps2d, ps2c,
//    output wire KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT,
//    output reg key_release
//);
module top(
    input clk_100MHz,       // from Basys 3
    input reset,            // btnC on Basys 3
    input wire ps2d,
    input wire ps2c,
    output hsync,           // VGA port on Basys 3
    output vsync,           // VGA port on Basys 3
    output [11:0] rgb       // to DAC, 3 bits to VGA port on Basys 3
    );
    
    our_keyboard kbd(clk_100MHz, reset, ps2d, ps2c, KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT, key_release);
    
    wire w_video_on, w_p_tick;
    wire [9:0] w_x, w_y;
    reg [11:0] rgb_reg;
    wire[11:0] rgb_next;
    
    vga_controller vc(.clk_100MHz(clk_100MHz), .reset(reset), .video_on(w_video_on), .hsync(hsync), 
                      .vsync(vsync), .p_tick(w_p_tick), .x(w_x), .y(w_y));
    pixel_generation pg(.clk(clk_100MHz), .reset(reset), .video_on(w_video_on), 
                        .x(w_x), .y(w_y), .KEY_UP(KEY_UP), .KEY_DOWN(KEY_DOWN), .KEY_LEFT(KEY_LEFT), .KEY_RIGHT(KEY_RIGHT) ,.rgb(rgb_next));
    
    always @(posedge clk_100MHz)
        if(w_p_tick)
            rgb_reg <= rgb_next;
            
    assign rgb = rgb_reg;
 
endmodule