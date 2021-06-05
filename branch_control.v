`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2021 07:45:08 PM
// Design Name: 
// Module Name: branch_control
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


`include "defines.v"

module branch_control( input [2:0] funct3, input [4:0] opcode, input X,input[3:0]flags,output reg [1:0] PC_Sel); // funct3 and opcode to know which instruction 
 // flags : cf , zf , vf, sf respectively 

/*
Mux 
if PC_Sel = 00 -> PC + 4 
if PC_Sel = 01 -> JAL and branch 
if PC_Sel = 10 JALR 

*/

  always @ (*) begin 

    case(opcode) // Whether the PC will be selected from Jal or JalR or branching 

      `OPCODE_JALR: PC_Sel = 2'b10;          // PC = rs1 + IMM -- > ALU Result
      `OPCODE_JAL : PC_Sel = 2'b01;          // PC = PC + IMM * 2 --> Add to the PC the IMM
      
      `OPCODE_Branch: begin 
          case(funct3) // This is for all types of branching -> same as JAL selection
            `BR_BEQ:  PC_Sel =  (flags[2] == 1) ? 2'b01 : 2'b00;            // if equal 
            `BR_BNE:  PC_Sel =  (flags[2] == 0) ? 2'b01 : 2'b00;            // if not equal
            `BR_BLT:  PC_Sel =  (flags[0] != flags[1]) ? 2'b01  :2'b00;     // Branch if a < b
            `BR_BGE:  PC_Sel =  (flags[0] == flags[1]) ?  2'b01 : 2'b00;     // Branch if a > b;     
            `BR_BLTU: PC_Sel =  (~flags[3]) ? 2'b01 : 2'b00;                 // Unsigned  (branch if  a < b)
            `BR_BGEU: PC_Sel =  (flags[3]) ? 2'b01 : 2'b00;                  // unsigned (branch if a > b)   
          endcase
      end 
      `OPCODE_SYSTEM:     //ECALL & EBREAK
            PC_Sel = (!X) ? 2'b11 : 2'b00;
      default: PC_Sel = 2'b00;  // Other types 

    endcase
  end
endmodule 
