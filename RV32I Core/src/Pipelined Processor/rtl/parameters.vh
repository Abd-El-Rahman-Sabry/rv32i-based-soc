`ifndef PARAMS
`define PARAMS 

`include "riscv_registers.vh"
`include "riscv_h.vh"

// Main system 

    `define     WIDTH           32 
    
// Register file 

    `define     RF_DEPTH        32 
    `define     RF_ADD_SIZE     $clog2(`RF_DEPTH) 


// Date Memory 

    `define     D_WIDTH         32 
    `define     D_DEPTH         2^30 
    `define     D_ADD_SIZE      32
    
// Instruction Memory 

    `define     I_WIDTH         32 
    `define     I_DEPTH         2^32 
    `define     I_ADD_SIZE      32 



`endif