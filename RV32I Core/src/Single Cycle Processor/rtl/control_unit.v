`include "parameters.vh"


module control_unit(
    output reg          o_alu_op_src_ctrl,
    output wire         o_pc_src_ctrl,
    output reg [2:0]    o_sx_imm_src_ctrl,
    output reg          o_rf_we_ctrl,
    output reg [2:0]    o_rf_wb_scr_ctrl,
    output reg [3:0]    o_alu_ctrl,
    output reg          o_bu_jb_ctrl,
    output reg          o_mem_we, 


    input wire [2:0]    i_funct3,
    input wire [6:0]    i_funct7,
    input wire [6:0]    i_opcode, 
    input wire          i_zero_flg
    
);


reg branch , jump; 

reg [1:0] alu_op;  

always @(*) begin

    case (alu_op)
        2'b00: o_alu_ctrl <= 4'b0000; 
        2'b01: o_alu_ctrl <= 4'b0001;
        2'b10: begin

            case (i_funct3)
        
                // Arithmatic Operation  
                {`FUNCT3_ADD_SUB}:             
                    begin
                        case ({i_opcode[5] , i_funct7[5]})
                        2'b00:  o_alu_ctrl <= 4'b0000;    //ADD  
                        2'b10:  o_alu_ctrl <= 4'b0000;    //ADD  
                        2'b01:  o_alu_ctrl <= 4'b0000;    //ADD  
                        2'b11:  o_alu_ctrl <= 4'b0001;    //SUB  
                        default : o_alu_ctrl <= 4'b0000; 
                        endcase 
                    end
      
                {`FUNCT3_SLTU}:                o_alu_ctrl <= 4'b0010;    //SLTU  
                {`FUNCT3_SLT}:                 o_alu_ctrl <= 4'b0011;    //SLT  
      
                // Logical eration 
                {`FUNCT3_XOR}:                 o_alu_ctrl <= 4'b0100;    //XOR  
                {`FUNCT3_OR}:                  o_alu_ctrl <= 4'b0101;    //OR  
                {`FUNCT3_AND}:                 o_alu_ctrl <= 4'b0110;    //AND  
      
                //Shift Operation 
                {`FUNCT3_SLL}:                 o_alu_ctrl <= 4'b0111;    //SLL  
                {`FUNCT3_SRL_SRA}:             o_alu_ctrl <= (i_funct7[5])? 4'b1001 : 4'b1000;    // 0 : SRL , 1 : SRA     
                default :                      o_alu_ctrl <= 4'b0000; 
            
            endcase     
        end 
        
        2'b11: o_alu_ctrl <= 4'b0000;
    endcase 

end



always @(*) begin
    case (i_opcode)
    `OPCODE_LOAD : 
                begin
                    o_alu_op_src_ctrl   <= 1'b1;
                    branch              <= 1'b0;
                    jump                <= 1'b0;
                    o_sx_imm_src_ctrl   <= 3'b000;
                    o_rf_we_ctrl        <= 1'b1;
                    o_rf_wb_scr_ctrl    <= 3'b001;
                    o_mem_we            <= 1'b0;
                    alu_op              <= 2'b00;
                    o_bu_jb_ctrl        <= 1'b0;
                end
    `OPCODE_STORE : 
                begin
                    o_alu_op_src_ctrl   <= 1'b1;
                    branch              <= 1'b0;
                    jump                <= 1'b0;
                    o_sx_imm_src_ctrl   <= 3'b001;
                    o_rf_we_ctrl        <= 1'b0;
                    o_mem_we            <= 1'b1;
                    o_rf_wb_scr_ctrl    <= 3'b000;
                    alu_op              <= 2'b00;
                    o_bu_jb_ctrl        <= 1'b0;
                end
    `OPCODE_BRANCH : 
                begin
                    o_alu_op_src_ctrl   <= 1'b0;
                    branch              <= 1'b1;
                    jump                <= 1'b0;
                    o_sx_imm_src_ctrl   <= 3'b010;
                    o_rf_we_ctrl        <= 1'b0;
                    o_mem_we            <= 1'b0;
                    o_rf_wb_scr_ctrl    <= 3'b000;
                    alu_op              <= 2'b01;
                    o_bu_jb_ctrl        <= 1'b1;
                end
    `OPCODE_IMM : 
                begin
                    o_alu_op_src_ctrl   <= 1'b1;
                    branch              <= 1'b0;
                    jump                <= 1'b0;
                    o_sx_imm_src_ctrl   <= 3'b000;
                    o_rf_we_ctrl        <= 1'b1;
                    o_mem_we            <= 1'b0;
                    o_rf_wb_scr_ctrl    <= 3'b000;
                    alu_op              <= 2'b10;
                    o_bu_jb_ctrl        <= 1'b0;
                end
    `OPCODE_OP : 
                begin
                    o_alu_op_src_ctrl   <= 1'b0;
                    branch              <= 1'b0;
                    jump                <= 1'b0;
                    o_sx_imm_src_ctrl   <= 3'b000;
                    o_rf_we_ctrl        <= 1'b1;
                    o_mem_we            <= 1'b0;
                    o_rf_wb_scr_ctrl    <= 3'b000;
                    alu_op              <= 2'b10;
                    o_bu_jb_ctrl        <= 1'b0;
                end
    `OPCODE_LUI : 
                begin
                    o_alu_op_src_ctrl   <= 1'b0;
                    branch              <= 1'b0;
                    jump                <= 1'b0;
                    o_sx_imm_src_ctrl   <= 3'b100;
                    o_rf_we_ctrl        <= 1'b1;
                    o_mem_we            <= 1'b0;
                    o_rf_wb_scr_ctrl    <= 3'b011;
                    alu_op              <= 2'b00;
                    o_bu_jb_ctrl        <= 1'b0;
                end
    `OPCODE_AUIPC : 
                begin
                    o_alu_op_src_ctrl   <= 1'b0;
                    branch              <= 1'b0;
                    jump                <= 1'b0;
                    o_sx_imm_src_ctrl   <= 3'b100;
                    o_rf_we_ctrl        <= 1'b1;
                    o_mem_we            <= 1'b0;
                    o_rf_wb_scr_ctrl    <= 3'b100;
                    alu_op              <= 2'b00;
                    o_bu_jb_ctrl        <= 1'b0;
                end
    `OPCODE_JAL : 
                begin
                    o_alu_op_src_ctrl   <= 1'b0;
                    branch              <= 1'b1;
                    jump                <= 1'b1;
                    o_sx_imm_src_ctrl   <= 3'b011;
                    o_rf_we_ctrl        <= 1'b0;
                    o_mem_we            <= 1'b0;
                    o_rf_wb_scr_ctrl    <= 3'b000;
                    alu_op              <= 2'b00;
                    o_bu_jb_ctrl        <= 1'b1;
                end

    `OPCODE_JALR : 
                begin
                    o_alu_op_src_ctrl   <= 1'b0;
                    branch              <= 1'b1;
                    jump                <= 1'b1;
                    o_sx_imm_src_ctrl   <= 3'b000;
                    o_rf_we_ctrl        <= 1'b1;
                    o_mem_we            <= 1'b0;
                    o_rf_wb_scr_ctrl    <= 3'b010;
                    alu_op              <= 2'b00;
                    o_bu_jb_ctrl        <= 1'b0;
                end

    default : 
            begin
                    o_alu_op_src_ctrl   <= 1'b0;
                    branch              <= 1'b0;
                    jump                <= 1'b0;
                    o_sx_imm_src_ctrl   <= 3'b000;
                    o_rf_we_ctrl        <= 1'b0;
                    o_mem_we            <= 1'b0;
                    o_rf_wb_scr_ctrl    <= 3'b010;
                    alu_op              <= 2'b00;
                    o_bu_jb_ctrl        <= 1'b0;
                end


                

    endcase


    
end


    assign o_pc_src_ctrl = (branch & i_zero_flg)|jump;


endmodule