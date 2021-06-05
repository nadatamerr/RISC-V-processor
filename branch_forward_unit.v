`timescale 1ns / 1ps
`include "defines.v"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 03:29:48 AM
// Design Name: 
// Module Name: branch_forward_unit
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


module branch_forward_unit(input[4:0] IF_ID_RegisterRs1, input [4:0]IF_ID_RegisterRs2,input [4:0] EX_MEM_RegisterRd, input EX_MEM_RegWrite, input EX_MEM_MemRead, input [4:0]IF_ID_OPCODE,EX_MEM_OPCODE,
output reg forwardA, output reg forwardB, output reg stall);

    always@(*)begin

        // If there is a branch in opcode (this one)
        // If the previous one is load word -> stall -> one slow cycle ? el mafrod one fast cycle 
        // Otherwise I need to forward -> ID_EX_RD with EX_MEM 
        // F D X M W 
        //      F D X M W
            //F D X M W 
            //    F D X M W 
        if(EX_MEM_OPCODE == `OPCODE_Load && IF_ID_OPCODE == `OPCODE_Branch && EX_MEM_MemRead && (EX_MEM_RegisterRd!=0) &&(EX_MEM_RegisterRd == IF_ID_RegisterRs1 || EX_MEM_RegisterRd == IF_ID_RegisterRs2))
             stall = 1;
         else 
            begin 
            stall = 0;        
        
        if(IF_ID_OPCODE == `OPCODE_Branch && EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == IF_ID_RegisterRs1))   
            forwardA = 1;
        else 
            forwardA = 0;


        if(IF_ID_OPCODE == `OPCODE_Branch &&  EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == IF_ID_RegisterRs2))
            forwardB = 1;
        else
            forwardB = 0;
        end 
    end

endmodule
