`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2021 06:58:54 PM
// Design Name: 
// Module Name: memory
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

// s_clk 
module memory(input clk, input s_clk, input [31:0]PC, input MemRead, MemWrite,input [7:0] address, input [2:0] funct3,input [31:0] data_in, output reg [31:0] data_out, instruction);// address , data

  reg [7:0] mem [0:255];

        initial begin 
                
        // {mem[3],mem[2],mem[1],mem[0]} = 32'b0000000_00000_00000_000_00000_0110011;        //add x0, x0, x0 
        // {mem[7],mem[6],mem[5],mem[4]} = 32'b00000000000000000010000010000011;             //lw x1, 0(x0)
        // {mem[11],mem[10],mem[9],mem[8]} = 32'b000000000100_00000_010_00010_0000011;       //lw x2, 4(x0)
        // {mem[15],mem[14],mem[13],mem[12]} = 32'b00000001111000011000000110010011;         //addi x3, x3, 30
        // {mem[19],mem[18],mem[17],mem[16]} = 32'b111111111011_00011_000_00011_0010011;     //addi x3, x3, -5
        // {mem[23],mem[22],mem[21],mem[20]} =  32'b00000000001000001110001000110011;        //or x4, x1, x2
        // {mem[27],mem[26],mem[25],mem[24]} = 32'b0000000_00100_00000_010_01100_0100011;    //sw x4, 12(x0)
        // {mem[31],mem[30],mem[29],mem[28]} = 32'b000000001100_00000_010_00100_0000011 ;    //lw x4, 12(x0)
        // {mem[35],mem[34],mem[33],mem[32]} = 32'b0_000000_00011_00100_000_0100_0_1100011;  //beq x4, x3, 4
        // {mem[39],mem[38],mem[37],mem[36]} = 32'b00000000001000001000000010110011;         //add x1, x1, x2
        // {mem[43],mem[42],mem[41],mem[40]} = 32'b00000000000000000101001010110111;         //lui x5, 5
        // {mem[47],mem[46],mem[45],mem[44]} = 32'b00000000000000000111001100010111;         //auipc x6, 7
        // {mem[51],mem[50],mem[49],mem[48]} = 32'b0_00000_00100_0_00000000_01001_1101111;   //jal x9, 4
        // {mem[55],mem[54],mem[53],mem[52]} = 32'b00000000010100000000001110010011;         //addi x7, x0, 5
        // {mem[59],mem[58],mem[57],mem[56]} = 32'b0000000_01001_00000_010_10000_0100011;    //sw x9, 16(x0)
        // {mem[63],mem[62],mem[61],mem[60]} = 32'b00000000000100100000001000010011;         //addi x4, x4, 1 
        // {mem[71],mem[70],mem[69],mem[68]} = 32'b00000001100_00000_000_01000_0000011;      //lb x8,12(x0)
        // {mem[75],mem[74],mem[73],mem[72]} = 32'b00000001100_00000_000_01010_0000011;      //lh x10,12(x0)
        // {mem[79],mem[78],mem[77],mem[76]} = 32'b0000000000000000000000000_1110011;        // ecall   



        // {mem[3],mem[2],mem[1],mem[0]} = 32'b0000000_00000_00000_000_00000_0110011;        //add x0, x0, x0 
        // {mem[7],mem[6],mem[5],mem[4]} = 32'b00000000000000000010000010000011;             //lw x1, 0(x0)
        // {mem[11],mem[10],mem[9],mem[8]} = 32'b000000000100_00000_010_00010_0000011;       //lw x2, 4(x0)
        // {mem[15],mem[14],mem[13],mem[12]} = 32'b00000001111000011000000110010011;         //addi x3, x3, 30
        // {mem[19],mem[18],mem[17],mem[16]} = 32'b00000001010000000000010110010011;         //sb x1, 5(x0)
        // {mem[23],mem[22],mem[21],mem[20]} = 32'b00000000010000000000010100010011;         //sh x2, 7(x0)
        // {mem[27],mem[26],mem[25],mem[24]} = 32'b0000000_00010_00001_001_0100_0_1100011;   //bne x1, x2, 4
        // {mem[31],mem[30],mem[29],mem[28]} = 32'b00000000000100100000001000010011;         //addi x4, x4, 1  //skipped
        // {mem[35],mem[34],mem[33],mem[32]} = 32'b00000000001000001100000001100011;         //blt x1, x2, 4
        // {mem[39],mem[38],mem[37],mem[36]} = 32'b00000000001000001000000010110011;         //add x1, x1, x2
        // {mem[43],mem[42],mem[41],mem[40]} = 32'b0000000_00010_00001_101_01000_1100011;    //bge x1, x2, 4
        // {mem[47],mem[46],mem[45],mem[44]} = 32'b00000001010000001100000010010011;         //xori x1, x1, 20 //skipped
        // {mem[51],mem[50],mem[49],mem[48]} = 32'b00000000001100010110000100010011;         //ori x2, x2, 3
        // {mem[55],mem[54],mem[53],mem[52]} = 32'b01000000000100010000000100110011;         //sub x2, x2, x1
        // {mem[59],mem[58],mem[57],mem[56]} = 32'b0000000_00010_00000_000_00010_0010011;    //addi x2, x0, 2
        // {mem[63],mem[62],mem[61],mem[60]} = 32'b00000000001000001001000010110011;         //sll x1, x1, x2
        // {mem[71],mem[70],mem[69],mem[68]} = 32'b01000000001000001101000010110011;         //sra x1, x1, x2
        // {mem[75],mem[74],mem[73],mem[72]} = 32'b0000000_00001_00010_010_01011_0110011;    //slt x11, x2, x1
        // {mem[79],mem[78],mem[77],mem[76]} = 32'b00000000001000001101000010110011;         //srl x1, x1, x2
        // {mem[83],mem[82],mem[81],mem[80]} = 32'b0000000_01110_01101_010_01110_0010011;    //slti x14, x13, 14
        // {mem[87],mem[86],mem[85],mem[84]} = 32'b00000000001000010001000100010011;         //slli x2, x2, 2
        // {mem[91],mem[90],mem[89],mem[88]} = 32'b0000000_00010_00010_101_00010_0010011;    //srli x2, x2, 2
        // {mem[95],mem[94],mem[93],mem[92]} = 32'b0100000_00010_00010_101_00010_0010011;    //srai x2, x2, 2
        // {mem[99],mem[98],mem[97],mem[96]} = 32'b0000000_00001_00010_011_00110_0110011;    //sltu x6, x2, x1
        // {mem[103],mem[102],mem[101],mem[100]} = 32'b11111101100001101011011110010011;     //sltiu x15, x13, -40

    
    
        {mem[3],mem[2],mem[1],mem[0]} = 32'b0000000_00000_00000_000_00000_0110011;      //add x0, x0, x0 
        {mem[7],mem[6],mem[5],mem[4]} =   32'b111111110010_00000_000_01100_0010011;     //addi x12, x0, -14
        {mem[11],mem[10],mem[9],mem[8]} = 32'b000000001010_00000_000_01101_0010011;     //addi x13, x0, 10
        {mem[15],mem[14],mem[13],mem[12]} = 32'b11111110110101100110111011100011;       //bltu x12, x13, 4
        {mem[19],mem[18],mem[17],mem[16]} = 32'b000000000001_00000_000_00100_0010011;   //addi x4, x0, 1 
        {mem[23],mem[22],mem[21],mem[20]} = 32'b11111110110001101111110011100011;       //bgeu x13, x12, 4
        {mem[27],mem[26],mem[25],mem[24]} = 32'b000000100000_00000000000100010011;      //addi x2, x0, 32
        {mem[31],mem[30],mem[29],mem[28]} = 32'b000000000100_00010_000_00001_1100111;   //jalr x1, x2, 4
        {mem[35],mem[34],mem[33],mem[32]} = 32'b00000000010100000100001010000011;       //lbu x5, 5(x0)
        {mem[39],mem[38],mem[37],mem[36]} = 32'b00000000011100000101001100000011;       //lhu x6, 7(x0)
        {mem[43],mem[42],mem[41],mem[40]} = 32'b00000000010100110100001010110011;       //xor x5, x6, x5
        {mem[47],mem[46],mem[45],mem[44]} = 32'b00000000001000001111001100110011;       //and x6, x1, x2
        {mem[51],mem[50],mem[49],mem[48]} = 32'b00000000010000101111001010010011;       //andi x5, x5, 4

     
        mem[127]=8'd17; 
        mem[128]=8'd0;
        mem[129]=8'd0; 
        mem[130]=8'd0;
        mem[131]=8'd9;
        mem[132]=0;
        mem[133]=0;
        mem[134]=0;
        mem[135]=8'd25;
        mem[136]=0;
        mem[137]=0;
        mem[138]=0;
        mem[139]=8'd10;
        mem[140]=0; 
        mem[141]=0;
        mem[142]=0; 
    end

reg [8:0]addr;
    // Fetching instruction 

    initial begin
        instruction = 32'h33; //nop instruction 
        data_out = 0;
    end 

   always@(*) begin 
        if(s_clk) begin 
                instruction = {mem[address+3], mem[address+2] , mem[address+1], mem[address]};
                data_out = 32'd0; 
        end 
        else begin 
            addr = address+127;
            instruction = 32'h33; //nop instruction  
            if(MemRead) begin 
                case(funct3) // little endian 
                3'b000:  data_out = {{24{mem[addr][7]}},{mem[addr]}};  //lb
                3'b001:  data_out = {{16{mem[addr+1][7]}},mem[addr+1], mem[addr]}; //halfw
                3'b010:  data_out = {mem[addr+3],mem[addr+2], mem[addr+1], mem[addr]}; 
                3'b100:  data_out = {{24{1'b0}},mem[addr]};// lbu 
                3'b101:  data_out = {{16{1'b0}},mem[addr+1],mem[addr]};// lhu  
                default: data_out = 32'b0;    
                endcase
            end
            else data_out = 32'b0; 
        end
    end

    // store word 
    always @(posedge clk) begin 

        if(MemWrite) begin 
            addr = address+127;
            // instruction = 32'h33; // nop 

            case(funct3)
            3'b000: mem[addr] = data_in[7:0]; //sb
            3'b001: {mem[addr+1],mem[addr]} = data_in[16:0];//sh
            3'b010: {mem[addr+3], mem[addr+2],mem[addr+1],mem[addr]}= data_in; // sword 
            // default: begin
            //     end
            endcase
        end
    end

endmodule
