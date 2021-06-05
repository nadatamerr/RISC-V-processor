`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2021 07:39:14 PM
// Design Name: 
// Module Name: mux32
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


module mux_32(
    input sel,
    input[31:0] A,
    input [31:0]B,
    output [31:0] Y
    );

    assign Y = (sel==1) ? A : B;
    
endmodule
