`include "parameters.vh"



module id_stage #(
    parameter WIDTH = `WIDTH
)(
    input wire                              i_clk,
    input wire                              i_rstn,

    //Input 
    
    input wire  [WIDTH - 1 : 0]             i_iwb_data,

    // Previous Pipe data 
    
    input wire  [`I_ADD_SIZE - 1 : 0]       i_id_instr,
    input wire  [`I_ADD_SIZE - 1 : 0]       i_id_pc,
    input wire  [`I_ADD_SIZE - 1 : 0]       i_id_pc_plus4, 

    // Data Hazards signals 

    input wire                              i_ie_flush

); 

    /*

        Control Signals 

    */


    wire                      id_pc_src_ctrl;      //PC 
    wire [0:0]                id_alu_op_src_ctrl;  //ALU 
    wire [3:0]                id_alu_ctrl;         //ALU 
    wire [2:0]                id_sx_immd_src_ctrl; //IMMEDIATE 
    wire                      id_rf_we_ctrl; 
    wire [2:0]                id_rf_wb_src_ctrl; 
    wire                      id_bu_jb_ctrl; 
    wire                      id_mem_we; 
    wire                      id_alu_zero_status; 


    wire [WIDTH - 1 : 0]        id_rf_src_0;
    wire [WIDTH - 1 : 0]        id_rf_src_1;
    wire [WIDTH - 1 : 0]        id_sx_data;

 
    control_unit u6(
        .o_alu_op_src_ctrl(id_alu_op_src_ctrl),
        .o_pc_src_ctrl(id_pc_src_ctrl),
        .o_sx_imm_src_ctrl(id_sx_immd_src_ctrl),
        .o_rf_we_ctrl(id_rf_we_ctrl),
        .o_rf_wb_scr_ctrl(id_rf_wb_src_ctrl),
        .o_alu_ctrl(id_alu_ctrl),
        .o_bu_jb_ctrl(id_bu_jb_ctrl),
        .o_mem_we(id_mem_we), 
        .i_funct3(i_id_instr[14:12]),
        .i_funct7(i_id_instr[31:25]),
        .i_opcode(i_id_instr[6:0]), 
        .i_zero_flg(id_alu_zero_status)
    );

    sign_extend u4(
        .i_src(id_sx_immd_src_ctrl),
        .i_immd(i_id_instr[31:7]),
        .o_sx_immd(id_sx_data)
    );

    regfile u2(
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        
        .i_w(id_rf_we_ctrl),
        
        .i_src_0(i_id_instr[19:15]),
        .i_src_1(i_id_instr[24:20]),
        .i_dst(i_id_instr[11:7]),
        
        .i_data(i_iwb_data),
        
        .o_d_src_0(id_rf_src_0),
        .o_d_src_1(id_rf_src_1) 
    );


    


endmodule 