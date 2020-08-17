// Mealy model FSM
module Mealy_Model (y, x, clock, reset);
    output y;
    input x, clock, reset;
    reg [1: 0] state;
    parameter  a= 2'b00, b = 2'b01, c = 2'b10, d = 2'b11;
    always @ ( posedge clock, negedge reset)
    if (reset == 0) state <= a; //initial state a
    else case (state)
        a: if (~x) state <= b; else state <= c;
        b: if (~x) state <= c; else state <= d;
        c: if (~x) state <= b; else state <= d;
        d: if (~x) state <= c; else state <= a;
    endcase
    assign y = ~(state[0]^state[1]^x); // FROM y truth table
endmodule