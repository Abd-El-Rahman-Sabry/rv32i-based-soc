`timescale 1ns/100ps







module data_mem_tb;

    parameter CLOCK_CYCLE = 100;


        reg clk , rst_n; 



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
    wire [31 : 0] inst; 
    wire [31 : 0] data; 
    reg  [31 : 0] add; 

    data_mem dut(
        .i_clk(clk),
        .i_rstn(rst_n),
        .i_we('b0),
        .i_add(add),
        .i_data('b0),
        .o_data(data)
    );

    
    integer  i;

    initial begin
        $dumpfile("dump.vcd"); 
        $dumpvars; 
        clk <= 1'b0;
        reset();
        for (i = 0 ; i < 'h200 ; i = i + 4)
            begin
                add <= i; 
                #(CLOCK_CYCLE);
            end
        #(CLOCK_CYCLE);

        $finish;

    end


endmodule