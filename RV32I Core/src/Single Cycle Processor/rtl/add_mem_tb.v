`timescale 1ns/100ps







module mem_tb;

    parameter CLOCK_CYCLE = 100;

    wire [31 : 0] inst; 
    reg  [31 : 0] add; 

    instr_mem dut(
        .i_add(add),
        .o_instr(inst)
    );

    
    integer  i;

    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars; 
        for (i = 0 ; i < 200 ; i = i + 4)
            begin
                add <= i; 
                #(CLOCK_CYCLE);
            end
        #(CLOCK_CYCLE);

        $finish;

    end


endmodule