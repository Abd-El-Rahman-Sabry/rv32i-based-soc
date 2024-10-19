`include "parameters.vh"

module branch_unit
(
    input  wire                             i_jb_ctrl, 
    input  wire          [`WIDTH - 1: 0]    i_pc, 
    input  wire         [`WIDTH - 1: 0]    i_offset, 
    input  wire          [`WIDTH - 1: 0]    i_r_src, 
    output wire  [`WIDTH - 1: 0]            o_nxt_pc
);


    wire [`WIDTH - 1 : 0] add_op;
    wire [`WIDTH - 1 : 0] add_result;

    assign add_op = (i_jb_ctrl)?  i_pc : i_r_src;

    // Jump or Branch addition operation 
    
    assign add_result = add_op + i_offset; 

    // Adding the mask in case of the JALR Operation 
    
    assign o_nxt_pc = (i_jb_ctrl)? add_result : add_result^(-2);


endmodule 