module cpu #( parameter CPU_WIDTH ) (   
    input bit clk, 
    input bit a_reset_n);
    
    localparam CMD_WIDTH        = 32'h4;
    localparam START_ADDRESS    = 32'h0;

    localparam COUNTER_WIDTH    = CPU_WIDTH;
    localparam DATA_WIDTH       = CPU_WIDTH;
    localparam INSTRUCTON_WIDTH = CPU_WIDTH;
    

    localparam ROM_SIZE = 64;
    
    localparam REGISTER_ADDRESS_WIDTH = 5;
    localparam REGISTER_ADDRESS_DEPTH = 32;

    // *************************************************************
    // Program counter declaring
    // *************************************************************
    
    bit [COUNTER_WIDTH -1 : 0] cmd_address_next;
    bit [COUNTER_WIDTH -1 : 0] cmd_address_current;
    
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

    bit [31:0] current_instruction; 

    rom rom(
        .cmd_address_current(cmd_address_current),
        .current_instruction(current_instruction));
        
    // *************************************************************
    // Instruction decoder declaring
    // *************************************************************

    bit [6 : 0]     opcode;
    bit [4 : 0]     rd;
    bit [4 : 0]     rs1;
    bit [4 : 0]     rs2;
    bit [2 : 0]     func3;
    bit [31 : 0]    imm;
    bit [6 : 0]     func7;

    bit R_type;
    bit I_type;
    bit S_type;
    bit B_type;
    bit U_type;
    bit J_type;

    bit 

    id #( .INSTRUCTON_WIDTH(INSTRUCTON_WIDTH)
        ) instruction_decoder(
            .input_instruction(current_instruction),

            .opcode(opcode),
            .rd(rd),
            .rs1(rs1),
            .rs2(rs2),
            .func3(func3),
            .imm(imm),
            .func7(func7)
            .R_type(R_type)
            .I_type(I_type)
            .S_type(S_type)
            .B_type(B_type)
            .U_type(U_type)
            .J_type(J_type)
            );

        
    // *************************************************************
    // Register File declaring
    // *************************************************************

    bit[DATA_WIDTH - 1 : 0] alu_rd_data;

    rf #(
        .REGISTER_ADDRESS_WIDTH(REGISTER_ADDRESS_WIDTH),
        .REGISTER_ADDRESS_DEPTH(REGISTER_ADDRESS_DEPTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) register_file (
        
        .clk(clk),
        .a_reset_n(a_reset_n),

        .we(alu_reg_file_op),
        .address1(rs1),
        .address2(rs2),
        .address3(rd),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),

        .write_data(alu_rd_data)
    );

    // *************************************************************
    // RAM declaring
    // *************************************************************

    bit [RAM_BLOCK_DEPTH - 1 :0] ram_address;
    bit ram_we;
    logic [DATA_WIDTH - 1:0] ram_data

    ram #(
        .RAM_BLOCK_DEPTH(17),
        .DATA_WIDTH(DATA_WIDTH)
    ) ram (
        .clk(clk)
        .ram_address(ram_address),
        .we(ram_we),
        .data(ram_data)
    );

    // *************************************************************
    // ALU declaring
    // *************************************************************

    bit[DATA_WIDTH - 1 : 0] alu_rs2_data;
    bit alu_logic_data;

    mux_bus_2_1 #(.BUS_WIDTH(DATA_WIDTH)) mux_bus_data_32b_2_1 (
        .in_a(read_data_2),
        .in_b(imm),
        .s(I_type),
        .out(alu_rs2_data)
    );
    
    alu #(
        .DATA_WIDTH(DATA_WIDTH)
        ) alu (
        .func3(func3),
        .func7(func7),
        .opcode(opcode),
        .rs1_data(read_data_1),
        .rs2_data(alu_rs2_data),
        .rd_data(alu_rd_data),
        .branch_logic_data(branch_logic_data)
        );


endmodule