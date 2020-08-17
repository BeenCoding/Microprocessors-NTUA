// Dataflow description of four-bit adder
module binary_adder_subtracter (Sum, Cout, A,B,M);
    
    output [3: 0] Sum;
    output Cout;
    input [3: 0] A, B;
    input M;
    assign {Cout, Sum} = (M==1)?(A + B):(A-B);
endmodule




