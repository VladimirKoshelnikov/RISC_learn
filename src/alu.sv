module alu #(
    DATA_WIDTH = 32
) (
    input bit [2:0] func3,
    input bit [6:0] func7,
    
    input bit [DATA_WIDTH - 1:0] rs1_data,
    input bit [DATA_WIDTH - 1:0] rs2_data,

    input bit [DATA_WIDTH - 1:0] rd_data 
);
    `define ALU_ADD  10'b0000000000
    `define ALU_SUB  10'b0100000000
    `define ALU_XOR  10'b0000000100
    `define ALU_OR   10'b0000000110
    `define ALU_AND  10'b0000000111
    `define ALU_SLL  10'b0000000001
    `define ALU_SRL  10'b0000000101
    `define ALU_SRA  10'b0100000101
    `define ALU_SLT  10'b0000000010
    `define ALU_SLTU 10'b0000000011

    `define ALU_BOTH_POSITIVE    2'b00
    `define ALU_RS1_POS_RS2_NEG  2'b01
    `define ALU_RS1_NEG_RS2_POS  2'b10
    `define ALU_BOTH_NEGATIVE    2'b11

    always_comb begin : alu
        case ({func7, func3})
            `ALU_ADD     :   rd_data = rs1_data + rs2_data;
            `ALU_SUB     :   rd_data = rs1_data - rs2_data;
            `ALU_XOR     :   rd_data = rs1_data ^ rs2_data;
            `ALU_OR      :   rd_data = rs1_data | rs2_data;
            `ALU_AND     :   rd_data = rs1_data & rs2_data;
            `ALU_SLL     :   rd_data = rs1_data << rs2_data;
            `ALU_SRL     :   rd_data = rs1_data >> rs2_data;
            `ALU_SRA     :   rd_data = {rs1_data[DATA_WIDTH - 1],   rs1_data[DATA_WIDTH - 2:0] >> rs2_data};
            `ALU_SLTU    :   rd_data = rs1_data < rs2_data ? 1 : 0;
            `ALU_SLT     :   rd_data = slt_calc(rs1_data, rs2_data);
        endcase
    end

    function bit [DATA_WIDTH - 1:0] slt_calc (  input bit [DATA_WIDTH - 1:0] rs1_data,
                                                input bit [DATA_WIDTH - 1:0] rs2_data) ;
        case ({rs1_data[DATA_WIDTH - 1], rs2_data[DATA_WIDTH - 1]})
            `ALU_BOTH_POSITIVE:      return rs1_data[DATA_WIDTH - 2:0] > rs2_data[DATA_WIDTH - 2:0] ? 1 : 0;
            `ALU_RS1_POS_RS2_NEG:    return 0;
            `ALU_RS1_NEG_RS2_POS:    return 1;
            `ALU_BOTH_NEGATIVE:      return rs1_data[DATA_WIDTH - 2:0] < rs2_data[DATA_WIDTH - 2:0] ? 1 : 0;
        endcase
    endfunction


endmodule