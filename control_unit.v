`include "defines.v"

module control_unit(
    input [4:0] inst,
 //   output reg branch,
    output reg memRead,
    output reg  memtoReg1,
    output reg [1:0]memtoReg2,  // for choosing whether it is mem, AUPIC, JAL/JALR , LUI 
    output reg [1:0] ALUop,
    output reg memWrite,
    output reg ALUsrc,
    output reg regWrite
    );

/*
new mux : 
mem : 2'b00 (alu or Load word)-- > cannot delete the first mux ! 
AUIPC : 2'b01 
JAL/JAR : 2'b10 
LUI/ I-Format  : 2'b11

*/

/* 
respectively, 
memRead   1 bit 
MemtoReg1 1 bit
MemtoReg2 2 bits (decides who will be written in the reg file)
ALUop     2 bits (ALU Operations)
memWrite  1 bit 
ALUsrc    1 bit 
regWrite  1 bit

8 bits
*/

    always@(*)begin
        
      case(inst)
      `OPCODE_Arith_R: begin //r-type
 //       branch = 0;
        memRead = 0;
        memtoReg1 = 0; 
        memtoReg2 = 2'b00;
        ALUop = 2'b10; // it depends 
        memWrite = 0;
        ALUsrc = 0;
        regWrite = 1;
       
      end
      `OPCODE_Load:   begin //load
   //     branch = 0;
        memRead = 1;
        memtoReg1 = 1;
        memtoReg2 = 2'b00; // to memory still 
        ALUop = 2'b00; // add
        memWrite = 0;
        ALUsrc = 1;
        regWrite = 1;

      end
      `OPCODE_Store:   begin //store
  //      branch = 0;
        memRead = 0;
        memtoReg1 = 0;
        memtoReg2 = 2'b00; // sff
        ALUop = 2'b00; //add
        memWrite = 1;
        ALUsrc = 1;
        regWrite = 0;

      end 
      `OPCODE_Branch:  begin//branch
  //      branch = 1;
        memRead = 0;
        memtoReg1 = 0;
        memtoReg2 = 2'b00; // don't care
        ALUop = 2'b01; // subtract
        memWrite = 0;
        ALUsrc = 0;
        regWrite = 0;
      end
      `OPCODE_AUIPC: begin 
  //      branch = 1;
        memRead = 0;
        memtoReg1 = 0;
        memtoReg2 = 2'b01; 
        ALUop = 2'b00;  // add
        memWrite = 0;   // don't care
        ALUsrc = 1;     // ImmGen    
        regWrite = 1;   // write in the reg
      end 
      `OPCODE_JAL,`OPCODE_JALR: begin 
    //    branch = 1;
        memRead = 0;
        memtoReg1 = 0;
        memtoReg2 = 2'b10; 
        ALUop = 2'b00; // add
        memWrite = 0;
        ALUsrc = 1;  //IMMGen
        regWrite = 1; // write in the reg
      end 
     
      `OPCODE_LUI: begin 
        memRead = 0;
        memtoReg1 = 0;
        memtoReg2 = 2'b11;  
        ALUop = 2'b11;  // nothing -> just get rs2 + 0
        memWrite = 0; // dont care
        ALUsrc = 1;   // ImmGen 
        regWrite = 1; // write in the reg

      end 
      `OPCODE_Arith_I: begin 
        memRead = 0;
        memtoReg1 = 0;
        memtoReg2 = 2'b00; ////////////////////////
        ALUop = 2'b10; 
        memWrite = 0;
        ALUsrc = 1;
        regWrite = 1;
      end 
      default: begin
       //   branch = 0;
        memRead = 0;
        memtoReg1 = 0;
        memtoReg2 = 2'b00;
        ALUop = 2'b00;
        memWrite = 0;
        ALUsrc = 0;
        regWrite = 0;
      end
    endcase
    end
endmodule