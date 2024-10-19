`include "parameters.vh"


module adder #(
    parameter WIDTH = `I_WIDTH
) (
    input   [WIDTH -1 : 0]      a,
    input   [WIDTH -1 : 0]      b,
    output  [WIDTH -1 : 0]      r
);
    
    assign r = a + b ;

endmodule