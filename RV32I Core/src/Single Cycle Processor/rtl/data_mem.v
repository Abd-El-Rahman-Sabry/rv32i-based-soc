
`include "parameters.vh"


module data_mem #(
    parameter WIDTH = `D_WIDTH , 
    parameter DEPTH = `D_DEPTH 
)(
    input wire                                  i_clk,
    input wire                                  i_rstn,
    input wire                                  i_we,
    input wire  [`D_ADD_SIZE - 1 : 0 ]          i_add,
    input wire  [WIDTH - 1 : 0 ]              i_data,
    output wire [WIDTH - 1 : 0 ]              o_data
); 

    integer i; 

    reg [WIDTH - 1 : 0] mem [0 : DEPTH - 1]; 

    always @(posedge i_clk or negedge i_rstn) begin

        if (~i_rstn)
            begin
                for (i = 0 ; i < DEPTH ; i = i + 1)
                    begin
                        mem[i] <= 0; 
                    end 
            end
        else 
            begin
                if (i_we)
                    begin
                        mem[i_add>>2]       <= i_data; 
                    end

            end
        
    end


    assign o_data = mem[i_add>>2]; 

endmodule 