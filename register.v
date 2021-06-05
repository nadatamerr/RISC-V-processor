`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2021 07:47:45 PM
// Design Name: 
// Module Name: register
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


module load_rst_reg # (parameter N=32)(
    input clk,
    input load,
    input rst,
    input [N-1:0] D,
    output [N-1:0] Q
    );

    wire [N-1:0] X;
    genvar i;
    generate 
        for (i=N-1; i>=0; i=i-1)begin
            mux a(load, D[i], Q[i], X[i]);
            flipflop b(clk, rst, X[i], Q[i]);
        end
    endgenerate

endmodule
module mux(
    input sel,
    input A,
    input B,
    output  Y
    );
    assign Y = (sel==1) ? A : B;
    
endmodule

module flipflop(
    input clk,
    input rst,
    input D,
    output reg Q
    );

    always @ (posedge clk or posedge rst)
        if (rst) begin
        Q <= 1'b0;
        end else begin
        Q <= D;
    end 


endmodule

