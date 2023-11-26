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
//    input clk_d,
//    input [9:0] pixel_x,
//    input [9:0] pixel_y,
//    input video_on,
//    output reg [3:0] red = 4'h0,  // Output for red component
//    output reg [3:0] green = 4'h0,  // Output for green component
//    output reg [3:0] blue = 4'h0  // Output for blue component
//);

//reg [9:0] aeroplane_x_reg = 20;  // Initial X position of the airplane
//reg [3:0] movement_counter = 0;

//wire aeroplane_gfx;
//aeroplane aeroplane_inst (.pixel_x(pixel_x), .pixel_y(pixel_y), .aeroplane_gfx(aeroplane_gfx));

//always @(posedge clk_d) begin
//    red <= 4'h0;
//    green <= 4'h0;
//    blue <= 4'h0;

//    // Automatically move the airplane to the right
//    if (movement_counter < 10) begin
//        aeroplane_x_reg <= aeroplane_x_reg + 1;
//        movement_counter <= movement_counter + 1;
//    end else begin
//        movement_counter <= 0;
//    end

//    if ((pixel_x == 0) || (pixel_x == 639) || (pixel_y == 0) || (pixel_y == 479)) begin
//        // Set maze walls to white
//        red <= 4'hF;
//        green <= 4'hF;
//        blue <= 4'hF;
//    end
//    else if (aeroplane_gfx) begin
//        // Set aeroplane color (e.g., red)
//        red <= 4'hF;
//        green <= 4'h0;
//        blue <= 4'h0;
//    end
//    else begin
//        // Draw maze walls based on pixel coordinates
//        // Add maze conditions here
//        // Example:
//        if ((pixel_x >= 100 && pixel_x <= 200) && (pixel_y >= 50 && pixel_y <= 150)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end else begin
//                if ((pixel_x >= 120 && pixel_x <= 140) && (pixel_y >= 0 && pixel_y <= 70)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 220 && pixel_x <= 280) && (pixel_y >= 120 && pixel_y <= 180)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 320 && pixel_x <= 340) && (pixel_y >= 0 && pixel_y <= 90)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 340 && pixel_x <= 370) && (pixel_y >= 40 && pixel_y <= 60)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 470 && pixel_x <= 600) && (pixel_y >= 0 && pixel_y <= 40)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 470 && pixel_x <= 640) && (pixel_y >= 100 && pixel_y <= 150)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 370 && pixel_x <= 400) && (pixel_y >= 180 && pixel_y <= 220)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 550 && pixel_x <= 640) && (pixel_y >= 250 && pixel_y <= 270)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 500 && pixel_x <= 530) && (pixel_y >= 320 && pixel_y <= 480)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 140 && pixel_x <= 160) && (pixel_y >= 200 && pixel_y <= 250)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 140 && pixel_x <= 220) && (pixel_y >= 380 && pixel_y <= 480)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 180 && pixel_x <= 280) && (pixel_y >= 300 && pixel_y <= 320)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 260 && pixel_x <= 370) && (pixel_y >= 230 && pixel_y <= 250)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 30 && pixel_x <= 60) && (pixel_y >= 160 && pixel_y <= 240)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 60 && pixel_x <= 90) && (pixel_y >= 160 && pixel_y <= 180)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 320 && pixel_x <= 340) && (pixel_y >= 280 && pixel_y <= 300)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 370 && pixel_x <= 440) && (pixel_y >= 250 && pixel_y <= 290)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 420 && pixel_x <= 440) && (pixel_y >= 290 && pixel_y <= 320)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 140 && pixel_x <= 160) && (pixel_y >= 200 && pixel_y <= 250)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 100 && pixel_x <= 140) && (pixel_y >= 260 && pixel_y <= 290)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
//        else if ((pixel_x >= 120 && pixel_x <= 140) && (pixel_y >= 270 && pixel_y <= 320)) begin
//            red <= 4'hF;
//            green <= 4'hF;
//            blue <= 4'hF;
//        end
        
//    end
//end
//end

//endmodule

module pixel_gen(
    input clk_d,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input video_on,
    output reg [3:0] red = 4'h0,  // Output for red component
    output reg [3:0] green = 4'h0,  // Output for green component
    output reg [3:0] blue = 4'h0  // Output for blue component
);

reg [9:0] aeroplane_x_reg = 20;  // Initial X position of the airplane
reg [3:0] movement_counter = 0;

wire aeroplane_gfx;
aeroplane aeroplane_inst (.pixel_x(pixel_x), .pixel_y(pixel_y), .aeroplane_gfx(aeroplane_gfx));

always @(posedge clk_d) begin
    red <= 4'h0;
    green <= 4'h0;
    blue <= 4'h0;

    // Automatically move the airplane to the right
    if (movement_counter < 10) begin
        aeroplane_x_reg <= aeroplane_x_reg + 1;
        movement_counter <= movement_counter + 1;
    end else begin
        movement_counter <= 0;
    end

    if ((pixel_x == 0) || (pixel_x == 639) || (pixel_y == 0) || (pixel_y == 479)) begin
        // Set maze walls to white
        red <= 4'hF;
        green <= 4'hF;
        blue <= 4'hF;
    end
    else if (aeroplane_gfx) begin
        // Set aeroplane color (e.g., red)
        red <= 4'hF;
        green <= 4'h0;
        blue <= 4'h0;
    end
    else begin
//         Draw maze walls based on pixel coordinates
//         Add maze conditions here
//            else begin
        // Draw maze walls based on pixel coordinates
        // Add maze conditions here
        // Example:
        if ((pixel_x >= 100 && pixel_x <= 200) && (pixel_y >= 50 && pixel_y <= 150)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
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

        // Example:
        if ((pixel_x >= 100 && pixel_x <= 200) && (pixel_y >= 50 && pixel_y <= 150)) begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end
    end
end

endmodule
