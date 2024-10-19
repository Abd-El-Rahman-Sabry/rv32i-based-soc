`include "parameters.vh"



module sign_extend (
    input wire [2:0]                i_src, 
    input wire [31:7]               i_immd,
    output reg [`WIDTH - 1 : 0 ]    o_sx_immd 
);


    always @(*) begin
        case (i_src)
            
            3'b000:     o_sx_immd = {{20{i_immd[31]}}, i_immd[31:20]}; // I−type
            3'b001:     o_sx_immd = {{20{i_immd[31]}}, i_immd[31:25], i_immd[11:7]}; // S−type (stores)
            3'b010:     o_sx_immd = {{20{i_immd[31]}}, i_immd[7],  i_immd[30:25], i_immd[11:8], 1'b0}; // B−type (branches)                                        
            3'b011:     o_sx_immd = {{12{i_immd[31]}}, i_immd[19:12], i_immd[20], i_immd[30:21], 1'b0}; // J−type (jal)
            3'b100:     o_sx_immd = {i_immd, {7{1'b0}}}; // U−type (jal)
                
            default:    o_sx_immd = 32'b0; // undefined
        
        endcase 
    end
    
endmodule