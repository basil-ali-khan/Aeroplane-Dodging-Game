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


//module pixel_gen(
//    input clk_d,
//    input [9:0] pixel_x,
//    input [9:0] pixel_y,
//    input video_on,
//    output reg [3:0] red = 4'h0,
//    output reg [3:0] green = 4'h0,
//    output reg [3:0] blue = 4'h0
//);

//    always @(posedge clk_d) begin
//        if (((pixel_x > 180) && (pixel_x <= 230)) || ((pixel_x > 410) && (pixel_x <= 460))) begin
//            if (((pixel_y > 0) && (pixel_y < 70)) || ((pixel_y > 120) && (pixel_y < 190)) || ((pixel_y > 240) && (pixel_y < 310)) || ((pixel_y > 360) && (pixel_y < 430))) begin
//                // White rectangles
//                red <= video_on ? 4'hF : 4'h0;
//                green <= video_on ? 4'hF : 4'h0;
//                blue <= video_on ? 4'hF : 4'h0;
//            end
//            else begin
//                // Black lanes
//                red <= 4'h0;
//                green <= 4'h0;
//                blue <= 4'h0;
//            end
//        end 
//        else if ((pixel_x > 10 && pixel_x < 70) && (pixel_y > 400 && pixel_y < 430)) begin
//            red <= 4'hF;
//            green <= 4'h0;
//            blue <= 4'h0; 
//        end
//        else if ((pixel_x > 25 && pixel_x < 55) && (pixel_y > 380 && pixel_y < 450)) begin
//            red <= 4'hF;
//            green <= 4'h0;
//            blue <= 4'h0; 
//        end
//        else begin
//            // Outside of the specified x-range
//            red <= 4'h0;
//            green <= 4'h0;
//            blue <= 4'h0;
//        end
//    end
//endmodule

//module pixel_gen(
//    input clk_d,
//    input [9:0] pixel_x,
//    input [9:0] pixel_y,
//    input video_on,
//    output reg [3:0] red = 4'h0,  // Output for red component
//    output reg [3:0] green = 4'h0,  // Output for green component
//    output reg [3:0] blue = 4'h0  // Output for blue component
//);
//    // Instantiate the playfield module
//    wire playfield_gfx;
//    playfield maze_inst (.hpos(pixel_x), .vpos(pixel_y), .playfield_gfx(playfield_gfx));
    
//    always @(posedge clk_d) begin
//        // Check if the pixel is on the border
//        if ((pixel_x == 0) || (pixel_x == 639) || (pixel_y == 0) || (pixel_y == 479)) begin
//            // Set RGB values to white for border pixels
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else begin
//            // Set RGB values based on the playfield_gfx signal and video_on signal
//            if (video_on && playfield_gfx) begin
//                red <= 4'hF; 
//                green <= 4'hF; 
//                blue <= 4'hF; 
//            end
//            else begin
//                red <= 4'h0;
//                green <= 4'h0;
//                blue <= 4'h0;
//            end
//        end
//    end
//endmodule


            
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

module pixel_gen(
    input clk_d,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input video_on,
    output reg [3:0] red = 4'h0,  // Output for red component
    output reg [3:0] green = 4'h0,  // Output for green component
    output reg [3:0] blue = 4'h0  // Output for blue component
);
always @(posedge clk_d) begin
    red <= 4'h0;
    green <= 4'h0;
    blue <= 4'h0;

    if ((pixel_x == 0) || (pixel_x == 639) || (pixel_y == 0) || (pixel_y == 479)) begin
        red <= 4'hF;
        green <= 4'hF;
        blue <= 4'hF;
    end
    else begin
        if ((pixel_x >= 120 && pixel_x <= 140) && (pixel_y >= 0 && pixel_y <= 70)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 220 && pixel_x <= 280) && (pixel_y >= 120 && pixel_y <= 180)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 320 && pixel_x <= 340) && (pixel_y >= 0 && pixel_y <= 90)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 340 && pixel_x <= 370) && (pixel_y >= 40 && pixel_y <= 60)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 470 && pixel_x <= 600) && (pixel_y >= 0 && pixel_y <= 40)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 470 && pixel_x <= 640) && (pixel_y >= 100 && pixel_y <= 150)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 370 && pixel_x <= 400) && (pixel_y >= 180 && pixel_y <= 220)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 550 && pixel_x <= 640) && (pixel_y >= 250 && pixel_y <= 270)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 500 && pixel_x <= 530) && (pixel_y >= 320 && pixel_y <= 480)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 140 && pixel_x <= 160) && (pixel_y >= 200 && pixel_y <= 250)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 140 && pixel_x <= 220) && (pixel_y >= 380 && pixel_y <= 480)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 180 && pixel_x <= 280) && (pixel_y >= 300 && pixel_y <= 320)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 260 && pixel_x <= 370) && (pixel_y >= 230 && pixel_y <= 250)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 30 && pixel_x <= 60) && (pixel_y >= 160 && pixel_y <= 240)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 60 && pixel_x <= 90) && (pixel_y >= 160 && pixel_y <= 180)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 320 && pixel_x <= 340) && (pixel_y >= 280 && pixel_y <= 300)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 370 && pixel_x <= 440) && (pixel_y >= 250 && pixel_y <= 290)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 420 && pixel_x <= 440) && (pixel_y >= 290 && pixel_y <= 320)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 140 && pixel_x <= 160) && (pixel_y >= 200 && pixel_y <= 250)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 100 && pixel_x <= 140) && (pixel_y >= 260 && pixel_y <= 290)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
        else if ((pixel_x >= 120 && pixel_x <= 140) && (pixel_y >= 270 && pixel_y <= 320)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
    end
end


endmodule
