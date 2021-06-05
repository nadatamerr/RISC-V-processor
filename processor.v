`timescale 1ns / 1ps

`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2021 03:43:50 PM
// Design Name: 
// Module Name: Exp1
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

// module processor(input clk, input reset);
module processor(input clk, input reset, input [1:0] ledSel, input [3:0] ssdSel, output reg [15:0]leds, output reg [12:0] ssd);

    reg [31:0] PC;
    wire memRead, memtoReg1,memWrite,ALUsrc,regWrite,cf, zf, vf, sf;
    wire [1:0] ALUop,memtoReg2,PC_sel;
    wire [31:0] instruction,RD1,RD2,mem_alu_mux,gen_out,alu_in2,alu_out,MemOut,newPC,nextInst,branching,writedata_reg;
    wire [3:0] ALUsel;
   
    reg s_clk;  
   
    wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_PC_NEXT; 

    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_PC_NEXT,ID_EX_ALUin2,ID_EX_ALUin1; 
    wire [8:0] IF_ID_Ctrl,ID_EX_Ctrl; 
    wire [3:0] ID_EX_Func,ID_EX_ALUsel; 
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd, ID_EX_OPCODE; 
    wire[31:0]IDEX_reg2_fwd,EXMEM_reg2_fwd;

    wire [31:0]EX_MEM_PC, EX_MEM_PC_NEXT,EX_MEM_Imm, EX_MEM_ALU_out, EX_MEM_RegR2; 
    wire [8:0] EX_MEM_Ctrl; 
    wire [3:0] EX_MEM_Func, EX_MEM_Flags; 
    wire [4:0] EX_MEM_OPCODE,EX_MEM_Rs1,EX_MEM_Rs2,EX_MEM_Rd;
    wire [31:0]aluin1, a2,regdata;

    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out,MEM_WB_MUXout,MEM_WB_PC_NEXT,MEM_WB_Imm,MEM_WB_PC;
    wire [7:0] MEM_WB_Ctrl; 
    wire [4:0] MEM_WB_Rd; 

    wire fdA, fdB;
    wire stall; 


    initial begin
        PC = 32'd0; 
    end 

    always@(posedge clk or posedge reset) begin
            if(reset)
                s_clk <=0; 
            else if(clk)
                s_clk = ~s_clk; 
        end


 
//// IF Stage

    wire [31:0] memory_address = (s_clk == 1'b1) ? PC : EX_MEM_ALU_out; 
   
    assign nextInst = PC+4;


    memory mem(clk,s_clk,PC, EX_MEM_Ctrl[8], EX_MEM_Ctrl[2],memory_address, EX_MEM_Func[2:0], EXMEM_reg2_fwd, MemOut, instruction);


  
load_rst_reg #(96) IF_ID (!s_clk,~stall, reset, {PC, instruction, nextInst}, {IF_ID_PC,IF_ID_Inst,IF_ID_PC_NEXT} );  // it was If_inst

//// ID Stage

    imm_gen immgen(IF_ID_Inst,gen_out);

    control_unit cu(IF_ID_Inst[6:2], memRead, memtoReg1, memtoReg2, ALUop, memWrite, ALUsrc, regWrite);

    regFile#(32) rf2(clk, reset, writedata_reg, IF_ID_Inst[19:15],IF_ID_Inst[24:20],MEM_WB_Rd, MEM_WB_Ctrl[0], RD1, RD2);
    
    

//bonus

    ALU_control alu_cont( ALUop, IF_ID_Inst[14:12], IF_ID_Inst[30], IF_ID_Inst[6:2], ALUsel);
     

    wire forwardA, forwardB;
    forward_unit fwd(IF_ID_Inst[19:15],IF_ID_Inst[24:20], EX_MEM_Rd, EX_MEM_Ctrl[0],forwardA, forwardB);

    mux_32 alumx1(forwardA, mem_alu_mux,RD1,aluin1);
    mux_32 alumx2(forwardB, mem_alu_mux,RD2,a2);

    mux_32 m1(ALUsrc, gen_out, a2,alu_in2);


    wire [3:0]flags;
    wire [31:0]a,b,op_b,add;

    branch_forward_unit bfu(IF_ID_Inst[19:15],IF_ID_Inst[24:20], EX_MEM_Rd, EX_MEM_Ctrl[0],EX_MEM_Ctrl[8], IF_ID_Inst[6:2],EX_MEM_OPCODE, fdA, fdB, stall);

    //forwarding
    mux_32 bfd1(fdA,alu_out, RD1, a);
    mux_32 bfd2(fdB,alu_out, alu_in2, b);
    
    //stalling for lw-branch
    nbit_mux #(9)hdmux(stall, 8'd0,{memRead, memtoReg1, memtoReg2, ALUop, memWrite, ALUsrc, regWrite},  IF_ID_Ctrl);


    assign op_b = (~b);
    
    assign {flags[3], add} = ALUsel[0] ? (a + op_b + 1'b1) : (a + b);   //carry flag 
    assign flags[2] = (add == 0);                                       //Zero Flag 
    assign flags[0] = add[31];                                          //Sign Flag
    assign flags[1] = (a[31] ^ (op_b[31]) ^ add[31] ^ flags[3]);        //Overflow flag 




    branch_control bc( IF_ID_Inst[14:12],  IF_ID_Inst[6:2], IF_ID_Inst[20],flags, PC_sel);

    ripple_carry_adder #(32) rc1(IF_ID_PC,gen_out,0,cout,branching); //auipc or immediate 

    wire [31:0]jalrout = aluin1 + gen_out;
    mux4x1 pc(PC_sel, nextInst, branching, jalrout, IF_ID_PC, newPC); 

    always @(posedge s_clk or posedge reset) begin 
        if(reset)
            PC <= 32'd0;
        else if (~stall)
            PC<=newPC;
        else
            PC<=PC;
    end


load_rst_reg #(293) ID_EX (s_clk,1'b1,reset, 
{IF_ID_Ctrl,IF_ID_PC, RD1, RD2,a2, gen_out, {IF_ID_Inst[30],IF_ID_Inst[14:12]}, IF_ID_Inst[19:15],IF_ID_Inst[24:20], IF_ID_Inst[11:7],IF_ID_PC_NEXT,IF_ID_Inst[6:2],ALUsel,alu_in2,aluin1 }, 
{ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,IDEX_reg2_fwd,ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd,ID_EX_PC_NEXT,ID_EX_OPCODE,ID_EX_ALUsel,ID_EX_ALUin2,ID_EX_ALUin1});

//// EX Stage   

    ALU alu(ID_EX_ALUin1,ID_EX_ALUin2, ID_EX_Rs2, alu_out, cf, zf, vf, sf, ID_EX_ALUsel);


load_rst_reg #(129) EX_MEM (!s_clk,1'b1,reset,  
{ID_EX_PC,ID_EX_PC_NEXT,ID_EX_Imm,ID_EX_Ctrl,ID_EX_Func,ID_EX_OPCODE, alu_out,IDEX_reg2_fwd, ID_EX_Rd}, 
{EX_MEM_PC,EX_MEM_PC_NEXT,EX_MEM_Imm,EX_MEM_Ctrl,EX_MEM_Func,EX_MEM_OPCODE, EX_MEM_ALU_out,EXMEM_reg2_fwd, EX_MEM_Rd} ); 

