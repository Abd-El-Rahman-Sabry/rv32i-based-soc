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

    /*

        Control Signals 

    */
    wire                      pc_src_ctrl;      //PC 
    wire [0:0]                alu_op_src_ctrl;  //ALU 
    wire [3:0]                alu_ctrl;         //ALU 
    wire [2:0]                sx_immd_src_ctrl; //IMMEDIATE 
    wire                      rf_we_ctrl; 
    wire [2:0]                rf_wb_src_ctrl; 
    wire                      bu_jb_ctrl; 

    wire                      alu_zero_status; 




    // Program Counter Interanl Signals 

    wire [`I_ADD_SIZE -1 : 0] pc_plus_4; 
    wire [`I_ADD_SIZE -1 : 0] pc_src_val;


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
    assign pc_src_val   = (pc_src_ctrl)?    bu_next_dest_jb : pc_plus_4;

    
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

    
    pc_reg u0(
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_nxt_pc(pc_src_val),
        .o_pc(o_instr_add)
    );


    adder u1(
        .a(o_instr_add),
        .b('d4),
        .r(pc_plus_4)
    );




    regfile u2(
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_w(rf_we_ctrl),
        .i_src_0(instr[19:15]),
        .i_src_1(instr[24:20]),
        .i_dst(instr[11:7]),
        .i_data(rf_wb_data),
        .o_d_src_0(rf_src_0_data),
        .o_d_src_1(rf_src_1_data) 
    );


    alu u3(
        .i_alu_ctrl(alu_ctrl),
        .i_op_0(rf_src_0_data), 
        .i_op_1(alu_op_1), 
        .o_alu_out(alu_out),
        .o_zero(alu_zero_status)

    ); 


    sign_extend u4(
        .i_src(sx_immd_src_ctrl),
        .i_immd(instr[31:7]),
        .o_sx_immd(sx_immd)
    );

    
    branch_unit u5(
        .i_jb_ctrl(bu_jb_ctrl),
        .i_pc(o_instr_add),
        .i_offset(sx_immd),
        .i_r_src(rf_src_0_data),
        .o_nxt_pc(bu_next_dest_jb)
    );


    control_unit u6(
        .o_alu_op_src_ctrl(alu_op_src_ctrl),
        .o_pc_src_ctrl(pc_src_ctrl),
        .o_sx_imm_src_ctrl(sx_immd_src_ctrl),
        .o_rf_we_ctrl(rf_we_ctrl),
        .o_rf_wb_scr_ctrl(rf_wb_src_ctrl),
        .o_alu_ctrl(alu_ctrl),
        .o_bu_jb_ctrl(bu_jb_ctrl),
        .o_mem_we(o_we), 
        .i_funct3(instr[14:12]),
        .i_funct7(instr[31:25]),
        .i_opcode(instr[6:0]), 
        .i_zero_flg(alu_zero_status)
    );





    assign o_w_data = rf_src_1_data; 

    assign o_d_add = alu_out;
    


endmodule 