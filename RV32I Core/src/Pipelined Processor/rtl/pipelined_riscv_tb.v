`timescale 1ns/100ps







module pipelined_riscv_tb;

    parameter CLOCK_CYCLE = 100;


    reg clk , rst_n; 

    pipelined_riscv_core dut(
        .i_clk(clk),
        .i_rstn(rst_n)
    );



    always #(CLOCK_CYCLE/2) clk = !clk;
    
    

    task reset;
        begin
            rst_n <= 'b1;
            #(CLOCK_CYCLE/2); 
            rst_n <= 'b0;
            #(CLOCK_CYCLE/2);  
            rst_n <= 'b1;
        end
    endtask 


    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars; 
        clk <= 'b0;
        rst_n <= 'b1;
        reset(); 

        #(100 * CLOCK_CYCLE);

        $finish;

    end


endmodule