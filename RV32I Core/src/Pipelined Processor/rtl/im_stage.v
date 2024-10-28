`include "parameters.vh"



module im_stage #(
    parameter WIDTH = `WIDTH 
)(
    input wire                              i_clk, 
    input wire                              i_rstn,
    
    // Date Memory Interface 
    // ---------------------------------------------------------
    
    input  wire [`WIDTH - 1 : 0]            i_r_data,
    
    output wire                             o_we,
    output wire [`D_ADD_SIZE - 1 : 0]       o_d_add,
    output wire [`WIDTH - 1 : 0]            o_w_data,

    // ---------------------------------------------------------
    
    input wire  [WIDTH - 1 : 0]             i_im_bu_next_dest_jb ,
    input wire  [WIDTH - 1 : 0]             i_im_alu_out         ,
    input wire                              i_im_rf_we_ctrl      ,
    input wire  [2:0]                       i_im_rf_wb_src_ctrl  ,
    input wire  [WIDTH - 1 : 0]             i_im_sx_data         ,
    input wire  [WIDTH - 1 : 0]             i_im_pc_plus_4       ,
    input wire  [`RF_ADD_SIZE - 1 : 0]      i_im_dst             ,
    
    output reg  [WIDTH - 1 : 0]             o_iwb_bu_next_dest_jb ,
    output reg  [WIDTH - 1 : 0]             o_iwb_alu_out         ,
    output reg  [WIDTH - 1 : 0]             o_iwb_r_mem           ,
    output reg                              o_iwb_rf_we_ctrl      ,
    output reg  [2:0]                       o_iwb_rf_wb_src_ctrl  ,
    output reg  [WIDTH - 1 : 0]             o_iwb_sx_data         ,
    output reg  [WIDTH - 1 : 0]             o_iwb_pc_plus_4       ,
    output reg  [`RF_ADD_SIZE - 1 : 0]      o_iwb_dst             ,
        
    input wire                              i_im_mem_we           ,
    input wire  [WIDTH - 1 : 0]             i_im_write_data      
    
    // ---------------------------------------------------------


);



    assign o_d_add      = i_im_alu_out; 
    assign o_w_data     = i_im_write_data;
    assign o_we         = i_im_mem_we;



    always @(posedge i_clk or negedge i_rstn) 
        begin

            if (~i_rstn)
                begin
                    o_iwb_bu_next_dest_jb       <= 'b0; 
                    o_iwb_alu_out               <= 'b0; 
                    o_iwb_rf_we_ctrl            <= 'b0; 
                    o_iwb_rf_wb_src_ctrl        <= 'b0; 
                    o_iwb_sx_data               <= 'b0; 
                    o_iwb_pc_plus_4             <= 'b0; 
                    o_iwb_dst                   <= 'b0; 
                    o_iwb_r_mem                 <= 'b0; 
                end
            else 
                begin
                    o_iwb_bu_next_dest_jb       <= i_im_bu_next_dest_jb; 
                    o_iwb_alu_out               <= i_im_alu_out; 
                    o_iwb_rf_we_ctrl            <= i_im_rf_we_ctrl; 
                    o_iwb_rf_wb_src_ctrl        <= i_im_rf_wb_src_ctrl; 
                    o_iwb_sx_data               <= i_im_sx_data; 
                    o_iwb_pc_plus_4             <= i_im_pc_plus_4; 
                    o_iwb_dst                   <= i_im_dst; 
                    o_iwb_r_mem                 <= i_r_data;
                end


    end


endmodule 