module mux4x1(input [1:0]sel, input [31:0]a, input [31:0]b, input [31:0]c, input [31:0]d, output reg [31:0]y);

    always@(*)begin
        case(sel)
        2'b00: y=a;
        2'b01: y=b;
        2'b10: y=c;
        2'b11: y=d;
        endcase
    end
    
endmodule