`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2023 10:36:40 AM
// Design Name: 
// Module Name: pixel_gen
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


//module pixel_gen(
//input clk_d,
//input [9:0] pixel_x,
//input [9:0] pixel_y,
//input video_on,
//output reg [3:0] red=0,
//output reg [3:0] blue=0,
//output reg [3:0] green=0
//    );
    
//    always @(posedge clk_d) begin
//        if ((pixel_x==0)||(pixel_x == 639)||(pixel_y == 0) || (pixel_y == 479)) begin // this block would only run when we are on the edges of the display.
//            red <= 4'hF;  
//            green <= 4'hF;
//            blue <= 4'hF; // here all 3 colors would make white color
//            end
//        else begin // if we are not on the edge then this block would run
//                red <= video_on?(pixel_y > 240? 4'hF:4'h0):(4'h0); 
//                green <= video_on?(pixel_y > 240? 4'h0:4'hF):(4'h0);
//                blue <= 4'h0;
//            end 
//       end    
//endmodule

//implementing checkerboard
//module pixel_gen(
//    input clk_d,
//    input [9:0]pixel_x,
//    input [9:0]pixel_y,
//    input video_on,
//    output reg [3:0] red = 0,
//    output reg [3:0] green = 0,
//    output reg [3:0 ]blue = 0
//);
//    reg chess;
//    always @(posedge clk_d) begin
//        if ((pixel_x == 0)||(pixel_x == 639)||(pixel_y == 0)||(pixel_y == 479)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//            end
//        else begin
//            if (pixel_x[5]^pixel_y[5]) begin
//                chess <= 1'b1;
//            end else begin
//                chess <= 1'b0;
//            end
//            red <= (video_on && chess) ? 4'hF: 4'h0; 
//            green <= (video_on && chess) ? 4'hF: 4'h0; 
//            blue<= (video_on && chess) ? 4'hF: 4'h0; 
//        end
//      end
//endmodule


module pixel_gen(
    input clk_d,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input video_on,
    output reg [3:0] red = 4'h0,
    output reg [3:0] green = 4'h0,
    output reg [3:0] blue = 4'h0
);

    always @(posedge clk_d) begin
        if (((pixel_x > 180) && (pixel_x <= 230)) || ((pixel_x > 410) && (pixel_x <= 460))) begin
            if (((pixel_y > 0) && (pixel_y < 70)) || ((pixel_y > 120) && (pixel_y < 190)) || ((pixel_y > 240) && (pixel_y < 310)) || ((pixel_y > 360) && (pixel_y < 430))) begin
                // White rectangles
                red <= video_on ? 4'hF : 4'h0;
                green <= video_on ? 4'hF : 4'h0;
                blue <= video_on ? 4'hF : 4'h0;
            end
            else begin
                // Black lanes
                red <= 4'h0;
                green <= 4'h0;
                blue <= 4'h0;
            end
        end 
        else if ((pixel_x > 10 && pixel_x < 70) && (pixel_y > 400 && pixel_y < 430)) begin
            red <= 4'hF;
            green <= 4'h0;
            blue <= 4'h0; 
        end
        else if ((pixel_x > 25 && pixel_x < 55) && (pixel_y > 380 && pixel_y < 450)) begin
            red <= 4'hF;
            green <= 4'h0;
            blue <= 4'h0; 
        end
        else begin
            // Outside of the specified x-range
            red <= 4'h0;
            green <= 4'h0;
            blue <= 4'h0;
        end
    end
endmodule



            
//    always @(posedge clk_d) begin
//        if ((pixel_x == 0)||(pixel_x == 639)||(pixel_y == 0)||(pixel_y == 479)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//            end
//        else begin
//            if (pixel_x[5]^pixel_y[5]) begin
//                chess <= 1'b1;
//            end else begin
//                chess <= 1'b0;
//            end
//            red <= (video_on && chess) ? 4'hF: 4'h0; 
//            green <= (video_on && chess) ? 4'hF: 4'h0; 
//            blue<= (video_on && chess) ? 4'hF: 4'h0; 
//        end
//      end
