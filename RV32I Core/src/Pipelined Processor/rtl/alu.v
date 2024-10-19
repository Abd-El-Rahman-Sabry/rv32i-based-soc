
`include "parameters.vh"


module alu #(
    parameter WIDTH  = `WIDTH
)(
    input wire [3:0] i_alu_ctrl, 

    input wire signed [WIDTH - 1 : 0]      i_op_0,    
    input wire signed [WIDTH - 1 : 0]      i_op_1,    
    output reg [WIDTH - 1 : 0]      o_alu_out,    
    output wire                      o_zero    
);

    assign  o_zero = ~|o_alu_out;

    always @(*) begin
        case (i_alu_ctrl)

            // Arithmatic Operation  
            4'b00_00:              o_alu_out <= i_op_0 + i_op_1;                       //ADD  
            4'b00_01:              o_alu_out <= i_op_0 - i_op_1;                       //SUB  
            
            4'b00_10:              o_alu_out <= i_op_0 <  i_op_1;                      //SLTU  
            4'b00_11:              o_alu_out <= $signed(i_op_0) <  $signed(i_op_1);    //SLT  
            

            // Shift Operation 
            4'b01_00:              o_alu_out <= i_op_0 ^  i_op_1;                      //XOR  
            4'b01_01:              o_alu_out <= i_op_0 |  i_op_1;                      //OR  
            4'b01_10:              o_alu_out <= i_op_0 &  i_op_1;                      //AND  
            
            // Logical Operation 
            4'b01_11:              o_alu_out <= i_op_0 << i_op_1;                      //SLL  
            4'b10_00:              o_alu_out <= i_op_0 >>  i_op_1;                     //SRL  
            4'b10_01:              o_alu_out <= i_op_0 >>>  i_op_1;                    //SRA  

            default : o_alu_out <= 'b0; 
        
        endcase 
    end

endmodule