`include "parameters.vh"



module pipelined_riscv_datapath #(
    parameter WIDTH = `WIDTH 
)(
    // Main Signals 

    input wire                                  i_clk,
    input wire                                  i_rstn,

    // Instruction Memory Interface 
    
    input wire [`I_WIDTH    - 1 : 0]            i_instr_mem_out,
    output wire [`I_ADD_SIZE - 1 : 0]           o_instr_add,

    // Date Memory Interface 
    input  wire [`WIDTH - 1 : 0]                i_r_data,

    output wire                                 o_we,
    output wire [`D_ADD_SIZE - 1 : 0]           o_d_add,
    output wire [`WIDTH - 1 : 0]                o_w_data
); 

    // Fetch - Decode signals 

    wire [WIDTH  - 1 : 0 ]          if_id_pc_out   ;
    wire [WIDTH  - 1 : 0 ]          if_id_pc_plus_4;
    wire [WIDTH  - 1 : 0 ]          if_id_instr    ;

    // Decode - Execute signals
    
    wire [WIDTH - 1 : 0 ]           id_ie_pc       ;
    wire [WIDTH - 1 : 0 ]           id_ie_pc_plus4 ;
    wire                            id_ie_branch;         
    wire                            id_ie_jump  ;         
    wire                            id_ie_alu_op_src_ctrl;
    wire [3:0]                      id_ie_alu_ctrl;       
    wire                            id_ie_rf_we_ctrl;     
    wire [2:0]                      id_ie_rf_wb_src_ctrl; 
    wire                            id_ie_bu_jb_ctrl;     
    wire                            id_ie_mem_we;         
    wire [WIDTH - 1 : 0]            id_ie_rf_src_0;       
    wire [WIDTH - 1 : 0]            id_ie_rf_src_1;       
    wire [WIDTH - 1 : 0]            id_ie_sx_data ;       

    wire [`RF_ADD_SIZE - 1 : 0]     id_ie_src_0;          
    wire [`RF_ADD_SIZE - 1 : 0]     id_ie_src_1;          
    wire [`RF_ADD_SIZE - 1 : 0]     id_ie_dst  ;   
    
    
    // Execute - Memory signals 


    wire    [WIDTH - 1 : 0]         ie_im_bu_next_dest_jb;
    wire    [WIDTH - 1 : 0]         ie_im_alu_out        ;
    wire    [WIDTH - 1 : 0]         ie_im_write_data     ;
    wire                            ie_im_mem_we         ;
    wire                            ie_im_rf_we_ctrl     ;
    wire    [2:0]                   ie_im_rf_wb_src_ctrl ;
    wire    [WIDTH - 1 : 0]         ie_im_sx_data        ;
    wire    [WIDTH - 1 : 0]         ie_im_pc_plus_4      ;
    wire    [`RF_ADD_SIZE -1 : 0]   ie_im_dst            ;


    // Memory - WriteBack signals 

    wire    [WIDTH - 1 : 0]         im_iwb_bu_next_dest_jb ;
    wire    [WIDTH - 1 : 0]         im_iwb_alu_out         ;
    wire    [WIDTH - 1 : 0]         im_iwb_r_mem           ;
    wire                            im_iwb_rf_we_ctrl      ;
    wire    [2:0]                   im_iwb_rf_wb_src_ctrl  ;
    wire    [WIDTH - 1 : 0]         im_iwb_sx_data         ;
    wire    [WIDTH - 1 : 0]         im_iwb_pc_plus_4       ;
    wire    [`RF_ADD_SIZE - 1 : 0]  im_iwb_dst             ;

    // Execute Signals 

    wire [WIDTH - 1 : 0]            ie_bu_next_dest_jb;
    wire                            ie_nxt_pc_src;
    
    // WriteBack Signals 

    wire [WIDTH - 1 : 0]            iwb_out;



    // Control and status Hazards singals 


    // control signals 

    wire        if_stall;
    wire        id_stall;
    wire        id_flush;
    wire        ie_flush;
    wire  [1:0] ie_forward_0;
    wire  [1:0] ie_forward_1;




    if_stage u0_if (
        .i_clk                  (i_clk),
        .i_rstn                 (i_rstn),
        // hazard control 
        .i_if_stall             (if_stall),
        .i_id_stall             (id_stall),
        .i_id_flush             (id_flush),
        
        // inputs 
        .i_pc_src_ctrl          (ie_nxt_pc_src),
        .i_instr                (i_instr_mem_out), 
        .i_bu_next_dest_jb      (ie_bu_next_dest_jb), 
        
        // outputs
        .o_instr_add            (o_instr_add), 
        
        .o_id_pc_out            (if_id_pc_out),
        .o_id_pc_plus_4         (if_id_pc_plus_4),
        .o_id_instr             (if_id_instr)
    );

    id_stage u1_id(
        .i_clk                  (i_clk),
        .i_rstn                 (i_rstn),
        
        // Input from WriteBack Stage 
        .i_iwb_dst              (im_iwb_dst),
        .i_iwb_data             (iwb_out),
        .i_we                   (im_iwb_rf_we_ctrl),
        
        // Inputs 

        .i_id_instr             (if_id_instr),
        .i_id_pc                (if_id_pc_out),
        .i_id_pc_plus4          (if_id_pc_plus_4), 
        
        // Hazard Control Signals 
        .i_ie_flush             (ie_flush), 
        
        // Pipelined Signals
        .o_ie_pc                (id_ie_pc),
        .o_ie_pc_plus4          (id_ie_pc_plus4), 
        .o_ie_branch            (id_ie_branch), 
        .o_ie_jump              (id_ie_jump), 
        .o_ie_alu_op_src_ctrl   (id_ie_alu_op_src_ctrl), 
        .o_ie_alu_ctrl          (id_ie_alu_ctrl), 
        .o_ie_rf_we_ctrl        (id_ie_rf_we_ctrl),
        .o_ie_rf_wb_src_ctrl    (id_ie_rf_wb_src_ctrl), 
        .o_ie_bu_jb_ctrl        (id_ie_bu_jb_ctrl), 
        .o_ie_mem_we            (id_ie_mem_we), 
        .o_ie_rf_src_0          (id_ie_rf_src_0),
        .o_ie_rf_src_1          (id_ie_rf_src_1),
        .o_ie_sx_data           (id_ie_sx_data),
        .o_ie_src_0             (id_ie_src_0),
        .o_ie_src_1             (id_ie_src_1),
        .o_ie_dst               (id_ie_dst)
    );

    ie_stage u2_ie(
        .i_clk                  (i_clk),
        .i_rstn                 (i_rstn),
        
        .i_m_alu_out            (ie_im_alu_out),
        .i_iwb_out              (iwb_out),
        
        // Forwarding 
        .i_forward_0            (ie_forward_0),
        .i_forward_1            (ie_forward_1),
        
        .i_ie_branch            (id_ie_branch), 
        .i_ie_jump              (id_ie_jump), 
        .i_ie_alu_op_src_ctrl   (id_ie_alu_op_src_ctrl), 
        .i_ie_mem_we            (id_ie_mem_we), 
        .i_ie_rf_we_ctrl        (id_ie_rf_we_ctrl),
        .i_ie_rf_wb_src_ctrl    (id_ie_rf_wb_src_ctrl),
        .i_ie_alu_ctrl          (id_ie_alu_ctrl), 
        .i_ie_bu_jb_ctrl        (id_ie_bu_jb_ctrl), 
        .i_ie_dst               (id_ie_dst),
        .i_ie_rf_src_0_data     (id_ie_rf_src_0),
        .i_ie_rf_src_1_data     (id_ie_rf_src_1),
        .i_ie_sx_data           (id_ie_sx_data),
        .i_ie_pc                (id_ie_pc),
        .i_ie_pc_plus_4         (id_ie_pc_plus4), 

        .o_nxt_pc_src           (ie_nxt_pc_src),
        .o_bu_next_dest_jb      (ie_bu_next_dest_jb),
        
        .o_im_bu_next_dest_jb   (ie_im_bu_next_dest_jb),
        .o_im_alu_out           (ie_im_alu_out),
        .o_im_write_data        (ie_im_write_data),
        .o_im_mem_we            (ie_im_mem_we), 
        .o_im_rf_we_ctrl        (ie_im_rf_we_ctrl),
        .o_im_rf_wb_src_ctrl    (ie_im_rf_wb_src_ctrl),
        .o_im_sx_data           (ie_im_sx_data),
        .o_im_pc_plus_4         (ie_im_pc_plus_4), 
        .o_im_dst               (ie_im_dst)
    ); 

    im_stage u3_im(
        .i_clk                  (i_clk),
        .i_rstn                 (i_rstn),
        .i_r_data               (i_r_data),
        .o_we                   (o_we),
        .o_d_add                (o_d_add),
        .o_w_data               (o_w_data),

        .i_im_bu_next_dest_jb   (ie_im_bu_next_dest_jb),
        .i_im_alu_out           (ie_im_alu_out),
        .i_im_rf_we_ctrl        (ie_im_rf_we_ctrl),
        .i_im_rf_wb_src_ctrl    (ie_im_rf_wb_src_ctrl),
        .i_im_sx_data           (ie_im_sx_data),
        .i_im_pc_plus_4         (ie_im_pc_plus_4),
        .i_im_dst               (ie_im_dst),
        .i_im_mem_we            (ie_im_mem_we),
        .i_im_write_data        (ie_im_write_data),
        
        .o_iwb_bu_next_dest_jb  (im_iwb_bu_next_dest_jb),
        .o_iwb_alu_out          (im_iwb_alu_out),
        .o_iwb_r_mem            (im_iwb_r_mem),
        .o_iwb_rf_we_ctrl       (im_iwb_rf_we_ctrl),
        .o_iwb_rf_wb_src_ctrl   (im_iwb_rf_wb_src_ctrl),
        .o_iwb_sx_data          (im_iwb_sx_data),
        .o_iwb_pc_plus_4        (im_iwb_pc_plus_4),
        .o_iwb_dst              (im_iwb_dst)
    ); 

    iwb_stage u4_iwb(


        .i_iwb_bu_next_dest_jb  (im_iwb_bu_next_dest_jb),
        .i_iwb_alu_out          (im_iwb_alu_out),
        .i_iwb_rf_wb_src_ctrl   (im_iwb_rf_wb_src_ctrl),
        .i_iwb_sx_data          (im_iwb_sx_data),
        .i_iwb_pc_plus_4        (im_iwb_pc_plus_4),
        .i_iwb_r_mem            (im_iwb_r_mem), 
        .o_iwb_wb_data          (iwb_out) 
    );



    hazards_ctrl u5_hzd_ctrl(
        .o_if_stall             (if_stall),
        .o_id_stall             (id_stall),
        .o_id_flush             (id_flush),
        .o_ie_flush             (ie_flush),
        .o_ie_forward_0         (ie_forward_0),
        .o_ie_forward_1         (ie_forward_1),
        
        .i_id_src_0             (if_id_instr[19:15]),
        .i_id_src_1             (if_id_instr[24:20]),
        
        .i_ie_src_0             (id_ie_src_0),
        .i_ie_src_1             (id_ie_src_1),
        .i_ie_dst               (id_ie_dst),
        
        .i_ie_nxt_pc_src        (ie_nxt_pc_src),
        .i_ie_wb_src            (id_ie_rf_wb_src_ctrl),
        
        .i_im_dst               (ie_im_dst),
        .i_im_we                (ie_im_rf_we_ctrl),
        
        .i_iwb_we               (im_iwb_rf_we_ctrl),
        .i_iwb_dst              (im_iwb_dst)
    );

    
endmodule 