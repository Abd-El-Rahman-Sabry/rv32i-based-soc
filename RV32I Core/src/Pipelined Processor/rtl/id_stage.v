`include "parameters.vh"



module id_stage #(
    parameter WIDTH = `WIDTH
)(
    input wire                                  i_clk,
    input wire                                  i_rstn,

    //Input 
    
    input wire  [`RF_ADD_SIZE - 1 : 0]          i_iwb_dst,
    input wire  [WIDTH - 1 : 0]                 i_iwb_data,
    input wire                                  i_we, 

    // Previous Pipe data 
    
    input wire  [`I_ADD_SIZE - 1 : 0]           i_id_instr,
    input wire  [`I_ADD_SIZE - 1 : 0]           i_id_pc,
    input wire  [`I_ADD_SIZE - 1 : 0]           i_id_pc_plus4, 


   
    output reg  [`I_ADD_SIZE - 1 : 0]           o_ie_pc,
    output reg  [`I_ADD_SIZE - 1 : 0]           o_ie_pc_plus4, 


    // Data Hazards signals 

    input wire                                  i_ie_flush, 

    // Pipe out 
    
    // Controls 
        output reg                              o_ie_branch, 
        output reg                              o_ie_jump,               
        output reg [0:0]                        o_ie_alu_op_src_ctrl,    
        output reg [3:0]                        o_ie_alu_ctrl,           

        output reg                              o_ie_rf_we_ctrl,
        output reg [2:0]                        o_ie_rf_wb_src_ctrl, 
        output reg                              o_ie_bu_jb_ctrl, 
        output reg                              o_ie_mem_we, 
        output reg [WIDTH - 1 : 0]              o_ie_rf_src_0,
        output reg [WIDTH - 1 : 0]              o_ie_rf_src_1,
        output reg [WIDTH - 1 : 0]              o_ie_sx_data,
        
        
        output reg [`RF_ADD_SIZE - 1 : 0]        o_ie_src_0,
        output reg [`RF_ADD_SIZE - 1 : 0]        o_ie_src_1,
        output reg [`RF_ADD_SIZE - 1 : 0]        o_ie_dst

); 

    /*

        Control Signals 

    */


    wire                        id_branch;            //PC 
    wire                        id_jump;              //PC 
    wire [0:0]                  id_alu_op_src_ctrl;   //ALU 
    wire [3:0]                  id_alu_ctrl;          //ALU 
    wire [2:0]                  id_sx_immd_src_ctrl;  //IMMEDIATE 
    wire                        id_rf_we_ctrl; 
    wire [2:0]                  id_rf_wb_src_ctrl; 
    wire                        id_bu_jb_ctrl; 
    wire                        id_mem_we; 

    wire [WIDTH - 1 : 0]        id_rf_src_0;
    wire [WIDTH - 1 : 0]        id_rf_src_1;
    wire [WIDTH - 1 : 0]        id_sx_data;



 
    control_unit u6(

        .o_alu_op_src_ctrl(id_alu_op_src_ctrl),
        .o_branch(id_branch),
        .o_jump(id_jump),
        .o_sx_imm_src_ctrl(id_sx_immd_src_ctrl),
        .o_rf_we_ctrl(id_rf_we_ctrl),
        .o_rf_wb_scr_ctrl(id_rf_wb_src_ctrl),
        .o_alu_ctrl(id_alu_ctrl),
        .o_bu_jb_ctrl(id_bu_jb_ctrl),
        .o_mem_we(id_mem_we), 
        
        .i_funct3(i_id_instr[14:12]),
        .i_funct7(i_id_instr[31:25]),
        .i_opcode(i_id_instr[6:0])    
    
    );



    sign_extend u4(
        
        .i_src(id_sx_immd_src_ctrl),
        .i_immd(i_id_instr[31:7]),

        .o_sx_immd(id_sx_data)
    );



    regfile u2(
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        
        .i_w(i_we),
        
        .i_src_0(i_id_instr[19:15]),
        .i_src_1(i_id_instr[24:20]),
        .i_dst(i_iwb_dst),
        
        .i_data(i_iwb_data),
        
        .o_d_src_0(id_rf_src_0),
        .o_d_src_1(id_rf_src_1) 
    );



    always @(posedge i_clk or negedge i_rstn) begin

        if (~i_rstn)
            begin
                // Controls 
                o_ie_branch                 <= 'b0;
                o_ie_jump                   <= 'b0;
                o_ie_alu_op_src_ctrl        <= 'b0;
                o_ie_alu_ctrl               <= 'b0;
                o_ie_rf_we_ctrl             <= 'b0;
                o_ie_rf_wb_src_ctrl         <= 'b0;
                o_ie_bu_jb_ctrl             <= 'b0;
                o_ie_mem_we                 <= 'b0;
                
                // Register File 
                o_ie_rf_src_0               <= 'b0;
                o_ie_rf_src_1               <= 'b0;
                
                // Immediate 
                o_ie_sx_data                <= 'b0;


                o_ie_pc                     <= 'b0;
                o_ie_pc_plus4               <= 'b0;

                o_ie_src_0                  <= 'b0;
                o_ie_src_1                  <= 'b0;
                o_ie_dst                    <= 'b0;
                
                
            end
        else 
            begin
                if (~i_ie_flush)
                    begin
                        // Controls 
                        o_ie_branch                 <= id_branch; 
                        o_ie_jump                   <= id_jump;             
                        o_ie_alu_op_src_ctrl        <= id_alu_op_src_ctrl;    
                        o_ie_alu_ctrl               <= id_alu_ctrl;          

                        o_ie_rf_we_ctrl             <= id_rf_we_ctrl;
                        o_ie_rf_wb_src_ctrl         <= id_rf_wb_src_ctrl; 
                        o_ie_bu_jb_ctrl             <= id_bu_jb_ctrl;
                        o_ie_mem_we                 <= id_mem_we;
                        
                        // Register File 
                        o_ie_rf_src_0               <= id_rf_src_0;
                        o_ie_rf_src_1               <= id_rf_src_1;
                        

                        // Immediate 
                        o_ie_sx_data                <= id_sx_data;


                        o_ie_pc                     <= i_id_pc      ;
                        o_ie_pc_plus4               <= i_id_pc_plus4;


                        o_ie_src_0                  <= i_id_instr[19:15];
                        o_ie_src_1                  <= i_id_instr[24:20];
                        o_ie_dst                    <= i_id_instr[11:7];
                    end 
                else 
                    begin
                        // Controls 
                        o_ie_branch                 <= 'b0;
                        o_ie_jump                   <= 'b0;
                        o_ie_alu_op_src_ctrl        <= 'b0;
                        o_ie_alu_ctrl               <= 'b0;

                        o_ie_rf_we_ctrl             <= 'b0;
                        o_ie_rf_wb_src_ctrl         <= 'b0;
                        o_ie_bu_jb_ctrl             <= 'b0;
                        o_ie_mem_we                 <= 'b0;
                        
                        // Register File 
                        o_ie_rf_src_0               <= 'b0;
                        o_ie_rf_src_1               <= 'b0;
                        
                        // Immediate 
                        o_ie_sx_data                <= 'b0;


                        o_ie_pc                     <= 'b0;

                        o_ie_pc_plus4               <= 'b0;
                        
                        
                        o_ie_src_0                  <= 'b0;
                        o_ie_src_1                  <= 'b0;
                        o_ie_dst                    <= 'b0;
                    end
            end
        
    end



endmodule 