`include "defines.v"

module ALU_control(
    input [1:0] ALUop,
    input [2:0] funct3,
    input funct7,
    input [4:0]opcode,
    output reg [3:0] ALUsel
    );

    always @(*)begin
        case(ALUop)
        2'b00: ALUsel = `ALU_ADD;    
        2'b01: ALUsel = `ALU_SUB;
        2'b11: ALUsel = `ALU_PASS;
        2'b10: begin        
                case(opcode)
                5'b00100:begin //imm
                    case(funct3)
                    `F3_ADD: ALUsel = `ALU_ADD;
                    `F3_SLT: ALUsel = `ALU_SLT;
                    `F3_SLTU: ALUsel = `ALU_SLTU;
                    `F3_XOR: ALUsel = `ALU_XOR;
                    `F3_OR: ALUsel = `ALU_OR;
                    `F3_AND: ALUsel = `ALU_AND;
                    `F3_SLL: ALUsel = `ALU_SLL;
                    `F3_SRL: begin
                        if(funct7==1'b0) ALUsel = `ALU_SRL;
                        else ALUsel = `ALU_SRA;
                    end
                    default: ALUsel = `ALU_PASS;
                    endcase
                end
                5'b01100: begin //reg
                    if (funct3 == `F3_ADD && funct7 == 1'b0) ALUsel = `ALU_ADD; 
                    else if (funct3 == `F3_ADD && funct7 == 1'b1) ALUsel = `ALU_SUB;  
                    else if (funct3 == `F3_AND && funct7 == 1'b0) ALUsel =`ALU_AND;  
                    else if (funct3 == `F3_OR && funct7 == 1'b0) ALUsel = `ALU_OR;  
                    else if (funct3 == `F3_SLL && funct7 == 1'b0) ALUsel = `ALU_SLL;
                    else if (funct3 == `F3_SLT && funct7 == 1'b0) ALUsel = `ALU_SLT;
                    else if (funct3 == `F3_SLTU && funct7 == 1'b0) ALUsel = `ALU_SLTU;
                    else if (funct3 == `F3_SRL && funct7 == 1'b0) ALUsel = `ALU_SRL;
                    else if (funct3 == `F3_SRL && funct7 == 1'b1) ALUsel = `ALU_SRA;
                    else if (funct3 == `F3_XOR && funct7 == 1'b0) ALUsel = `ALU_XOR;
                    else ALUsel = `ALU_PASS; //default      
                end
                
                
                
                
                endcase 
                
        end 
      endcase
    end

endmodule
