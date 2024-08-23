module alu #(
    parameter DATA_WIDTH = 32,
    parameter RAM_WIDTH = 31,
    parameter FW_LENGTH = 8
) (
    input bit [2:0] func3,
    input bit [6:0] func7,
    input bit [6:0] opcode,

    input bit [DATA_WIDTH - 1:0]    rs1_data,
    input bit [DATA_WIDTH - 1:0]    rs2_data,
    output bit [DATA_WIDTH - 1:0]   rd_data,
    output bit                      rf_we,
    
    input bit [DATA_WIDTH - 1:0]    imm,
    
    input  bit clk,
    inout  logic [DATA_WIDTH - 1:0] ram_data,
    output bit                      ram_we,
    output bit [RAM_WIDTH-1:0]      ram_address,

    input bit [DATA_WIDTH - 1:0]    pc_current_address,
    output bit [DATA_WIDTH - 1:0]   pc_next_address

);
    localparam FW_VOLUME = FW_LENGTH << 2;

    `include "rv32i_id.svh"

    bit [DATA_WIDTH - 1:0] sltu_calc_data;
    bit [DATA_WIDTH - 1:0] _ram_data;

    assign sltu_calc_data = sltu_calc(rs1_data, rs2_data);
    
    assign ram_data = ram_we ? _ram_data : 32'bz;

    function bit [DATA_WIDTH - 1:0] sltu_calc (  input bit [DATA_WIDTH - 1:0] rs1_data,
                                                input bit [DATA_WIDTH - 1:0] rs2_data) ;
        case ({rs1_data[DATA_WIDTH - 1], rs2_data[DATA_WIDTH - 1]})
            `BOTH_POSITIVE:      return rs1_data[DATA_WIDTH - 2:0] < rs2_data[DATA_WIDTH - 2:0] ? 1 : 0;
            `RS1_POS_RS2_NEG:    return 0;
            `RS1_NEG_RS2_POS:    return 1;
            `BOTH_NEGATIVE:      return rs1_data[DATA_WIDTH - 2:0] > rs2_data[DATA_WIDTH - 2:0] ? 1 : 0;
        endcase
    endfunction   


    function bit [DATA_WIDTH - 1:0] sra_calc (  input bit [DATA_WIDTH - 1:0] rs1_data,
                                                input bit [DATA_WIDTH - 1:0] rs2_data) ;
        bit [DATA_WIDTH - 1:0] output_data;
        output_data = rs1_data;
        for (int i = rs2_data; i > 0; i = i -1 ) begin
            output_data = output_data >> 1;
            output_data[DATA_WIDTH - 1] = rs1_data[DATA_WIDTH - 1];
        end
        return output_data;
    endfunction  

    always_comb begin

        rd_data             = '0;
        _ram_data           = 'b0;
        ram_we              = 1'b0;
        ram_address         = 'b0;
        pc_next_address     = (pc_current_address >= FW_VOLUME) ? 0 : pc_current_address + 4;
        rf_we               = 1'b1;
        case (opcode)
            `REG_TO_REG_OP : begin
                case ({func7, func3})
                    `ADD     :   rd_data = rs1_data + rs2_data;
                    `SUB     :   rd_data = rs1_data - rs2_data;
                    `XOR     :   rd_data = rs1_data ^ rs2_data;
                    `OR      :   rd_data = rs1_data | rs2_data;
                    `AND     :   rd_data = rs1_data & rs2_data;
                    `SLL     :   rd_data = rs1_data << rs2_data;
                    `SRL     :   rd_data = rs1_data >> rs2_data;
                    `SRA     :   rd_data = sra_calc (rs1_data,rs2_data);
                    `SLT     :   rd_data = rs1_data < rs2_data ? 1 : 0;
                    `SLTU    :   rd_data = sltu_calc_data;
                    default  :   rd_data = '0;
                endcase
            end

            `REG_TO_IMM_OP : begin
                case ({func7, func3})
                    `ADD     :   rd_data = rs1_data + imm;
                    `XOR     :   rd_data = rs1_data ^ imm;
                    `OR      :   rd_data = rs1_data | imm;
                    `AND     :   rd_data = rs1_data & imm;
                    `SLL     :   rd_data = rs1_data << imm[4:0];
                    `SRL     :   rd_data = rs1_data >> imm[4:0];
                    `SRA     :   rd_data = sra_calc (rs1_data, imm[4:0]);
                    `SLT     :   rd_data = rs1_data < imm ? 1 : 0;
                    `SLTU    :   rd_data = sltu_calc_data;
                    default  :   rd_data = '0;  
                endcase          
            end
            `BRANCH_OP : begin    
                rf_we       = 1'b0;
                case ({func7, func3})
                    `BEQ     :   if (rs1_data == rs2_data)   pc_next_address = pc_current_address + imm;
                    `BNE     :   if (rs1_data == rs2_data)   pc_next_address = pc_current_address + imm;
                    `BLT     :   if (rs1_data <  rs2_data)   pc_next_address = pc_current_address + imm;
                    `BLTU    :   if (sltu_calc_data[0])      pc_next_address = pc_current_address + imm;
                    `BGE     :   if (rs1_data >= rs2_data)   pc_next_address = pc_current_address + imm;
                    `BGEU    :   if (~sltu_calc_data[0])     pc_next_address = pc_current_address + imm;
                    default  :   pc_next_address = (pc_current_address >= FW_VOLUME) ? 0 : pc_current_address + 4;
                endcase
            end

            `LOAD_OP : begin
                ram_address = rs1_data + imm;      
                case ({func7, func3})
                    `LB     : rd_data = {24'b0, ram_data[7:0]};
                    `LH     : rd_data = {16'b0, ram_data[15:0]};
                    `LW     : rd_data = ram_data;
                    `LBU    : rd_data = {{24{ram_data[7]}},  ram_data[7:0]};
                    `LHU    : rd_data = {{16{ram_data[15]}}, ram_data[15:0]};
                endcase
            end

            `STORE_OP : begin
                ram_we      = 1'b1;        
                rf_we       = 1'b0;
                ram_address = rs1_data + imm;
                case ({func7, func3})
                    `SB : _ram_data = {24'b0, rs2_data[7:0]};
                    `SH : _ram_data = {16'b0, rs2_data[15:0]};
                    `SW : _ram_data = rs2_data;
                endcase         
            end

            `LUI_OP : begin  
                case ({func7, func3})
                    `LUI : rd_data = imm;
                endcase
            end

            `AUIPC_OP  : begin                
                case ({func7, func3})
                    `AUIPC  : rd_data = pc_current_address + imm;
                endcase
            end

            `JAL_OP : begin
                case ({func7, func3})
                    `JAL    : begin
                        rd_data = pc_current_address + 4;
                        pc_next_address = pc_current_address + imm;
                    end
                endcase
            end

            `JALR_OP : begin                
                case ({func7, func3})
                    `JALR   : begin
                        rd_data = pc_current_address + 4;
                        pc_next_address = rs1_data + imm;
                    end
                endcase
            end
        endcase
    end

endmodule