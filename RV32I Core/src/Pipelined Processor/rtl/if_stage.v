`include "parameters.vh"



module if_stage #(
    parameter WIDTH = `I_WIDTH
)(
    input wire                                  i_clk,
    input wire                                  i_rstn,
    
    // Hazards Control
    input wire                                  i_if_stall,
    input wire                                  i_id_stall,
    input wire                                  i_id_flush,

    input wire                                  i_pc_src_ctrl,

    // Instruction Memory Interface 
    input   wire  [WIDTH  - 1 : 0 ]             i_instr, 
    output  wire  [WIDTH  - 1 : 0 ]             o_instr_add, 
    
    // Branch Dicision 
    input   wire  [WIDTH  - 1 : 0 ]             i_bu_next_dest_jb, 
    
    
    // Pipe output 
    output reg [WIDTH  - 1 : 0 ]                o_id_pc_out,
    output reg [`I_ADD_SIZE  - 1 : 0 ]          o_id_pc_plus_4,
    output reg  [WIDTH  - 1 : 0 ]               o_id_instr
);

    // Program Counter Interanl Signals 

    wire [`I_ADD_SIZE -1 : 0] pc_src_val;

    wire [WIDTH  - 1 : 0 ]           pc_out;
    wire [`I_ADD_SIZE  - 1 : 0 ]     pc_plus_4;
    reg  [WIDTH  - 1 : 0 ]           instr;

    
    adder u0_adder (
        .a(pc_out),
        .b('d4),
        .r(pc_plus_4)
    );

    assign pc_src_val   = (i_pc_src_ctrl) ? i_bu_next_dest_jb : pc_plus_4;


    pc_reg u1_pc_reg(
        .i_en(i_if_stall),
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_nxt_pc(pc_src_val),
        .o_pc(pc_out)
    );


    // Pipe
    always @(posedge i_clk or negedge i_rstn) begin
            if(~i_rstn)
                begin   
                    o_id_pc_out            <= 'b0; 
                    o_id_pc_plus_4         <= 'b0;                 
                    o_id_instr            <= 'b0;                 
                end
            else 
                begin
                    if (~i_id_flush)
                        begin

                            if(~i_id_stall)
                                begin
                                    o_id_pc_out        <= pc_out; 
                                    o_id_pc_plus_4     <= pc_plus_4;
                                    o_id_instr         <= instr;
                                end
                            
                        end
                        
                    else 
                        
                        begin

                            o_id_pc_out        <= 'b0; 
                            o_id_pc_plus_4     <= 'b0;
                            o_id_instr         <= 'b0;
                        end
                end
    end


    assign o_instr_add = pc_out; 

endmodule 