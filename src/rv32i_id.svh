    // Opcodes operation
    `define REG_TO_REG_OP   7'b0110011
    `define REG_TO_IMM_OP   7'b0010011
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

    `define LUI   10'b0000000000
    `define AUIPC 10'b0000000000
    `define JAL   10'b0000000000
    `define JALR  10'b0000000000


    `define BOTH_POSITIVE    2'b00
    `define RS1_POS_RS2_NEG  2'b01
    `define RS1_NEG_RS2_POS  2'b10
    `define BOTH_NEGATIVE    2'b11