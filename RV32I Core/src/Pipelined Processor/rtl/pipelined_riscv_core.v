`include "parameters.vh"



module pipelined_riscv_core#(
    parameter  WIDTH = 32
)(
    input wire                  i_clk, 
    input wire                  i_rstn 

);

// Instruction Memory Nets 
wire [WIDTH - 1 : 0]            instr_add;
wire [WIDTH - 1 : 0]            instr;

// Data Memory 

wire [WIDTH - 1 : 0]            w_data;
wire [WIDTH - 1 : 0]            r_data;
wire [`D_ADD_SIZE - 1 : 0]      w_data_add;

wire                            we; 


instr_mem u0(
    .i_add          (instr_add),
    .o_instr        (instr)
);


data_mem u1(
    .i_clk          (i_clk),
    .i_rstn         (i_rstn),
    .i_we           (we),
    .i_add          (w_data_add),
    .i_data         (w_data),
    .o_data         (r_data)
);


pipelined_riscv_datapath u2(
    .i_clk          (i_clk),
    .i_rstn         (i_rstn),
    // Instruction Memory Interface 
        
    
    .i_instr_mem_out(instr),
    .o_instr_add    (instr_add),
    
    // Date Memory Interface 
    
    .o_we           (we),
    .o_d_add        (w_data_add),
    .o_w_data       (w_data),
    .i_r_data       (r_data)
);

endmodule 