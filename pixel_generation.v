`timescale 1ns / 1ps
module pixel_generation(
    input clk,                              // 100MHz from Basys 3
    input reset,                            // btnC
    input video_on,                         // from VGA controller
    input [9:0] x, y,    
    input KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT,
    output reg [11:0] rgb                   // to DAC, to VGA controller
    );
    
    reg [1:0] direction = 2'b00;
    reg [1:0] game_state = 2'b00;
    reg game_result = 1'b1;
    reg lives_rem = 2'b11;
    
//    always @(*) begin
//    if (game_state == 2'b00 && KEY_UP) game_state = 2'b01;
//    end
    
    parameter X_MAX = 639;                  // right border of display area
    parameter Y_MAX = 479;                  // bottom border of display area
    parameter SQ_RGB = 12'h00F;             // blue square
    parameter BG_RGB = 12'h000;             // black background
    parameter SQUARE_SIZE = 32;             // width of square sides in pixels
    parameter SQUARE_VELOCITY_POS = 0.5;          // set position change value for positive direction
    parameter SQUARE_VELOCITY_NEG = -0.5;
    parameter RECT_RGB = 12'hFFF;
    parameter FLAG_RGB = 12'hF00;
    parameter FLAG_STICK_RGB = 12'hFF0;
    parameter GAME_OVER_RGB = 12'hF0F;
    parameter GAME_START_RGB = 12'h000;
    parameter START_RGB = 12'hFFF;
    parameter WON_RGB = 12'hFFF;
    parameter LOST_RGB = 12'hFFF;
    parameter LIVES_RGB = 12'hF0F;
    
    // create a 60Hz refresh tick at the start of vsync 
    wire refresh_tick;
    assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0;
    
    // square boundaries and position
    wire [9:0] sq_x_l, sq_x_r;              // body left and right boundary
    wire [9:0] sq_y_t, sq_y_b;              // body top and bottom boundary
    
    reg [9:0] sq_x_reg, sq_y_reg;           // regs to track left, top position of body
    wire [9:0] sq_x_next, sq_y_next;        // buffer wires
    
    reg [9:0] x_delta_reg, y_delta_reg;     // track plane body speed
    reg [9:0] x_delta_next, y_delta_next;   // buffer regs 
    
    // register control
    always @(posedge clk or posedge reset)
        if(reset) begin
            sq_x_reg <= 0;
            sq_y_reg <= 430;
            //this is constant
            x_delta_reg <= SQUARE_VELOCITY_POS;
            y_delta_reg <= SQUARE_VELOCITY_POS;
            direction <= 2'b00;
            
//            if (direction == 2'b00 && KEY_UP) game_state = 2'b01;
        end
        else begin
            if (game_state == 2'b00 && KEY_UP) game_state = 2'b01;
            
            if (game_state == 2'b10 && KEY_UP) game_state <= 2'b00;
            
            if (game_state == 2'b01 && lives_rem == 2'b00) game_state <= 2'b10;
            
            if (game_state == 2'b01) begin
                sq_x_reg <= sq_x_next;
                sq_y_reg <= sq_y_next;
                //these two lines are currently doing nothing cuz x_delta is constant for now
                x_delta_reg <= x_delta_next;
                y_delta_reg <= y_delta_next;
                
                
                
                if (KEY_UP) direction <= 2'b00; // Up
                else if (KEY_DOWN) direction <= 2'b01; // Down
                else if (KEY_LEFT) direction <= 2'b10; // Left
                else if (KEY_RIGHT) direction <= 2'b11; // Right
                
                if ((sq_x_r >= 610 && sq_y_t <= 30) || lives_rem == 2'b00) begin
                    game_state = 2'b10;
                    sq_x_reg <= 0;
                    sq_y_reg <= 430;
                end
                
//                if (
//    ((sq_y_reg - y_delta_reg) >= 50 && (sq_y_reg - y_delta_reg) <= 150 && (sq_x_reg >= 100) && (sq_x_reg <= 200)) &&
//    ((sq_y_reg - y_delta_reg) >= 0 && (sq_y_reg - y_delta_reg) <= 70 && (sq_x_reg >= 120) && (sq_x_reg <= 140)) &&
//    ((sq_y_reg - y_delta_reg) >= 120 && (sq_y_reg - y_delta_reg) <= 180 && (sq_x_reg >= 220) && (sq_x_reg <= 280)) &&
//    ((sq_y_reg - y_delta_reg) >= 0 && (sq_y_reg - y_delta_reg) <= 90 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//    ((sq_y_reg - y_delta_reg) >= 0 && (sq_y_reg - y_delta_reg) <= 40 && (sq_x_reg >= 470) && (sq_x_reg <= 600)) &&
//    ((sq_y_reg - y_delta_reg) >= 180 && (sq_y_reg - y_delta_reg) <= 220 && (sq_x_reg >= 370) && (sq_x_reg <= 400)) &&
//    ((sq_y_reg - y_delta_reg) >= 250 && (sq_y_reg - y_delta_reg) <= 270 && (sq_x_reg >= 550) && (sq_x_reg <= 640)) &&
//    ((sq_y_reg - y_delta_reg) >= 320 && (sq_y_reg - y_delta_reg) <= 480 && (sq_x_reg >= 500) && (sq_x_reg <= 530)) &&
//    ((sq_y_reg - y_delta_reg) >= 380 && (sq_y_reg - y_delta_reg) <= 480 && (sq_x_reg >= 140) && (sq_x_reg <= 220)) &&
//    ((sq_y_reg - y_delta_reg) >= 300 && (sq_y_reg - y_delta_reg) <= 320 && (sq_x_reg >= 180) && (sq_x_reg <= 280)) &&
//    ((sq_y_reg - y_delta_reg) >= 230 && (sq_y_reg - y_delta_reg) <= 250 && (sq_x_reg >= 260) && (sq_x_reg <= 370)) &&
//    ((sq_y_reg - y_delta_reg) >= 160 && (sq_y_reg - y_delta_reg) <= 240 && (sq_x_reg >= 30) && (sq_x_reg <= 60)) &&
//    ((sq_y_reg - y_delta_reg) >= 160 && (sq_y_reg - y_delta_reg) <= 180 && (sq_x_reg >= 60) && (sq_x_reg <= 90)) &&
//    ((sq_y_reg - y_delta_reg) >= 280 && (sq_y_reg - y_delta_reg) <= 300 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//    ((sq_y_reg - y_delta_reg) >= 290 && (sq_y_reg - y_delta_reg) <= 320 && (sq_x_reg >= 420) && (sq_x_reg <= 440)) &&
//    ((sq_y_reg - y_delta_reg) >= 200 && (sq_y_reg - y_delta_reg) <= 250 && (sq_x_reg >= 140) && (sq_x_reg <= 160)) &&
//    ((sq_y_reg - y_delta_reg) >= 260 && (sq_y_reg - y_delta_reg) <= 290 && (sq_x_reg >= 60) && (sq_x_reg <= 140)) &&
//    ((sq_y_reg - y_delta_reg) >= 270 && (sq_y_reg - y_delta_reg) <= 320 && (sq_x_reg >= 120) && (sq_x_reg <= 140)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 50 && (sq_y_reg + y_delta_reg + 32) <= 150 && (sq_x_reg >= 100) && (sq_x_reg <= 200)) &&
//   ((sq_y_reg + y_delta_reg + 32) >= 0 && (sq_y_reg + y_delta_reg + 32) <= 70 && (sq_x_reg >= 120) && (sq_x_reg <= 140)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 120 && (sq_y_reg + y_delta_reg + 32) <= 180 && (sq_x_reg >= 220) && (sq_x_reg <= 280)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 0 && (sq_y_reg + y_delta_reg + 32) <= 90 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 0 && (sq_y_reg + y_delta_reg + 32) <= 40 && (sq_x_reg >= 470) && (sq_x_reg <= 600)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 180 && (sq_y_reg + y_delta_reg + 32) <= 220 && (sq_x_reg >= 370) && (sq_x_reg <= 400)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 250 && (sq_y_reg + y_delta_reg + 32) <= 270 && (sq_x_reg >= 550) && (sq_x_reg <= 640)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 320 && (sq_y_reg + y_delta_reg + 32) <= 480 && (sq_x_reg >= 500) && (sq_x_reg <= 530)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 380 && (sq_y_reg + y_delta_reg + 32) <= 480 && (sq_x_reg >= 140) && (sq_x_reg <= 220)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 300 && (sq_y_reg + y_delta_reg + 32) <= 320 && (sq_x_reg >= 180) && (sq_x_reg <= 280)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 230 && (sq_y_reg + y_delta_reg + 32) <= 250 && (sq_x_reg >= 260) && (sq_x_reg <= 370)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 160 && (sq_y_reg + y_delta_reg + 32) <= 240 && (sq_x_reg >= 30) && (sq_x_reg <= 60)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 160 && (sq_y_reg + y_delta_reg + 32) <= 180 && (sq_x_reg >= 60) && (sq_x_reg <= 90)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 280 && (sq_y_reg + y_delta_reg + 32) <= 300 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 290 && (sq_y_reg + y_delta_reg + 32) <= 320 && (sq_x_reg >= 420) && (sq_x_reg <= 440)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 200 && (sq_y_reg + y_delta_reg + 32) <= 250 && (sq_x_reg >= 140) && (sq_x_reg <= 160)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 260 && (sq_y_reg + y_delta_reg + 32) <= 290 && (sq_x_reg >= 60) && (sq_x_reg <= 140)) &&
//    ((sq_y_reg + y_delta_reg + 32) >= 270 && (sq_y_reg + y_delta_reg + 32) <= 320 && (sq_x_reg >= 120) && (sq_x_reg <= 140))
//) begin
//    // Your code here
////    lives_rem = lives_rem - 1'b1;
//    if (lives_rem == 2'b11) lives_rem <= 2'b10;
//    else if (lives_rem == 2'b10) lives_rem <= 2'b01;
//    else if (lives_rem == 2'b01) lives_rem <= 2'b00;
//    else if (lives_rem == 2'b00) game_state <= 2'b10;
    

//end
end
end
                
//                if (
//    !((sq_y_reg - y_delta_reg) >= 50 && (sq_y_reg - y_delta_reg) <= 150 && (sq_x_reg >= 100) && (sq_x_reg <= 200)) &&
//    !((sq_y_reg - y_delta_reg) >= 0 && (sq_y_reg - y_delta_reg) <= 70 && (sq_x_reg >= 120) && (sq_x_reg <= 140)) &&
//    !((sq_y_reg - y_delta_reg) >= 120 && (sq_y_reg - y_delta_reg) <= 180 && (sq_x_reg >= 220) && (sq_x_reg <= 280)) &&
//    !((sq_y_reg - y_delta_reg) >= 0 && (sq_y_reg - y_delta_reg) <= 90 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//    !((sq_y_reg - y_delta_reg) >= 0 && (sq_y_reg - y_delta_reg) <= 40 && (sq_x_reg >= 470) && (sq_x_reg <= 600)) &&
//    !((sq_y_reg - y_delta_reg) >= 180 && (sq_y_reg - y_delta_reg) <= 220 && (sq_x_reg >= 370) && (sq_x_reg <= 400)) &&
//    !((sq_y_reg - y_delta_reg) >= 250 && (sq_y_reg - y_delta_reg) <= 270 && (sq_x_reg >= 550) && (sq_x_reg <= 640)) &&
//    !((sq_y_reg - y_delta_reg) >= 320 && (sq_y_reg - y_delta_reg) <= 480 && (sq_x_reg >= 500) && (sq_x_reg <= 530)) &&
//    !((sq_y_reg - y_delta_reg) >= 380 && (sq_y_reg - y_delta_reg) <= 480 && (sq_x_reg >= 140) && (sq_x_reg <= 220)) &&
//    !((sq_y_reg - y_delta_reg) >= 300 && (sq_y_reg - y_delta_reg) <= 320 && (sq_x_reg >= 180) && (sq_x_reg <= 280)) &&
//    !((sq_y_reg - y_delta_reg) >= 230 && (sq_y_reg - y_delta_reg) <= 250 && (sq_x_reg >= 260) && (sq_x_reg <= 370)) &&
//    !((sq_y_reg - y_delta_reg) >= 160 && (sq_y_reg - y_delta_reg) <= 240 && (sq_x_reg >= 30) && (sq_x_reg <= 60)) &&
//    !((sq_y_reg - y_delta_reg) >= 160 && (sq_y_reg - y_delta_reg) <= 180 && (sq_x_reg >= 60) && (sq_x_reg <= 90)) &&
//    !((sq_y_reg - y_delta_reg) >= 280 && (sq_y_reg - y_delta_reg) <= 300 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//    !((sq_y_reg - y_delta_reg) >= 290 && (sq_y_reg - y_delta_reg) <= 320 && (sq_x_reg >= 420) && (sq_x_reg <= 440)) &&
//    !((sq_y_reg - y_delta_reg) >= 200 && (sq_y_reg - y_delta_reg) <= 250 && (sq_x_reg >= 140) && (sq_x_reg <= 160)) &&
//    !((sq_y_reg - y_delta_reg) >= 260 && (sq_y_reg - y_delta_reg) <= 290 && (sq_x_reg >= 60) && (sq_x_reg <= 140)) &&
//    !((sq_y_reg - y_delta_reg) >= 270 && (sq_y_reg - y_delta_reg) <= 320 && (sq_x_reg >= 120) && (sq_x_reg <= 140)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 50 && (sq_y_reg + y_delta_reg + 32) <= 150 && (sq_x_reg >= 100) && (sq_x_reg <= 200)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 0 && (sq_y_reg + y_delta_reg + 32) <= 70 && (sq_x_reg >= 120) && (sq_x_reg <= 140)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 120 && (sq_y_reg + y_delta_reg + 32) <= 180 && (sq_x_reg >= 220) && (sq_x_reg <= 280)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 0 && (sq_y_reg + y_delta_reg + 32) <= 90 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 0 && (sq_y_reg + y_delta_reg + 32) <= 40 && (sq_x_reg >= 470) && (sq_x_reg <= 600)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 180 && (sq_y_reg + y_delta_reg + 32) <= 220 && (sq_x_reg >= 370) && (sq_x_reg <= 400)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 250 && (sq_y_reg + y_delta_reg + 32) <= 270 && (sq_x_reg >= 550) && (sq_x_reg <= 640)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 320 && (sq_y_reg + y_delta_reg + 32) <= 480 && (sq_x_reg >= 500) && (sq_x_reg <= 530)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 380 && (sq_y_reg + y_delta_reg + 32) <= 480 && (sq_x_reg >= 140) && (sq_x_reg <= 220)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 300 && (sq_y_reg + y_delta_reg + 32) <= 320 && (sq_x_reg >= 180) && (sq_x_reg <= 280)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 230 && (sq_y_reg + y_delta_reg + 32) <= 250 && (sq_x_reg >= 260) && (sq_x_reg <= 370)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 160 && (sq_y_reg + y_delta_reg + 32) <= 240 && (sq_x_reg >= 30) && (sq_x_reg <= 60)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 160 && (sq_y_reg + y_delta_reg + 32) <= 180 && (sq_x_reg >= 60) && (sq_x_reg <= 90)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 280 && (sq_y_reg + y_delta_reg + 32) <= 300 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 290 && (sq_y_reg + y_delta_reg + 32) <= 320 && (sq_x_reg >= 420) && (sq_x_reg <= 440)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 200 && (sq_y_reg + y_delta_reg + 32) <= 250 && (sq_x_reg >= 140) && (sq_x_reg <= 160)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 260 && (sq_y_reg + y_delta_reg + 32) <= 290 && (sq_x_reg >= 60) && (sq_x_reg <= 140)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 270 && (sq_y_reg + y_delta_reg + 32) <= 320 && (sq_x_reg >= 120) && (sq_x_reg <= 140))
//&& game_state == 2'b01) begin
//    // Your code here
//    lives_rem = lives_rem - 1'b1;
//end

                
//                if ((sq_x_r >= 610 && sq_y_t <= 30) || lives_rem == 2'b00) begin
//                    game_state = 2'b10;
//                    sq_x_reg <= 0;
//                    sq_y_reg <= 430;
//                end
            
        
    // square boundaries
    assign sq_x_l = sq_x_reg;                   // left boundary
    assign sq_y_t = sq_y_reg;                   // top boundary
    assign sq_x_r = (sq_x_l + SQUARE_SIZE) - 16;   // right boundary
    assign sq_y_b = sq_y_t + SQUARE_SIZE - 1;   // bottom boundary
    
    // square status signal
    wire sq_on;
    assign sq_on = (sq_x_l <= x) && (x <= sq_x_r) && (sq_y_t <= y) && (y <= sq_y_b) && game_state == 2'b01;

//    assign sq_x_next = (refresh_tick) ?
//        (sq_x_r >= X_MAX ) ? sq_x_reg - x_delta_reg :  // Reverse direction on X-axis collision
//        (sq_x_l <= 0) ? sq_x_reg + x_delta_reg :
//        (direction == 2'b10) ? (sq_x_reg - x_delta_reg) :
//        (direction == 2'b11) ? (sq_x_reg + x_delta_reg) : sq_x_reg :
//        sq_x_reg;
    
//    assign sq_y_next = (refresh_tick) ?
//        (sq_y_t <= 0 ) ? sq_y_reg + y_delta_reg :    // Reverse direction on Y-axis collision
//        (sq_y_b >= Y_MAX) ? sq_y_reg - y_delta_reg:
//        (direction == 2'b00) ? (sq_y_reg - y_delta_reg) :
//        (direction == 2'b01) ? (sq_y_reg + y_delta_reg) : sq_y_reg :
//        sq_y_reg;
    assign sq_on = (sq_x_l <= x) && (x <= sq_x_r) && (sq_y_t <= y) && (y <= sq_y_b) && game_state == 2'b01;

        assign sq_x_next = (refresh_tick) ?
        (sq_x_r >= X_MAX) ? sq_x_reg - x_delta_reg :  // Reverse direction on X-axis collision
        (sq_x_l <= 0) ? sq_x_reg + x_delta_reg :
        ((direction == 2'b10) &&!((sq_x_reg - x_delta_reg) >= 100 &&(sq_x_reg - x_delta_reg) <= 200 && (sq_y_reg >= 50) && (sq_y_reg <= 150)) &&
                                !((sq_x_reg - x_delta_reg) >= 120 && (sq_x_reg - x_delta_reg) <= 140 && (sq_y_reg >= 0) && (sq_y_reg <= 70)) &&
                                !((sq_x_reg - x_delta_reg) >= 240 && (sq_x_reg - x_delta_reg) <= 280 && (sq_y_reg >= 120) && (sq_y_reg <= 180)) &&
                                !((sq_x_reg - x_delta_reg) >= 320 && (sq_x_reg - x_delta_reg) <= 340 && (sq_y_reg >= 0) && (sq_y_reg <= 90)) && 
//                                !((sq_x_reg - x_delta_reg-16) >= 340 && (sq_x_reg - x_delta_reg-16) <= 370 && (sq_y_reg >= 40) && (sq_y_reg <= 60)) &&
                                !((sq_x_reg - x_delta_reg) >= 470 && (sq_x_reg - x_delta_reg) <= 600 && (sq_y_reg >= 0) && (sq_y_reg <= 40)) &&
                                !((sq_x_reg - x_delta_reg) >= 370 && (sq_x_reg - x_delta_reg) <= 400 && (sq_y_reg >= 180) && (sq_y_reg <= 220)) &&
                                !((sq_x_reg - x_delta_reg) >= 550 && (sq_x_reg - x_delta_reg) <= 640 && (sq_y_reg >= 250) && (sq_y_reg <= 270)) &&
                                !((sq_x_reg - x_delta_reg) >= 500 && (sq_x_reg - x_delta_reg) <= 530 && (sq_y_reg >= 288) && (sq_y_reg <= 480)) &&
//                                !((sq_x_reg - x_delta_reg-16) >= 140 && (sq_x_reg - x_delta_reg-16) <= 160 && (sq_y_reg >= 200) && (sq_y_reg <= 250)) &&
                                !((sq_x_reg - x_delta_reg) >= 140 && (sq_x_reg - x_delta_reg) <= 220 && (sq_y_reg >= 248) && (sq_y_reg <= 480)) &&
                                !((sq_x_reg - x_delta_reg) >= 180 && (sq_x_reg - x_delta_reg) <= 280 && (sq_y_reg >= 300) && (sq_y_reg <= 320)) &&
                                !((sq_x_reg - x_delta_reg) >= 260 && (sq_x_reg - x_delta_reg) <= 370 && (sq_y_reg >= 230) && (sq_y_reg <= 250)) &&
                                !((sq_x_reg - x_delta_reg) >= 30 &&  (sq_x_reg - x_delta_reg) <= 60 &&   (sq_y_reg >= 160) && (sq_y_reg <= 240)) &&
                                !((sq_x_reg - x_delta_reg) >= 60 &&  (sq_x_reg - x_delta_reg) <= 90 &&   (sq_y_reg >= 160) && (sq_y_reg <= 180)) &&
                                !((sq_x_reg - x_delta_reg) >= 320 && (sq_x_reg - x_delta_reg) <= 340 && (sq_y_reg >= 280) && (sq_y_reg <= 300)) &&
//                                !((sq_x_reg - x_delta_reg-16) >= 370 && (sq_x_reg - x_delta_reg-16) <= 440 && (sq_y_reg >= 250) && (sq_y_reg <= 290)) &&
                                !((sq_x_reg - x_delta_reg) >= 420 && (sq_x_reg - x_delta_reg) <= 440 && (sq_y_reg >= 290) && (sq_y_reg <= 320)) &&
                                !((sq_x_reg - x_delta_reg) >= 140 && (sq_x_reg - x_delta_reg) <= 160 && (sq_y_reg >= 200) && (sq_y_reg <= 250)) &&
                                !((sq_x_reg - x_delta_reg) >= 60 && (sq_x_reg - x_delta_reg) <= 140 && (sq_y_reg >= 260) && (sq_y_reg <= 290)) &&
                                !((sq_x_reg - x_delta_reg) >= 120 && (sq_x_reg - x_delta_reg) <= 140 && (sq_y_reg >= 270) && (sq_y_reg <= 320)))
                                ? (sq_x_reg - x_delta_reg) :
                                
        ((direction == 2'b11) &&!((sq_x_reg + x_delta_reg +16 ) >= 100 && (sq_x_reg + x_delta_reg +16) <= 200 && (sq_y_reg >= 50) && (sq_y_reg <= 150)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 120 && (sq_x_reg + x_delta_reg +16) <= 140 && (sq_y_reg >= 0) && (sq_y_reg <= 70)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 220 && (sq_x_reg + x_delta_reg +16) <= 280 && (sq_y_reg >= 120) && (sq_y_reg <= 180)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 320 && (sq_x_reg + x_delta_reg +16) <= 340 && (sq_y_reg >= 0 ) && (sq_y_reg <= 90)) && 
//                                !((sq_x_reg + x_delta_reg +16 ) >= 340 && (sq_x_reg + x_delta_reg +16) <= 370 && (sq_y_reg >= 40) && (sq_y_reg <= 60)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 470 && (sq_x_reg + x_delta_reg +16) <= 600 && (sq_y_reg >= 0 ) && (sq_y_reg <= 40)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 370 && (sq_x_reg + x_delta_reg +16) <= 400 && (sq_y_reg >= 180) && (sq_y_reg <= 220)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 550 && (sq_x_reg + x_delta_reg +16) <= 640 && (sq_y_reg >= 250) && (sq_y_reg <= 270)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 500 && (sq_x_reg + x_delta_reg +16) <= 530 && (sq_y_reg >= 288) && (sq_y_reg <= 480)) &&
//                                !((sq_x_reg + x_delta_reg +16 ) >= 140 && (sq_x_reg + x_delta_reg +16) <= 160 && (sq_y_reg >= 200) && (sq_y_reg <= 250)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 140 && (sq_x_reg + x_delta_reg +16) <= 220 && (sq_y_reg >= 348) && (sq_y_reg <= 480)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 180 && (sq_x_reg + x_delta_reg +16) <= 280 && (sq_y_reg >= 300) && (sq_y_reg <= 320)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 260 && (sq_x_reg + x_delta_reg +16) <= 370 && (sq_y_reg >= 230) && (sq_y_reg <= 250)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 30 &&  (sq_x_reg + x_delta_reg +16) <= 60 &&  (sq_y_reg >= 160) && (sq_y_reg <= 240)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 60 &&  (sq_x_reg + x_delta_reg +16) <= 90 &&  (sq_y_reg >= 160) && (sq_y_reg <= 180)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 320 && (sq_x_reg + x_delta_reg +16) <= 340 && (sq_y_reg >= 280) && (sq_y_reg <= 300)) &&
//                                !((sq_x_reg + x_delta_reg +16 ) >= 370 && (sq_x_reg + x_delta_reg +16) <= 440 && (sq_y_reg >= 250) && (sq_y_reg <= 290)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 420 && (sq_x_reg + x_delta_reg +16) <= 440 && (sq_y_reg >= 290) && (sq_y_reg <= 320)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 140 && (sq_x_reg + x_delta_reg +16) <= 160 && (sq_y_reg >= 200) && (sq_y_reg <= 250)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 60 && (sq_x_reg + x_delta_reg +16) <= 140 && (sq_y_reg >= 260) && (sq_y_reg <= 290)) &&
                                !((sq_x_reg + x_delta_reg +16 ) >= 120 && (sq_x_reg + x_delta_reg +16) <= 140 && (sq_y_reg >= 270) && (sq_y_reg <= 320)))
                                ? (sq_x_reg + x_delta_reg) : sq_x_reg :
        sq_x_reg;

    assign sq_y_next = (refresh_tick) ?
        (sq_y_t <= 0) ? sq_y_reg + y_delta_reg :    // Reverse direction on Y-axis collision
        (sq_y_b >= Y_MAX) ? sq_y_reg - y_delta_reg :
        ((direction == 2'b00) &&!((sq_y_reg - y_delta_reg) >= 50 &&  (sq_y_reg - y_delta_reg) <= 150 && (sq_x_reg >= 100) && (sq_x_reg <= 200)) &&
                                !((sq_y_reg - y_delta_reg) >= 0 &&   (sq_y_reg - y_delta_reg) <= 70 && (sq_x_reg >= 120) && (sq_x_reg <= 140)) &&
                                !((sq_y_reg - y_delta_reg) >= 120 && (sq_y_reg - y_delta_reg) <= 180 && (sq_x_reg >= 220) && (sq_x_reg <= 280)) &&
                                !((sq_y_reg - y_delta_reg) >= 0 &&   (sq_y_reg - y_delta_reg) <= 90 && (sq_x_reg >= 320) && (sq_x_reg <= 340))  &&
//                                !((sq_y_reg - y_delta_reg-32) >= 40 &&  (sq_y_reg - y_delta_reg -32) <= 60 && (sq_x_reg >= 340) && (sq_x_reg <= 370)) &&
                                !((sq_y_reg - y_delta_reg) >= 0 &&   (sq_y_reg - y_delta_reg) <= 40 && (sq_x_reg >= 470) && (sq_x_reg <= 600)) &&
                                !((sq_y_reg - y_delta_reg) >= 180 && (sq_y_reg - y_delta_reg) <= 220 && (sq_x_reg >= 370) && (sq_x_reg <= 400)) &&
                                !((sq_y_reg - y_delta_reg) >= 250 && (sq_y_reg - y_delta_reg) <= 270 && (sq_x_reg >= 550) && (sq_x_reg <= 640)) && 
                                !((sq_y_reg - y_delta_reg) >= 320 && (sq_y_reg - y_delta_reg) <= 480 && (sq_x_reg >= 500) && (sq_x_reg <= 530)) &&
//                                !((sq_y_reg - y_delta_reg-32) >= 200 && (sq_y_reg - y_delta_reg -32) <= 250 && (sq_x_reg >= 140) && (sq_x_reg <= 160)) &&
                                !((sq_y_reg - y_delta_reg) >= 380 && (sq_y_reg - y_delta_reg) <= 480 && (sq_x_reg >= 140) && (sq_x_reg <= 220)) &&
                                !((sq_y_reg - y_delta_reg) >= 300 && (sq_y_reg - y_delta_reg) <= 320 && (sq_x_reg >= 180) && (sq_x_reg <= 280))  &&
                                !((sq_y_reg - y_delta_reg) >= 230 && (sq_y_reg - y_delta_reg) <= 250 && (sq_x_reg >= 260) && (sq_x_reg <= 370)) &&
                                !((sq_y_reg - y_delta_reg) >= 160 && (sq_y_reg - y_delta_reg) <= 240 && (sq_x_reg >= 30) && (sq_x_reg <= 60)) &&
                                !((sq_y_reg - y_delta_reg) >= 160 && (sq_y_reg - y_delta_reg) <= 180 && (sq_x_reg >= 60) && (sq_x_reg <= 90)) &&
                                !((sq_y_reg - y_delta_reg) >= 280 && (sq_y_reg - y_delta_reg) <= 300 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//                                !((sq_y_reg - y_delta_reg-32) >= 250 && (sq_y_reg - y_delta_reg -32) <= 290 && (sq_x_reg >= 370) && (sq_x_reg <= 440)) &&
                                !((sq_y_reg - y_delta_reg) >= 290 && (sq_y_reg - y_delta_reg) <= 320 && (sq_x_reg >= 420) && (sq_x_reg <= 440)) &&
                                !((sq_y_reg - y_delta_reg) >= 200 && (sq_y_reg - y_delta_reg) <= 250 && (sq_x_reg >= 140) && (sq_x_reg <= 160))  &&
                                !((sq_y_reg - y_delta_reg) >= 260 && (sq_y_reg - y_delta_reg) <= 290 && (sq_x_reg >= 60) && (sq_x_reg <= 140)) &&
                                !((sq_y_reg - y_delta_reg) >= 270 && (sq_y_reg - y_delta_reg) <= 320 && (sq_x_reg >= 120) && (sq_x_reg <= 140)))
                                ? (sq_y_reg - y_delta_reg) :
        
        
        ((direction == 2'b01) && !((sq_y_reg + y_delta_reg+32) >= 50 && (sq_y_reg + y_delta_reg+32) <= 150 && (sq_x_reg >= 100) && (sq_x_reg <= 200)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 0 && (sq_y_reg + y_delta_reg+32) <= 70 && (sq_x_reg >= 120) && (sq_x_reg <= 140)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 120 && (sq_y_reg + y_delta_reg+32) <= 180 && (sq_x_reg >= 220) && (sq_x_reg <= 280)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 0 && (sq_y_reg + y_delta_reg+32) <= 90 && (sq_x_reg >= 320) && (sq_x_reg <= 340))  &&
//                                !((sq_y_reg + y_delta_reg+32) >= 40 && (sq_y_reg + y_delta_reg+32) <= 60 && (sq_x_reg >= 340) && (sq_x_reg <= 370)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 0 && (sq_y_reg + y_delta_reg+32) <= 40 && (sq_x_reg >= 470) && (sq_x_reg <= 600)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 180 && (sq_y_reg + y_delta_reg+32) <= 220 && (sq_x_reg >= 370) && (sq_x_reg <= 400)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 250 && (sq_y_reg + y_delta_reg+32) <= 270 && (sq_x_reg >= 550) && (sq_x_reg <= 640)) && 
                                !((sq_y_reg + y_delta_reg+32) >= 320 && (sq_y_reg + y_delta_reg+32) <= 480 && (sq_x_reg >= 500) && (sq_x_reg <= 530)) &&
//                                !((sq_y_reg + y_delta_reg+32) >= 200 && (sq_y_reg + y_delta_reg+32) <= 250 && (sq_x_reg >= 140) && (sq_x_reg <= 160)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 380 && (sq_y_reg + y_delta_reg+32) <= 480 && (sq_x_reg >= 140) && (sq_x_reg <= 220)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 300 && (sq_y_reg + y_delta_reg+32) <= 320 && (sq_x_reg >= 180) && (sq_x_reg <= 280))  &&
                                !((sq_y_reg + y_delta_reg+32) >= 230 && (sq_y_reg + y_delta_reg+32) <= 250 && (sq_x_reg >= 260) && (sq_x_reg <= 370)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 160 && (sq_y_reg + y_delta_reg+32) <= 240 && (sq_x_reg >= 30) && (sq_x_reg <= 60)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 160 && (sq_y_reg + y_delta_reg+32) <= 180 && (sq_x_reg >= 60) && (sq_x_reg <= 90)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 280 && (sq_y_reg + y_delta_reg+32) <= 300 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//                                !((sq_y_reg + y_delta_reg+32) >= 250 && (sq_y_reg + y_delta_reg+32) <= 290 && (sq_x_reg >= 370) && (sq_x_reg <= 440)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 290 && (sq_y_reg + y_delta_reg+32) <= 320 && (sq_x_reg >= 420) && (sq_x_reg <= 440)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 200 && (sq_y_reg + y_delta_reg+32) <= 250 && (sq_x_reg >= 140) && (sq_x_reg <= 160))  &&
                                !((sq_y_reg + y_delta_reg+32) >= 260 && (sq_y_reg + y_delta_reg+32) <= 290 && (sq_x_reg >= 60) && (sq_x_reg <= 140)) &&
                                !((sq_y_reg + y_delta_reg+32) >= 270 && (sq_y_reg + y_delta_reg+32) <= 320 && (sq_x_reg >= 120) && (sq_x_reg <= 140)))
                                ? (sq_y_reg + y_delta_reg+32) : sq_y_reg:
        sq_y_reg;
    // new square velocity 
    always @* begin
        x_delta_next = x_delta_reg;
        y_delta_next = y_delta_reg;
        if(sq_y_t < 1)                              // collide with top display edge
            y_delta_next = 0.5;                       // no change in y direction
        else if(sq_x_r >= X_MAX)                   // collide with right display edge
            x_delta_next = 0.5; 
//        if (
//    !((sq_y_reg - y_delta_reg) >= 50 && (sq_y_reg - y_delta_reg) <= 150 && (sq_x_reg >= 100) && (sq_x_reg <= 200)) &&
//    !((sq_y_reg - y_delta_reg) >= 0 && (sq_y_reg - y_delta_reg) <= 70 && (sq_x_reg >= 120) && (sq_x_reg <= 140)) &&
//    !((sq_y_reg - y_delta_reg) >= 120 && (sq_y_reg - y_delta_reg) <= 180 && (sq_x_reg >= 220) && (sq_x_reg <= 280)) &&
//    !((sq_y_reg - y_delta_reg) >= 0 && (sq_y_reg - y_delta_reg) <= 90 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//    !((sq_y_reg - y_delta_reg) >= 0 && (sq_y_reg - y_delta_reg) <= 40 && (sq_x_reg >= 470) && (sq_x_reg <= 600)) &&
//    !((sq_y_reg - y_delta_reg) >= 180 && (sq_y_reg - y_delta_reg) <= 220 && (sq_x_reg >= 370) && (sq_x_reg <= 400)) &&
//    !((sq_y_reg - y_delta_reg) >= 250 && (sq_y_reg - y_delta_reg) <= 270 && (sq_x_reg >= 550) && (sq_x_reg <= 640)) &&
//    !((sq_y_reg - y_delta_reg) >= 320 && (sq_y_reg - y_delta_reg) <= 480 && (sq_x_reg >= 500) && (sq_x_reg <= 530)) &&
//    !((sq_y_reg - y_delta_reg) >= 380 && (sq_y_reg - y_delta_reg) <= 480 && (sq_x_reg >= 140) && (sq_x_reg <= 220)) &&
//    !((sq_y_reg - y_delta_reg) >= 300 && (sq_y_reg - y_delta_reg) <= 320 && (sq_x_reg >= 180) && (sq_x_reg <= 280)) &&
//    !((sq_y_reg - y_delta_reg) >= 230 && (sq_y_reg - y_delta_reg) <= 250 && (sq_x_reg >= 260) && (sq_x_reg <= 370)) &&
//    !((sq_y_reg - y_delta_reg) >= 160 && (sq_y_reg - y_delta_reg) <= 240 && (sq_x_reg >= 30) && (sq_x_reg <= 60)) &&
//    !((sq_y_reg - y_delta_reg) >= 160 && (sq_y_reg - y_delta_reg) <= 180 && (sq_x_reg >= 60) && (sq_x_reg <= 90)) &&
//    !((sq_y_reg - y_delta_reg) >= 280 && (sq_y_reg - y_delta_reg) <= 300 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//    !((sq_y_reg - y_delta_reg) >= 290 && (sq_y_reg - y_delta_reg) <= 320 && (sq_x_reg >= 420) && (sq_x_reg <= 440)) &&
//    !((sq_y_reg - y_delta_reg) >= 200 && (sq_y_reg - y_delta_reg) <= 250 && (sq_x_reg >= 140) && (sq_x_reg <= 160)) &&
//    !((sq_y_reg - y_delta_reg) >= 260 && (sq_y_reg - y_delta_reg) <= 290 && (sq_x_reg >= 60) && (sq_x_reg <= 140)) &&
//    !((sq_y_reg - y_delta_reg) >= 270 && (sq_y_reg - y_delta_reg) <= 320 && (sq_x_reg >= 120) && (sq_x_reg <= 140)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 50 && (sq_y_reg + y_delta_reg + 32) <= 150 && (sq_x_reg >= 100) && (sq_x_reg <= 200)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 0 && (sq_y_reg + y_delta_reg + 32) <= 70 && (sq_x_reg >= 120) && (sq_x_reg <= 140)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 120 && (sq_y_reg + y_delta_reg + 32) <= 180 && (sq_x_reg >= 220) && (sq_x_reg <= 280)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 0 && (sq_y_reg + y_delta_reg + 32) <= 90 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 0 && (sq_y_reg + y_delta_reg + 32) <= 40 && (sq_x_reg >= 470) && (sq_x_reg <= 600)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 180 && (sq_y_reg + y_delta_reg + 32) <= 220 && (sq_x_reg >= 370) && (sq_x_reg <= 400)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 250 && (sq_y_reg + y_delta_reg + 32) <= 270 && (sq_x_reg >= 550) && (sq_x_reg <= 640)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 320 && (sq_y_reg + y_delta_reg + 32) <= 480 && (sq_x_reg >= 500) && (sq_x_reg <= 530)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 380 && (sq_y_reg + y_delta_reg + 32) <= 480 && (sq_x_reg >= 140) && (sq_x_reg <= 220)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 300 && (sq_y_reg + y_delta_reg + 32) <= 320 && (sq_x_reg >= 180) && (sq_x_reg <= 280)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 230 && (sq_y_reg + y_delta_reg + 32) <= 250 && (sq_x_reg >= 260) && (sq_x_reg <= 370)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 160 && (sq_y_reg + y_delta_reg + 32) <= 240 && (sq_x_reg >= 30) && (sq_x_reg <= 60)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 160 && (sq_y_reg + y_delta_reg + 32) <= 180 && (sq_x_reg >= 60) && (sq_x_reg <= 90)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 280 && (sq_y_reg + y_delta_reg + 32) <= 300 && (sq_x_reg >= 320) && (sq_x_reg <= 340)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 290 && (sq_y_reg + y_delta_reg + 32) <= 320 && (sq_x_reg >= 420) && (sq_x_reg <= 440)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 200 && (sq_y_reg + y_delta_reg + 32) <= 250 && (sq_x_reg >= 140) && (sq_x_reg <= 160)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 260 && (sq_y_reg + y_delta_reg + 32) <= 290 && (sq_x_reg >= 60) && (sq_x_reg <= 140)) &&
//    !((sq_y_reg + y_delta_reg + 32) >= 270 && (sq_y_reg + y_delta_reg + 32) <= 320 && (sq_x_reg >= 120) && (sq_x_reg <= 140))
//) begin
//    // Your code here
//    lives_rem = lives_rem - 1'b1;
//end

    end
    
    
    wire rect_on;
    
    assign rect_on = ((x >= 100 && x <= 200) && (y >= 50 && y <= 150) ||
               (x >= 120 && x <= 140) && (y >= 0 && y <= 70) ||
               (x >= 240 && x <= 280) && (y >= 120 && y <= 180) ||
               (x >= 320 && x <= 340) && (y >= 0 && y <= 90) ||

               (x >= 470 && x <= 590) && (y >= 35 && y <= 150) ||
//               (x >= 370 && x <= 400) && (y >= 180 && y <= 220) ||
               (x >= 550 && x <= 640) && (y >= 250 && y <= 270) ||
               (x >= 500 && x <= 530) && (y >= 320 && y <= 480) ||
               
               (x >= 140 && x <= 220) && (y >= 380 && y <= 480) ||
               (x >= 180 && x <= 280) && (y >= 300 && y <= 320) ||
               (x >= 260 && x <= 370) && (y >= 230 && y <= 250) ||
//               (x >= 30 && x <= 60) && (y >= 160 && y <= 240) ||
               (x >= 60 && x <= 90) && (y >= 160 && y <= 180) ||
               (x >= 320 && x <= 340) && (y >= 280 && y <= 300) ||
               
               (x >= 420 && x <= 440) && (y >= 290 && y <= 320) ||
//               (x >= 140 && x <= 160) && (y >= 200 && y <= 250) ||
               (x >= 60 && x <= 140) && (y >= 260 && y <= 290) ||
               (x >= 120 && x <= 140) && (y >= 270 && y <= 320)) && (game_state == 2'b01);
               
   
    
    wire flag_on;
    assign flag_on = ((x >= 610 && x <= 630) && (y >= 0 && y <= 30) && (game_state == 2'b01));
    
    wire flag_stick_on;
    assign flag_stick_on = ((x >= 630 && x <= 635) && (y >= 0 && y <= 50) && (game_state == 2'b01));
    
    wire s_on;
    assign s_on = ((x >= 100 && x <= 140) && (y >= 200 && y <= 220) ||  // Top horizontal line
                   (x >= 100 && x <= 120) && (y >= 220 && y <= 240) ||  // Top left vertical line
                   (x >= 100 && x <= 140) && (y >= 240 && y <= 260) ||  // Middle horizontal line
                   (x >= 120 && x <= 140) && (y >= 260 && y <= 280) ||  // Bottom right vertical line
                   (x >= 100 && x <= 140) && (y >= 280 && y <= 300)) && game_state == 2'b00;   // Bottom horizontal line

    
    wire t_on;
    assign t_on = ((x >= 160 && x <= 200) && (y >= 200 && y <= 220) ||  // Top horizontal line
                   (x >= 175 && x <= 185) && (y >= 200 && y <= 300)) && game_state == 2'b00;
                   
    wire a_on;
    assign a_on = ((x >= 220 && x <= 240) && (y >= 200 && y <= 300) ||  // Left vertical line
                   (x >= 240 && x <= 260) && (y >= 200 && y <= 220) ||  // Top horizontal line
                   (x >= 240 && x <= 260) && (y >= 240 && y <= 260) ||  // Middle horizontal line
                   (x >= 260 && x <= 280) && (y >= 200 && y <= 300)) && game_state == 2'b00;   // Right vertical line
    
    // R
    wire r_on;
    assign r_on = ((x >= 300 && x <= 340) && (y >= 200 && y <= 250) ||  // Left vertical line
                   (x >= 300 && x <= 320) && (y >= 250 && y <= 300) ||  // Top horizontal line
                   (x >= 330 && x <= 340) && (y >= 250 && y <= 300)) && game_state == 2'b00;   // Bottom right diagonal line
    // T
    wire t2_on;
    assign t2_on = ((x >= 360 && x <= 400) && (y >= 200 && y <= 220) ||  // Top horizontal line
                    (x >= 375 && x <= 385) && (y >= 220 && y <= 300)) && game_state == 2'b00;   // Middle vertical line
    // RGB control
    
    wire won_on;
    assign won_on = (
    ((x >= 290) && (x <= 300) && (y >= 210) && (y <= 260)) ||
    ((x >= 310) && (x <= 320) && (y >= 220) && (y <= 260)) ||
    ((x >= 330) && (x <= 340) && (y >= 210) && (y <= 260)) ||
    ((x >= 300) && (x <= 310) && (y >= 250) && (y <= 260)) ||
    ((x >= 320) && (x <= 330) && (y >= 250) && (y <= 260))
) && (game_state == 2'b10) && (game_result == 1'b1);
    
    wire loss_on;
    assign loss_on = (
    ((x >= 280) && (x <= 290) && (y >= 200) && (y <= 240)) ||
    ((x >= 290) && (x <= 320) && (y >= 230) && (y <= 240))
) && (game_state == 2'b10) && (game_result == 1'b0);


    wire three_on;
    assign three_on = (
    ((x >= 5) && (x <= 15) && (y >= 5) && (y <= 10)) ||
    ((x >= 5) && (x <= 15) && (y >= 12) && (y <= 17)) ||
    ((x >= 5) && (x <= 15) && (y >= 20) && (y <= 25)) ||
    ((x >= 10) && (x <= 15) && (y >= 5) && (y <= 25)) && game_state == 2'b01 && lives_rem == 2'b11);
    
//   && game_state == 2'b01 && lives_rem == 2'b11
    wire two_on;
    assign two_on = (
    ((x >= 5) && (x <= 15) && (y >= 5) && (y <= 10)) ||
    ((x >= 12) && (x <= 15) && (y >= 10) && (y <= 17)) ||
    ((x >= 5) && (x <= 12) && (y >= 15) && (y <= 17)) ||
    ((x >= 5) && (x <= 8) && (y >= 17) && (y <= 24)) ||
    ((x >= 5) && (x <= 15) && (y >= 24) && (y <= 34)) && game_state == 2'b01 && lives_rem == 2'b10
) ;

    wire one_on;
    assign one_on = (((x >= 5) && (x <= 10) && (y >= 5) && (y <= 25))
    && game_state == 2'b01 && lives_rem == 2'b01
    );
    
    
    
    
    always @*
        if (~video_on)
            rgb = 12'h000;          // black (no value) outside display area
//        else if (game_state == 2'b00) // GAME_OVER state
//        rgb = GAME_START_RGB;    // Black screen for game over
//        else if (game_state == 2'b10) // GAME_OVER state
//            rgb = GAME_OVER_RGB;    // Black screen for game over
        else if (sq_on)
            rgb = SQ_RGB;           // yellow square
        else if (rect_on)
            rgb = RECT_RGB;         // white rectangle
        else if (flag_on)
            rgb = FLAG_RGB;
        else if (flag_stick_on)
            rgb = FLAG_STICK_RGB;
        else if (three_on && game_state == 2'b01)
            rgb = LIVES_RGB;
        else if (two_on && game_state == 2'b01 && lives_rem == 2'b10)
            rgb = LIVES_RGB;
        else if (one_on && game_state == 2'b01 && lives_rem == 2'b01)
            rgb = LIVES_RGB;
        else if (s_on && game_state == 2'b00)
            rgb = 12'hF00;          // Red for 'S'
        else if (t_on && game_state == 2'b00)
            rgb = 12'h0F0;          // Green for 'T'
        else if (a_on && game_state == 2'b00)
            rgb = 12'h00F;          // Blue for 'A'
        else if (r_on && game_state == 2'b00)
            rgb = 12'h0F0;       // Purple for 'R'
        else if (t2_on && game_state == 2'b00)
            rgb = 12'hF00;          // Orange for the second 'T
        else if (won_on && game_state == 2'b10 && game_result == 1'b1)
            rgb = 12'h000;
        else if (loss_on && game_state == 2'b10 && game_result == 1'b0)
            rgb = 12'h000;
        else if (!loss_on && !won_on && game_state == 2'b10) // GAME_OVER state
            rgb = GAME_OVER_RGB;    // Black screen for game over
        else
            rgb = BG_RGB;         // blue background
endmodule

