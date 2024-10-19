`include "parameters.vh"



module pipelined_riscv_datapath #(
    parameter WIDTH = `WIDTH 
)(
    // Main Signals 

    input wire                          i_clk,
    input wire                          i_rstn,

    // Instruction Memory Interface 
    
    input wire [`I_WIDTH    - 1 : 0]    i_instr_mem_out,
    output wire [`I_ADD_SIZE - 1 : 0]    o_instr_add,

    // Date Memory Interface 
    output wire                         o_we,
    output wire [`D_ADD_SIZE - 1 : 0]   o_d_add,
    output wire [`WIDTH - 1 : 0]        o_w_data,
    input  wire [`WIDTH - 1 : 0]        i_r_data
); 




    // Instruction Memory Interanl Nets 
    wire [`I_WIDTH    - 1 : 0]    instr;
    assign instr = i_instr_mem_out;  
    

    // Register File internal nets 

    reg [`WIDTH - 1 : 0] rf_wb_data; 
    wire [`WIDTH - 1 : 0] rf_src_0_data; 
    wire [`WIDTH - 1 : 0] rf_src_1_data; 

    // Alu internal nets 

    wire [`WIDTH - 1 :0] alu_out; 
    wire [`WIDTH - 1 :0] alu_op_1; 
    
    // Immediate Generation interanl nets 

    wire [`WIDTH - 1: 0] sx_immd; 

    // Branch Controller internal nets 

    wire [`WIDTH - 1: 0] bu_next_dest_jb; 

    assign alu_op_1     = (alu_op_src_ctrl)? sx_immd : rf_src_1_data;
    

    
    // Where to write back 
    
    always @(*) begin
        case (rf_wb_src_ctrl)
            3'b000 : rf_wb_data <= alu_out; 
            3'b001 : rf_wb_data <= i_r_data; 
            3'b010 : rf_wb_data <= pc_plus_4; 
            3'b011 : rf_wb_data <= sx_immd; 
            3'b100 : rf_wb_data <= bu_next_dest_jb;
            default : rf_wb_data <= 'b0;  
        endcase 
    end

    










    alu u3(
        .i_alu_ctrl(alu_ctrl),
        .i_op_0(rf_src_0_data), 
        .i_op_1(alu_op_1), 
        .o_alu_out(alu_out),
        .o_zero(alu_zero_status)

    ); 


    
    
    branch_unit u5(
    
        .i_jb_ctrl(bu_jb_ctrl),
        .i_pc(o_instr_add),
        .i_offset(sx_immd),
        .i_r_src(rf_src_0_data),
        .o_nxt_pc(bu_next_dest_jb)
    
    );








    assign o_w_data = rf_src_1_data; 

    assign o_d_add = alu_out;
    


endmodule 