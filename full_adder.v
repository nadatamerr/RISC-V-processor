module full_adder(
    input cin,
    input a,
    input b,
    output  cout,
    output  sum
    );
 
 assign {cout,sum} = a + b + cin ; 

endmodule