`include "parameters.vh" 


module ie_stage#(
    parameter  WIDTH = `WIDTH
)(
    input wire                              i_clk,
    input wire                              i_rstn,

    // Controls 
    input wire                              i_ie_branch, 
    input wire                              i_ie_jump,       

    input wire [0:0]                        i_ie_alu_op_src_ctrl,    
    
    input wire                              i_ie_mem_we, 
    input wire                              i_ie_rf_we_ctrl,
    input wire [2:0]                        i_ie_rf_wb_src_ctrl,

    input wire [3:0]                        i_ie_alu_ctrl,           
    input wire                              i_ie_bu_jb_ctrl, 

    input wire [`RF_ADD_SIZE - 1 : 0 ]      i_ie_src_0,
    input wire [`RF_ADD_SIZE - 1 : 0 ]      i_ie_src_1,
    input wire [`RF_ADD_SIZE - 1 : 0 ]      i_ie_dst  ,
    
    input wire [WIDTH - 1 : 0]              i_m_alu_out,
    input wire [WIDTH - 1 : 0]              i_iwb_out,
    
    
    input wire [1 : 0]                      i_forward_0,
    input wire [1 : 0]                      i_forward_1,
    
    
    input wire [WIDTH - 1 : 0]              i_ie_rf_src_0_data,
    input wire [WIDTH - 1 : 0]              i_ie_rf_src_1_data,
    input wire [WIDTH - 1 : 0]              i_ie_sx_data,
    
    
    input wire  [`I_ADD_SIZE - 1 : 0]       i_ie_pc,
    
    
    input wire  [`I_ADD_SIZE - 1 : 0]       i_ie_pc_plus_4, 
    
    
    output wire [WIDTH - 1 : 0]             o_bu_next_dest_jb,
    output wire                             o_nxt_pc_src,
    
    
    
    output reg [WIDTH - 1 : 0]              o_im_bu_next_dest_jb,
    output reg [WIDTH - 1 : 0]              o_im_alu_out,
    output reg [WIDTH - 1 : 0]              o_im_write_data,
    
    output reg                              o_im_mem_we, 
    output reg                              o_im_rf_we_ctrl,
    output reg [2:0]                        o_im_rf_wb_src_ctrl,
    output reg [WIDTH - 1 : 0]              o_im_sx_data,
    output reg [`I_ADD_SIZE - 1 : 0]        o_im_pc_plus_4, 
    output reg [`RF_ADD_SIZE - 1 : 0 ]      o_im_dst
    
);

    reg [WIDTH - 1 : 0]                     forward_op_0;
    reg [WIDTH - 1 : 0]                     forward_op_1;
    
    wire [WIDTH - 1 : 0]                    alu_out;
    wire [WIDTH - 1 : 0]                    alu_op_1;
    wire                                    alu_zero_status;                   
    

    
    // Forwarding Operant 0 
    always @(*) begin

        case (i_forward_0)
            2'b00 :  forward_op_0 <= i_ie_rf_src_0_data;
            2'b01 :  forward_op_0 <= i_m_alu_out;
            2'b10 :  forward_op_0 <= i_iwb_out; 
            2'b11 :  forward_op_0 <= 'b0; 
        endcase 
    end
    
    


    // ---------------------------------------------------------------


    // Forwarding Operant 1 
    always @(*) begin

        case (i_forward_1)
            2'b00 :  forward_op_1 <= i_ie_rf_src_1_data;
            2'b01 :  forward_op_1 <= i_m_alu_out;
            2'b10 :  forward_op_1 <= i_iwb_out; 
            2'b11 :  forward_op_1 <= 'b0; 
        endcase 
    end

    assign o_nxt_pc_src = (alu_zero_status & i_ie_branch) | i_ie_jump; 
    assign alu_op_1     = (i_ie_alu_op_src_ctrl)? i_ie_sx_data : forward_op_1;

    
    alu alu_u3(
        .i_alu_ctrl(i_ie_alu_ctrl),
        .i_op_0(forward_op_0), 
        .i_op_1(alu_op_1), 
        .o_alu_out(alu_out),
        .o_zero(alu_zero_status)

    ); 


    
    branch_unit bu_u5(
    
        .i_jb_ctrl(i_ie_bu_jb_ctrl),
        .i_pc(i_ie_pc),
        .i_offset(i_ie_sx_data),
        .i_r_src(i_ie_rf_src_0_data),
        .o_nxt_pc(o_bu_next_dest_jb)
    
    );

    always @(posedge i_clk or negedge i_rstn)
        begin
            if (~i_rstn)
                begin

                    o_im_bu_next_dest_jb        <= 'b0;
                    o_im_alu_out                <= 'b0;
                    o_im_write_data             <= 'b0;
                    o_im_mem_we                 <= 'b0;
                    o_im_rf_we_ctrl             <= 'b0;
                    o_im_rf_wb_src_ctrl         <= 'b0;
                    o_im_sx_data                <= 'b0;
                    o_im_pc_plus_4              <= 'b0;
                    o_im_dst                    <= 'b0; 

                end
            else 
                begin
                    o_im_bu_next_dest_jb        <= o_bu_next_dest_jb;  
                    o_im_alu_out                <= alu_out; 
                    o_im_write_data             <= forward_op_1; 
                    o_im_mem_we                 <= i_ie_mem_we;  
                    o_im_rf_we_ctrl             <= i_ie_rf_we_ctrl; 
                    o_im_rf_wb_src_ctrl         <= i_ie_rf_wb_src_ctrl;
                    o_im_sx_data                <= i_ie_sx_data; 
                    o_im_pc_plus_4              <= i_ie_pc_plus_4;
                    o_im_dst                    <= i_ie_dst; 
                    
                end
            
        end
endmodule 