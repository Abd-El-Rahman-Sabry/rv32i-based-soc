`include "parameters.vh"


module iwb_stage #(
    parameter WIDTH = `WIDTH 
)(
    input wire                                     i_clk,    
    input wire                                     i_rstn,
    input wire    [WIDTH - 1 : 0]                  i_iwb_bu_next_dest_jb ,
    input wire    [WIDTH - 1 : 0]                  i_iwb_alu_out         ,
    input wire                                     i_iwb_rf_we_ctrl      ,
    input wire    [2:0]                            i_iwb_rf_wb_src_ctrl  ,
    input wire    [WIDTH - 1 : 0]                  i_iwb_sx_data         ,
    input wire    [WIDTH - 1 : 0]                  i_iwb_pc_plus_4       ,
    input wire    [`RF_ADD_SIZE - 1 : 0]           i_iwb_dst             ,
    input wire    [WIDTH - 1 : 0]                  i_iwb_r_mem           ,               

    output reg    [`WIDTH - 1 : 0]                 o_iwb_wb_data  

    );
    



    always @(*) begin
        case (i_iwb_rf_wb_src_ctrl)
            3'b000 : o_iwb_wb_data <= i_iwb_alu_out; 
            3'b001 : o_iwb_wb_data <= i_iwb_r_mem; 
            3'b010 : o_iwb_wb_data <= i_iwb_pc_plus_4; 
            3'b011 : o_iwb_wb_data <= i_iwb_sx_data; 
            3'b100 : o_iwb_wb_data <= i_iwb_bu_next_dest_jb;
            default : o_iwb_wb_data <= 'b0;  
        endcase 
    end

    

endmodule 