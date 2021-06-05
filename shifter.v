`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2021 07:34:52 PM
// Design Name: 
// Module Name: shifter
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


module shifter(input [31:0] a, input [4:0] shamt, input [1:0] type, output reg [31:0]r); 

    always @ * begin 
        case(type)
            2'b00: r = a >> shamt; //srl                
            2'b01: r = a << shamt; //sll                
            2'b10: r = a >>> shamt; //sra
            default: r =a ; 
                
        endcase
end
endmodule
