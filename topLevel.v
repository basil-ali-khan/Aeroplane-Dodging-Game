`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2023 11:21:57 AM
// Design Name: 
// Module Name: topLevel
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

//input [9:0] h_count, [9:0] v_count,
//    output h_sync, v_sync, video_on,
//    output [9:0] x_loc, [9:0] y_loc

//    input clk_d,
//input [9:0] pixel_x,
//input [9:0] pixel_y,
//input video_on,
//output reg [3:0] red=0,
//output reg [3:0] blue=0,
//output reg [3:0] green=0

module TopModule(
    input clk,
    output h_sync,
    output v_sync,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue
    );
    
    wire clk_d;
    wire trig_v;
    wire [9:0] h_count;
    wire [9:0] v_count;
    wire video_on;
    wire [9:0] x_loc;
    wire [9:0] y_loc;
    
    clk_divider c1(clk,clk_d);
    counter c2(clk_d,h_count,trig_v);
    v_counter c3(clk_d,v_count,trig_v);
    vga_sync vga(h_count, v_count, h_sync, v_sync, video_on, x_loc, y_loc);
    pixel_gen pg(clk_d, x_loc, y_loc, video_on, red, green, blue);
    
endmodule


//module Top(
// input wire CLK, // Onboard clock 100MHz : INPUT Pin W5
// input wire RESET, // Reset button : INPUT Pin U18
// output wire HSYNC, // VGA horizontal sync : OUTPUT Pin P19
// output wire VSYNC, // VGA vertical sync : OUTPUT Pin R19
// output reg [3:0] RED, // 4-bit VGA Red : OUTPUT Pin G19, Pin H19, Pin J19, Pin N19
// output reg [3:0] GREEN, // 4-bit VGA Green : OUTPUT Pin J17, Pin H17, Pin G17, Pin D17
// output reg [3:0] BLUE // 4-bit VGA Blue : OUTPUT Pin N18, Pin L18, Pin K18, Pin J18/ 4-bit VGA Blue : OUTPUT Pin N18, Pin L18, Pin K18, Pin J18
// );
 
// wire rst = RESET; // Setup Reset button
// // instantiate vga640x480 code
// wire [9:0] x; // pixel x position: 10-bit value: 0-1023 : only need 800
// wire [9:0] y; // pixel y position: 10-bit value: 0-1023 : only need 525
// wire active; // high during active pixel drawing
// vga_sync display (.i_clk(CLK),.i_rst(rst),.o_hsync(HSYNC), 
// .o_vsync(VSYNC),.o_x(x),.o_y(y),.o_active(active));
 
// // instantiate BeeSprite code
// wire [1:0] ASpriteOn; // 1=on, 0=off
// wire [7:0] dout; // pixel value from Bee.mem
// aeroplaneSprite aeroplane_display (.i_clk(CLK),.i_rst(rst),.xx(x),.yy(y),.aactive(active),
// .ASpriteOn(ASpriteOn),.dataout(dout));
 
// // load colour palette
// reg [7:0] palette [0:191]; // 8 bit values from the 192 hex entries in the colour palette
// reg [7:0] COL = 0; // background colour palette value
// initial begin
// $readmemh("aeroplane.mem.txt", palette); // load 192 hex values into "palette"
// end
// // draw on the active area of the screen
// always @ (posedge CLK)
// begin
// if (active)
// begin
// if (ASpriteOn==1)
// begin
// RED <= (palette[(dout*3)])>>4; // RED bits(7:4) from colour palette
// GREEN <= (palette[(dout*3)+1])>>4; // GREEN bits(7:4) from colour palette
// BLUE <= (palette[(dout*3)+2])>>4; // BLUE bits(7:4) from colour palette
// end
// else
// begin
// RED <= (palette[(COL*3)])>>4; // RED bits(7:4) from colour palette
// GREEN <= (palette[(COL*3)+1])>>4; // GREEN bits(7:4) from colour palette
// BLUE <= (palette[(COL*3)+2])>>4; // BLUE bits(7:4) from colour palette
// end
// end
// else
// begin
// RED <= 0; // set RED, GREEN & BLUE
// GREEN <= 0; // to "0" when x,y outside of
// BLUE <= 0; // the active display area
// end
// end
//endmodule