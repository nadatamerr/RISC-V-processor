`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2021 03:56:25 PM
// Design Name: 
// Module Name: regFile
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


module regFile#( parameter n = 32)(
    input clk,
    input rst,
    input [31:0]D,
    input [4:0] Rreg1,
    input [4:0] Rreg2,
    input [4:0] WR,
    input regWrite, 
    output [31:0]RD1, 
    output [31:0]RD2
    );

    wire [n-1:0]Q[0:31];

    reg [31:0]load ; 
        genvar i ; 
        generate begin 
            for(i = 0 ; i < n ; i= i+1)
            load_rst_reg #(32) r (!clk, load[i], rst, D, Q[i]);
            end 
        endgenerate 

    assign RD1 = Q[Rreg1];
    assign RD2 = Q[Rreg2]; 

    always @(*) 
    begin
      if(regWrite) 
      begin
            if(WR == 0)begin
                load = 0;
            end
            else 
                begin 
                load = 0;
                load[WR] = 1;  
                end
        end
        else  load=0;
    end
endmodule
