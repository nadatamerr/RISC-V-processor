module ripple_carry_adder #(parameter N = 32)(
    input [N-1:0] a,
    input [N-1:0] b,
    input cin,
    output cout,
    output [N-1:0] sum
    );

  genvar i ;

wire [N:0]carry; 
assign carry[0] = cin ; 
 
  generate 
    
    for(i = 0 ; i < N ; i= i+1) begin
      full_adder m(carry[i], a[i], b[i], carry[i+1], sum[i]);
    end 
  endgenerate
 
 assign cout = carry[N];

endmodule