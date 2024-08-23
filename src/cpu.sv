module cpu #(   parameter CPU_WIDTH = 32, 
                parameter RAM_WIDTH = 31,
                parameter FW_LENGTH = 8,
                parameter FW_PATH   = "src/firmware/program.hex",
                parameter COUNTER_WIDTH = 12) (   
    input bit clk, 
    input bit a_reset_n);
    
    localparam CMD_WIDTH        = 32'h4;
    localparam START_ADDRESS    = 32'h0;

    localparam DATA_WIDTH       = CPU_WIDTH;
    localparam INSTRUCTON_WIDTH = CPU_WIDTH;

    localparam ROM_SIZE = 64;
    
    localparam REGISTER_ADDRESS_WIDTH = 5;
    localparam REGISTER_ADDRESS_DEPTH = 32;


    bit [COUNTER_WIDTH -1 : 0] cmd_address_next;
    bit [COUNTER_WIDTH -1 : 0] cmd_address_current;

    bit [CPU_WIDTH - 1:0] current_instruction; 

    bit [RAM_WIDTH - 1 :0]          ram_address;
    bit                             ram_we;
    wire [DATA_WIDTH - 1:0]         ram_data;


    bit [6 : 0]     id_opcode;
    bit [4 : 0]     id_rd;
    bit [4 : 0]     id_rs1;
    bit [4 : 0]     id_rs2;
    bit [2 : 0]     id_func3;
    bit [31 : 0]    id_imm;
    bit [6 : 0]     id_func7;


    bit[DATA_WIDTH - 1 : 0] rf_rd_data;
    bit[DATA_WIDTH - 1 : 0] rf_rs1_data;
    bit[DATA_WIDTH - 1 : 0] rf_rs2_data;
    bit[DATA_WIDTH - 1 : 0] rf_we;

    // *************************************************************
    // Program counter declaring
    // *************************************************************
    
    pc #(.COUNTER_WIDTH(COUNTER_WIDTH), 
         .CMD_WIDTH(CMD_WIDTH),
         .START_ADDRESS(START_ADDRESS)) 
        program_counter (
            .cmd_address_next(cmd_address_next),
            .cmd_address_current(cmd_address_current),
            .clk(clk),
            .a_reset_n(a_reset_n));
    
    // *************************************************************
    // ROM declaring
    // *************************************************************

    rom #(
        .FW_LENGTH(FW_LENGTH),
        .FW_PATH(FW_PATH),
        .COUNTER_WIDTH(COUNTER_WIDTH),
        .INSTRUCTON_WIDTH(INSTRUCTON_WIDTH)
        ) rom(
        .cmd_address_current(cmd_address_current),
        .current_instruction(current_instruction));
        
    // *************************************************************
    // Instruction decoder declaring
    // *************************************************************

    id #( .INSTRUCTON_WIDTH(INSTRUCTON_WIDTH)
        ) instruction_decoder(
            .input_instruction(current_instruction),

            .opcode(id_opcode),
            .rd(id_rd),
            .rs1(id_rs1),
            .rs2(id_rs2),
            .func3(id_func3),
            .imm(id_imm),
            .func7(id_func7)
            );

        
    // *************************************************************
    // Register File declaring
    // *************************************************************

    rf #(
        .REGISTER_ADDRESS_WIDTH(REGISTER_ADDRESS_WIDTH),
        .REGISTER_ADDRESS_DEPTH(REGISTER_ADDRESS_DEPTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) register_file (
        
        .clk(clk),
        .a_reset_n(a_reset_n),

        .we(rf_we),
        .address1(id_rs1),
        .address2(id_rs2),
        .address3(id_rd),
        .read_data_1(rf_rs1_data),
        .read_data_2(rf_rs2_data),

        .write_data(rf_rd_data)
    );

    // *************************************************************
    // RAM declaring
    // *************************************************************

    ram #(
        .RAM_WIDTH(RAM_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) ram (
        .clk(clk),
        .address(ram_address),
        .we(ram_we),
        .data(ram_data)
    );

    // *************************************************************
    // ALU declaring
    // *************************************************************
    
    alu #(
        .RAM_WIDTH(RAM_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .FW_LENGTH(FW_LENGTH),
        .COUNTER_WIDTH(COUNTER_WIDTH)
        ) alu (
        .clk(clk),

        .func3(id_func3),
        .func7(id_func7),
        .opcode(id_opcode),
        .imm(id_imm),

        .rs1_data(rf_rs1_data),
        .rs2_data(rf_rs2_data),
        .rd_data(rf_rd_data),
        .rf_we(rf_we),

        .ram_data(ram_data),
        .ram_address(ram_address),
        .ram_we(ram_we),

        .pc_current_address(cmd_address_current),
        .pc_next_address(cmd_address_next)
        );

endmodule