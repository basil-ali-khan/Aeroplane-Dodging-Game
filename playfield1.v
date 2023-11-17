`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2023 01:01:29 PM
// Design Name: 
// Module Name: playfield1
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


module playfield(hpos, vpos, playfield_gfx);
  
  input [8:0] hpos;
  input [8:0] vpos;
  output playfield_gfx;
  
  reg [31:0] maze [0:27];
  
  wire [4:0] x = hpos[7:3];
  wire [4:0] y = vpos[7:3] - 2;
  
  assign playfield_gfx = maze[y][x];
  
  initial begin
    maze[0]  = 32'b11111111111111111111111111111111;
    maze[1]  = 32'b10000000000100000000001000000001;
    maze[2]  = 32'b10000000000100000000001000000001;
    maze[3]  = 32'b10000000000100000000000000000001;
    maze[4]  = 32'b10011110000000000000000000000001;
    maze[5]  = 32'b10000000000000000000000000000001;
    maze[6]  = 32'b10000000001000000000000011110001;
    maze[7]  = 32'b11100010000000000000000000100001;
    maze[8]  = 32'b10000010000000000000000000100001;
    maze[9]  = 32'b10000011100000000000000000000001;
    maze[10] = 32'b10000000000000000000000000000001;
    maze[11] = 32'b10000000000000000000000000000001;
    maze[12] = 32'b11111000001000000000000000000001;
    maze[13] = 32'b10001000001000000000000111100001;
    maze[14] = 32'b10001000001000000000000000000001;
    maze[15] = 32'b10000000001000000000000000000001;
    maze[16] = 32'b10000000001000000000000000000001;
    maze[17] = 32'b10000000000000000000000000000001;
    maze[18] = 32'b10000010000000000000000100011001;
    maze[19] = 32'b10001110000000000000000100010001;
    maze[20] = 32'b10000000001000000000000100010001;
    maze[21] = 32'b10000000001110000000000100000001;
    maze[22] = 32'b10000000000000000010001100000001;
    maze[23] = 32'b10000000000000000000000000000001;
    maze[24] = 32'b10000010000111100000000000010001;
    maze[25] = 32'b10000010000000100000000000010001;
    maze[26] = 32'b10000010000000000010000000010001;
    maze[27] = 32'b11111111111111111111111111111111;
  end
  
endmodule
