
`include "parameters.vh"

module pc_reg #(
    parameter WIDTH = `I_ADD_SIZE
)(
    input wire                      i_clk,
    input wire                      i_rstn,
    input wire                      i_en,

    input   [WIDTH - 1 : 0 ]        i_nxt_pc,
    output  reg [WIDTH - 1 : 0 ]    o_pc
);


    always @(posedge i_clk or negedge i_rstn) begin
        if (~i_rstn)
            begin
                o_pc <= 'b0; 
            end
        else 
            begin
                if (~i_en)
                    begin
                        o_pc <= i_nxt_pc; 
                    end
            end
        
    end
endmodule 