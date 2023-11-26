`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2023 10:08:08 AM
// Design Name: 
// Module Name: aeroplane
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


//module aeroplane (
//    input [9:0] pixel_x,
//    input [9:0] pixel_y,
//    output wire aeroplane_gfx
//);
//    // Adjust the aeroplane size and position as needed
//    parameter AEROPLANE_WIDTH = 10;
//    parameter AEROPLANE_HEIGHT = 30;
//    parameter FLAP_WIDTH = 25;
//    parameter FLAP_HEIGHT = 5;
//    wire AEROPLANE_X = 10'd20;
//    wire AEROPLANE_Y = 10'd400;
//    wire FLAP_X = AEROPLANE_X - (((FLAP_WIDTH) - (AEROPLANE_WIDTH)) / 2);
//    wire FLAP_Y = AEROPLANE_Y - (((FLAP_HEIGHT) - (AEROPLANE_HEIGHT)) / 2);

//    reg vertical, horizontal;

//    // Vertical part of the cross
//    always @* begin
//        vertical = ((pixel_x >= AEROPLANE_X) && (pixel_x < AEROPLANE_X + AEROPLANE_WIDTH) &&
//                    (pixel_y >= AEROPLANE_Y) && (pixel_y < AEROPLANE_Y + AEROPLANE_HEIGHT));
//    end
    
//    always @* begin
//        horizontal = ((pixel_x >= FLAP_X) && (pixel_x < FLAP_X + FLAP_WIDTH) &&
//                    (pixel_y >= FLAP_Y) && (pixel_y < FLAP_Y + FLAP_HEIGHT));
//    end                
    
//    assign aeroplane_gfx = vertical || horizontal;
    
//endmodule
//module aeroplane (
//    input [9:0] pixel_x,
//    input [9:0] pixel_y,
//    output wire aeroplane_gfx
//);
//    // Adjust the aeroplane size and position as needed
//    parameter AEROPLANE_WIDTH = 10;
//    parameter AEROPLANE_HEIGHT = 30;
//    parameter FLAP_WIDTH = 25;
//    parameter FLAP_HEIGHT = 5;
//    parameter AEROPLANE_X = 20;
//    parameter AEROPLANE_Y = 400;
//    parameter FLAP_X = AEROPLANE_X - (((FLAP_WIDTH) - (AEROPLANE_WIDTH)) / 2);
//    parameter FLAP_Y = AEROPLANE_Y - (((FLAP_HEIGHT) - (AEROPLANE_HEIGHT)) / 2);

//    reg vertical, horizontal;

//    // Vertical part of the cross
//    always @* begin
//        vertical = ((pixel_x >= AEROPLANE_X) && (pixel_x < AEROPLANE_X + AEROPLANE_WIDTH) &&
//                    (pixel_y >= AEROPLANE_Y) && (pixel_y < AEROPLANE_Y + AEROPLANE_HEIGHT));
//    end
    
//    always @* begin
//        horizontal = ((pixel_x >= FLAP_X) && (pixel_x < FLAP_X + FLAP_WIDTH) &&
//                    (pixel_y >= FLAP_Y) && (pixel_y < FLAP_Y + FLAP_HEIGHT));
//    end                
    
//    assign aeroplane_gfx = vertical || horizontal;
    
//endmodule

module aeroplane (
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    output wire aeroplane_gfx
);
    // Adjust the aeroplane size and position as needed
    parameter AEROPLANE_WIDTH = 10;
    parameter AEROPLANE_HEIGHT = 30;
    parameter FLAP_WIDTH = 25;
    parameter FLAP_HEIGHT = 5;
    parameter AEROPLANE_X = 20;
    parameter AEROPLANE_Y = 400;
    parameter FLAP_X = AEROPLANE_X - (((FLAP_WIDTH) - (AEROPLANE_WIDTH)) / 2);
    parameter FLAP_Y = AEROPLANE_Y - (((FLAP_HEIGHT) - (AEROPLANE_HEIGHT)) / 2);

    reg vertical, horizontal;

    // Vertical part of the cross
    always @* begin
        vertical = ((pixel_x >= AEROPLANE_X) && (pixel_x < AEROPLANE_X + AEROPLANE_WIDTH) &&
                    (pixel_y >= AEROPLANE_Y) && (pixel_y < AEROPLANE_Y + AEROPLANE_HEIGHT));
    end
    
    always @* begin
        horizontal = ((pixel_x >= FLAP_X) && (pixel_x < FLAP_X + FLAP_WIDTH) &&
                    (pixel_y >= FLAP_Y) && (pixel_y < FLAP_Y + FLAP_HEIGHT));
    end               
    
    assign aeroplane_gfx = vertical || horizontal;
    
endmodule