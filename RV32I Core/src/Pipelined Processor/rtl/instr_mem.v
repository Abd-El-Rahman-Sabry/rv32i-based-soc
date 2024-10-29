


`include "parameters.vh"



module instr_mem #(
    parameter WIDTH = `I_WIDTH,
    parameter DEPTH = `I_DEPTH, 
    parameter ADD_SIZE = `I_ADD_SIZE 
)(
    input   [ADD_SIZE - 1 : 0]      i_add,
    output  [WIDTH - 1 :  0]        o_instr
); 

    reg [WIDTH - 1 : 0] i_mem [DEPTH - 1 : 0]; 
        
    initial begin
        $readmemh("program3.hex" , i_mem);
    end

    assign o_instr = i_mem[i_add>>2]; 

endmodule 