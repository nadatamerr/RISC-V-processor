`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2021 11:46:32 PM
// Design Name: 
// Module Name: forwarding_unit
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


module forward_unit(input [4:0] ID_EX_RegisterRs1, input [4:0] ID_EX_RegisterRs2, input [4:0] MEM_WB_RegisterRd, input MEM_WB_RegWrite, 
output reg forwardA, output reg forwardB);

    always@(*)begin
        // if ( EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs1)) 
        //         forwardA = 2'b10;

        //  else 
         if ( MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegisterRd == ID_EX_RegisterRs1) )   
                    forwardA = 1;
         else forwardA = 0;


 /*       if ( EX_MEM_RegWrite && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs2)) 
                 forwardB = 2'b10;
        
      
        else 
        */
        if ( MEM_WB_RegWrite && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegisterRd == ID_EX_RegisterRs2) )
                    forwardB =1;
        else 
                    forwardB = 0;
    end


endmodule
