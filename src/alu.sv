module alu #(
    parameter DATA_WIDTH = 32
) (
    input bit [2:0] func3,
    input bit [6:0] func7,
    input bit [6:0] opcode,
    input bit [5:0] rs1,
    input bit [5:0] rs2,

    input bit [DATA_WIDTH - 1:0]    rs1_data,
    input bit [DATA_WIDTH - 1:0]    rs2_data,
    
    inout  logic [DATA_WIDTH - 1:0] ram_data,
    output bit                      ram_we,
    output bit [16:0]               ram_address,

    output bit [DATA_WIDTH - 1:0]   rd_data,

    output bit branch_logic_data
);

    // Opcodes peration
    `define REG_TO_REG_OP   7'b0010011
    `define REG_TO_IMM_OP   7'b0110011
    `define BRANCH_OP       7'b1100011
    `define LOAD_OP         7'b0000011
    `define STORE_OP        7'b0100011
    `define LUI_OP          7'b0110111
    `define AUIPC_OP        7'b0010111
    `define JAL_OP          7'b1101111
    `define JALR_OP         7'b1100111

    // Register-register or Register-immediate calculation 
    `define ADD  10'b0000000000
    `define SUB  10'b0100000000
    `define XOR  10'b0000000100
    `define OR   10'b0000000110
    `define AND  10'b0000000111
    `define SLL  10'b0000000001
    `define SRL  10'b0000000101
    `define SRA  10'b0100000101
    `define SLT  10'b0000000010
    `define SLTU 10'b0000000011

    // Branch operation
    `define BEQ  10'b0000000000
    `define BNE  10'b0000000001
    `define BLT  10'b0000000100
    `define BLTU 10'b0000000101
    `define BGE  10'b0000000110
    `define BGEU 10'b0000000111

    // Load operation
    `define LB   10'b0000000000
    `define LH   10'b0000000001
    `define LW   10'b0000000010
    `define LBU  10'b0000000100
    `define LHU  10'b0000000101

    // Store operation
    `define SB   10'b0000000000
    `define SH   10'b0000000001
    `define SW   10'b0000000010

    `define BOTH_POSITIVE    2'b00
    `define RS1_POS_RS2_NEG  2'b01
    `define RS1_NEG_RS2_POS  2'b10
    `define BOTH_NEGATIVE    2'b11

    bit [DATA_WIDTH - 1:0] slt_calc_data;
    assign slt_calc_data = slt_calc(rs1_data, rs2_data);

    function bit [DATA_WIDTH - 1:0] slt_calc (  input bit [DATA_WIDTH - 1:0] rs1_data,
                                                input bit [DATA_WIDTH - 1:0] rs2_data) ;
        case ({rs1_data[DATA_WIDTH - 1], rs2_data[DATA_WIDTH - 1]})
            `BOTH_POSITIVE:      return rs1_data[DATA_WIDTH - 2:0] < rs2_data[DATA_WIDTH - 2:0] ? 1 : 0;
            `RS1_POS_RS2_NEG:    return 0;
            `RS1_NEG_RS2_POS:    return 1;
            `BOTH_NEGATIVE:      return rs1_data[DATA_WIDTH - 2:0] > rs2_data[DATA_WIDTH - 2:0] ? 1 : 0;
        endcase
    endfunction

    bit [9:0] functions_data;
    assign functions_data = {func7, func3}

    always_comb begin
        
        rd_data             = '0;
        branch_logic_data   = 1'b0;
        ram_we              = 1'b0;
        ram_address         = 17'b0;

        case (opcode)
            `REG_TO_REG_OP : begin
                case (functions_data)
                    `ADD     :   rd_data = rs1_data + rs2_data;
                    `SUB     :   rd_data = rs1_data - rs2_data;
                    `XOR     :   rd_data = rs1_data ^ rs2_data;
                    `OR      :   rd_data = rs1_data | rs2_data;
                    `AND     :   rd_data = rs1_data & rs2_data;
                    `SLL     :   rd_data = rs1_data << rs2_data;
                    `SRL     :   rd_data = rs1_data >> rs2_data;
                    `SRA     :   rd_data = {rs1_data[DATA_WIDTH - 1],   rs1_data[DATA_WIDTH - 2:0] >> rs2_data};
                    `SLTU    :   rd_data = rs1_data < rs2_data ? 1 : 0;
                    `SLT     :   rd_data = slt_calc_data;
                    default  :   rd_data = '0;
                endcase
            end

            `REG_TO_IMM_OP : begin
                case (functions_data)
                    `ADD     :   rd_data = rs1_data + rs2_data;
                    `XOR     :   rd_data = rs1_data ^ rs2_data;
                    `OR      :   rd_data = rs1_data | rs2_data;
                    `AND     :   rd_data = rs1_data & rs2_data;
                    `SLL     :   rd_data = rs1_data << rs2_data;
                    `SRL     :   rd_data = rs1_data >> rs2_data;
                    `SRA     :   rd_data = {rs1_data[DATA_WIDTH - 1],   rs1_data[DATA_WIDTH - 2:0] >> rs2_data};
                    `SLTU    :   rd_data = rs1_data < rs2_data ? 1 : 0;
                    `SLT     :   rd_data = slt_calc_data;
                    default  :   rd_data = '0;  
                endcase          
            end

            `BRANCH_OP : begin
                case (functions_data)
                    `EQ                 :   branch_logic_data = rs1_data == rs2_data ? 1'b1: 1'b0;
                    `NOT_EQ             :   branch_logic_data = rs1_data != rs2_data ? 1'b1: 1'b0;
                    `LESS               :   branch_logic_data = rs1_data <  rs2_data ? 1'b1: 1'b0;
                    `LESS_U             :   branch_logic_data = slt_calc_data[0];
                    `MORE_OR_EQ         :   branch_logic_data = rs1_data >= rs2_data ? 1'b1: 1'b0;
                    `MORE_OR_EQ_U       :   branch_logic_data = ~slt_calc_data[0];
                    default             :   branch_logic_data = 1'b0;
                endcase
            end

            `LOAD_OP : begin
                ram_address = {rs2_data[11:0], 5'b0};
                case (functions_data)
                    `LB  : rd_data = {24'b0, ram_data[7:0]};
                    `LH  : rd_data = {16'b0, ram_data[15:0]};
                    `LW  : rd_data = ram_data;
                    `LBU : rd_data = {24{ram_data[7]},  ram_data[7:0]};
                    `LHU : rd_data = {16{ram_data[15]}, ram_data[15:0]};
                endcase
            end

            `STORE_OP : begin
                ram_we = 1'b1;
                ram_address = {rs2_data[11:0], 5'b0};
                case (functions_data)
                    `SB : ram_data = {24'b0, rs1_data[7:0]};
                    `SH : ram_data = {16'b0, rs1_data[15:0]};
                    `SW : ram_data = rs1_data;
                endcase         
            end

            `LUI_OP : begin  
                rd_data = rs2_data;
            end

            `AUIPC_OP  : begin
                rd_data = rs2_data;
            end

            `JAL_OP : begin
                rd_data = rs2_data;
            end

            `JALR_OP : begin
                rd_data = rs2_data;
            end
        endcase
    end

endmodule