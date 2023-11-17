`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2023 10:09:37 AM
// Design Name: 
// Module Name: h_counter_10bit
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


module counter(clk,count,trig_v);
    input clk;
    output [9:0] count;
    output trig_v;
    reg trig_v;
    reg [9:0] count;
    initial count = 0;
    initial trig_v = 0;
    always @ (posedge clk)
        begin
            if (count < 799)
                begin
                    count <= count + 1;
                    trig_v <= 1'b0;
                end
            else
                begin
                    count <= 1'b0;;
                    trig_v <= 1'b1;
                end
        end     
endmodule