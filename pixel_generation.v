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
                
                if (sq_x_r >= 610 && sq_y_t <= 30) begin
                    game_state = 2'b10;
                    sq_x_reg <= 0;
                    sq_y_reg <= 430;
                end
            end
        end
        
    // square boundaries
    assign sq_x_l = sq_x_reg;                   // left boundary
    assign sq_y_t = sq_y_reg;                   // top boundary
    assign sq_x_r = (sq_x_l + SQUARE_SIZE) - 16;   // right boundary
    assign sq_y_b = sq_y_t + SQUARE_SIZE - 1;   // bottom boundary
    
    // square status signal
    wire sq_on;
    assign sq_on = (sq_x_l <= x) && (x <= sq_x_r) && (sq_y_t <= y) && (y <= sq_y_b) && game_state == 2'b01;

    assign sq_x_next = (refresh_tick) ?
        (sq_x_r >= X_MAX ) ? sq_x_reg - x_delta_reg :  // Reverse direction on X-axis collision
        (sq_x_l <= 0) ? sq_x_reg + x_delta_reg :
        (direction == 2'b10) ? (sq_x_reg - x_delta_reg) :
        (direction == 2'b11) ? (sq_x_reg + x_delta_reg) : sq_x_reg :
        sq_x_reg;
    
    assign sq_y_next = (refresh_tick) ?
        (sq_y_t <= 0 ) ? sq_y_reg + y_delta_reg :    // Reverse direction on Y-axis collision
        (sq_y_b >= Y_MAX) ? sq_y_reg - y_delta_reg:
        (direction == 2'b00) ? (sq_y_reg - y_delta_reg) :
        (direction == 2'b01) ? (sq_y_reg + y_delta_reg) : sq_y_reg :
        sq_y_reg;
    
    // new square velocity 
    always @* begin
        x_delta_next = x_delta_reg;
        y_delta_next = y_delta_reg;
       if(sq_y_t < 1)                              // collide with top display edge
           y_delta_next = 0.5;                       // no change in y direction
       else if(sq_x_r >= X_MAX)                   // collide with right display edge
           x_delta_next = 0.5;                       // no change in x direction

        // if(sq_y_t <= 1)                              // collide with top display edge
        //     y_delta_next = 0.5;   // change y direction(move down)
        // else if(sq_y_b >= Y_MAX - 1)                     // collide with bottom display edge
        //     y_delta_next = -0.5;     // change y direction(move up)
        // else if(sq_x_l <= 1)                         // collide with left display edge
        //     x_delta_next = 0.5;     // change x direction(move right)
        // else if(sq_x_r >= X_MAX - 1)                     // collide with right display edge
        //     x_delta_next = -0.5;     // change x direction(move left)
    end
    
    
    wire rect_on;
    
    assign rect_on = ((x >= 100 && x <= 200) && (y >= 50 && y <= 150) ||
               (x >= 120 && x <= 140) && (y >= 0 && y <= 70) ||
               (x >= 220 && x <= 280) && (y >= 120 && y <= 180) ||
               (x >= 320 && x <= 340) && (y >= 0 && y <= 90) ||
               (x >= 340 && x <= 370) && (y >= 40 && y <= 60) ||
               (x >= 470 && x <= 600) && (y >= 0 && y <= 40) ||
               (x >= 470 && x <= 640) && (y >= 100 && y <= 150) ||
               (x >= 370 && x <= 400) && (y >= 180 && y <= 220) ||
               (x >= 550 && x <= 640) && (y >= 250 && y <= 270) ||
               (x >= 500 && x <= 530) && (y >= 320 && y <= 480) ||
               (x >= 140 && x <= 160) && (y >= 200 && y <= 250) ||
               (x >= 140 && x <= 220) && (y >= 380 && y <= 480) ||
               (x >= 180 && x <= 280) && (y >= 300 && y <= 320) ||
               (x >= 260 && x <= 370) && (y >= 230 && y <= 250) ||
               (x >= 30 && x <= 60) && (y >= 160 && y <= 240) ||
               (x >= 60 && x <= 90) && (y >= 160 && y <= 180) ||
               (x >= 320 && x <= 340) && (y >= 280 && y <= 300) ||
               (x >= 370 && x <= 440) && (y >= 250 && y <= 290) ||
               (x >= 420 && x <= 440) && (y >= 290 && y <= 320) ||
               (x >= 140 && x <= 160) && (y >= 200 && y <= 250) ||
               (x >= 100 && x <= 140) && (y >= 260 && y <= 290) ||
               (x >= 120 && x <= 140) && (y >= 270 && y <= 320)) && (game_state == 2'b01);
               
    wire block1_on;
    assign block1_on = ((x >= 300 && x <= 325) && (y >= 100 && y <= 125) && (game_state == 2'b01)) ;
    
    wire block2_on;
    assign block2_on = ((x >= 200 && x <= 225) && (y >= 250 && y <= 275) && (game_state == 2'b01));
    
    wire block3_on;
    assign block3_on = ((x >= 400 && x <= 425) && (y >= 350 && y <= 375) && (game_state == 2'b01));

    wire block4_on;
    assign block4_on = ((x >= 475 && x <= 500) && (y >= 275 && y <= 300) && (game_state == 2'b01));
    
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
    always @*
        if (~video_on)
            rgb = 12'h000;          // black (no value) outside display area
//        else if (game_state == 2'b00) // GAME_OVER state
//        rgb = GAME_START_RGB;    // Black screen for game over
        else if (game_state == 2'b10) // GAME_OVER state
            rgb = GAME_OVER_RGB;    // Black screen for game over
        else if (sq_on)
            rgb = SQ_RGB;           // yellow square
        else if (rect_on)
            rgb = RECT_RGB;         // white rectangle
        else if (block1_on)
            rgb = 12'h0F0;          // green block
        else if (block2_on)
            rgb = 12'hF0F;          // purple block
        else if (block3_on)
            rgb = 12'hFA0;  
        else if (block4_on)
            rgb = 12'h0F0;        // orange block
        else if (flag_on)
            rgb = FLAG_RGB;
        else if (flag_stick_on)
            rgb = FLAG_STICK_RGB;
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
        else
            rgb = BG_RGB;         // blue background
endmodule


