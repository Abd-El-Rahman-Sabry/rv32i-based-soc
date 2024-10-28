`include "parameters.vh"

module regfile #(
    parameter WIDTH = `WIDTH, 
    parameter DEPTH = `RF_DEPTH 
)(
    input                                           i_clk,
    input                                           i_rstn,
    input                                           i_w, 
    input   [`RF_ADD_SIZE  - 1: 0]                  i_src_0,  
    input   [`RF_ADD_SIZE  - 1: 0]                  i_src_1,  
    input   [`RF_ADD_SIZE  - 1: 0]                  i_dst,  
    input   [WIDTH - 1 : 0]                         i_data, 
    output  [WIDTH - 1 : 0]                         o_d_src_0, 
    output  [WIDTH - 1 : 0]                         o_d_src_1 
    
);

    integer  i;
    reg [WIDTH - 1 : 0] rf [0 : DEPTH - 1]; 


    always @(negedge i_clk or negedge i_rstn)
        begin
            if (~i_rstn)
                begin 
                    for (i = 0 ;i < DEPTH ; i = i + 1)
                        begin
                            rf[i] <= 'b0; 
                        end 
                end
            else 
                begin
                    if (i_w)
                        begin
                            rf[i_dst] <= i_data; 
                        end
                end
        end
    

    assign o_d_src_0 = rf[i_src_0]; 
    assign o_d_src_1 = rf[i_src_1]; 

endmodule 