//// MEM Stage

    mux_32 m2(EX_MEM_Ctrl[7], MemOut, EX_MEM_ALU_out, mem_alu_mux);

    mux4x1 writetoReg(EX_MEM_Ctrl[6:5], mem_alu_mux, EX_MEM_Imm + EX_MEM_PC, EX_MEM_PC_NEXT, EX_MEM_Imm, regdata);


load_rst_reg #(78) MEM_WB (s_clk,1'b1, reset, 
{EX_MEM_Ctrl, MemOut, EX_MEM_Rd,regdata}, 
{MEM_WB_Ctrl,MEM_WB_Mem_out,MEM_WB_Rd,writedata_reg}); 

//// WB Stage
    // mux4x1 writetoReg(MEM_WB_Ctrl[6:5], MEM_WB_MUXout, MEM_WB_Imm + MEM_WB_PC, MEM_WB_PC_NEXT, MEM_WB_Imm, writedata_reg);





    always@(*) begin
        case(ledSel)
            2'b00: begin leds = instruction[15:0];end
            2'b01: begin leds = instruction[31:16];end
            // 2'b10: begin leds = {2'b00, ALUop, ALUsel, zf, (zf&branch)}; end //concat branching AND output
            default: leds = 0;
        endcase
    end

    always@(*)begin
        case(ssdSel)
            4'b0000: begin ssd = PC; end//pc output
            4'b0001: begin ssd = PC+4; end//pc+4
            4'b0010: begin ssd = branching; end//branch target instead of pc1 + y
            4'b0011: begin ssd = newPC; end//pc input
            4'b0100: begin ssd = RD1[13:0]; end
            4'b0101: begin ssd = RD2[13:0]; end
            4'b0110: begin ssd = mem_alu_mux[13:0]; end
            4'b0111: begin ssd = gen_out[13:0]; end
            // 4'b1000: begin ssd = Y; end//shift left output
            4'b1001: begin ssd = alu_in2[13:0]; end
            4'b1010: begin ssd = alu_out[13:0]; end
            4'b1011: begin ssd = MemOut[13:0]; end
            default : ssd = 0; 
        endcase
    end










 
endmodule



module nbit_mux #(parameter N = 32)(
//    input clk,
    input sel,
    input [N-1:0] A,
    input [N-1:0] B,
    output [N-1:0] Y
    );

    genvar i;
    generate 
    for (i = N-1; i>=0; i=i-1) begin
        mux a(sel, A[i], B[i], Y[i]);
    end
    endgenerate
endmodule