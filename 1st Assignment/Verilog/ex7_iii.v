// Four-bit binary counter with UP/DOWN and  Clear
module Binary_Counter_4 (
output reg [3:0] A,
input  U_D,CLK,RST
);
always @ ( posedge CLK, negedge RST)

if (~RST) A<=4'b0000 ;            // IF CLEAR==1 , PRESET==0 THEN RESET TO ZERO
else if (U_D) A <= A + 1'b1;      // IF UPDOWN input ==1 , count upwards
else A <= A - 1'b1;             //else updown input==0 , count downwards. 
//We don't have to check for A==1111 , because 1111+0001=0000
//and we don't have to check for A==0000, because 0000-1=1111
endmodule