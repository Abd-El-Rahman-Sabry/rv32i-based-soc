`include "parameters.vh"


module hazards_ctrl #(
    parameter WIDTH = `RF_ADD_SIZE
)(
    output  wire                         o_if_stall,
    output  wire                         o_id_stall,
    output  wire                         o_id_flush,
    output  wire                         o_ie_flush,
    output  reg        [1:0]            o_ie_forward_0,
    output  reg        [1:0]            o_ie_forward_1,


    input wire          [WIDTH - 1 : 0]  i_id_src_0,
    input wire          [WIDTH - 1 : 0]  i_id_src_1,
    
    input wire         [WIDTH - 1 : 0]  i_ie_src_0,
    input wire         [WIDTH - 1 : 0]  i_ie_src_1,
    input wire         [WIDTH - 1 : 0]  i_ie_dst,
    input wire                          i_ie_nxt_pc_src, 
    input wire         [2:0]            i_ie_wb_src,                 
    
    input wire         [WIDTH - 1 : 0]  i_im_dst,
    input wire                          i_im_we,
    
    input wire                          i_iwb_we,
    input wire         [WIDTH - 1 : 0]  i_iwb_dst

);

    // Forwarding Logic 

    always @(*) begin
        if (((i_ie_src_0 == i_im_dst ) & i_im_we) & (i_ie_src_0 != 'b0))
            begin
                o_ie_forward_0 <= 2'b01; 
            end
        else if (((i_ie_src_0 == i_iwb_dst ) & i_iwb_we) & (i_ie_src_0 != 'b0))
            begin
                o_ie_forward_0 <= 2'b10;
            end
        else 
            begin
                o_ie_forward_0 <= 2'b00;
            end
    end


    // Forwarding Logic 

    always @(*) begin
        if (((i_ie_src_1 == i_im_dst ) & i_im_we) & (i_ie_src_1 != 'b0))
            begin
                o_ie_forward_1 <= 2'b01; 
            end
        else if (((i_ie_src_1 == i_iwb_dst ) & i_iwb_we) & (i_ie_src_1 != 'b0))
            begin
                o_ie_forward_1 <= 2'b10;
            end
        else 
            begin
                o_ie_forward_1 <= 2'b00;
            end
    end

    
    
    assign lw_stall =  (i_ie_wb_src == 3'b001) & ((i_id_src_0 == i_ie_dst) | (i_id_src_1 == i_ie_dst));
    assign o_if_stall =  lw_stall; 
    //assign o_if_stall =  'b0;
    
    assign o_id_stall =  lw_stall; 
    //assign o_id_stall =  'b0;
    
    assign o_id_flush = i_ie_nxt_pc_src; 

    assign o_ie_flush = i_ie_nxt_pc_src | lw_stall ; 


endmodule