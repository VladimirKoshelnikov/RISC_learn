/*
 * schoolRISCV - small RISC-V CPU 
 *
 * originally based on Sarah L. Harris MIPS CPU 
 *                   & schoolMIPS project
 * 
 * Copyright(c) 2017-2020 Stanislav Zhelnio 
 *                        Aleksandr Romanov 
 */ 

module rom
#(
    parameter FW_LENGTH = 8,
    parameter FW_PATH   = "src/firmware/program.hex",
    parameter COUNTER_WIDTH = 12,
    parameter INSTRUCTON_WIDTH = 32
)
(
    input  [COUNTER_WIDTH - 1 : 0] cmd_address_current,
    output [INSTRUCTON_WIDTH - 1 : 0] current_instruction
);
    reg [INSTRUCTON_WIDTH - 1:0] rom [FW_LENGTH - 1:0];
    assign current_instruction = rom [cmd_address_current>>2];

    initial begin
        $readmemh (FW_PATH, rom);
    end

endmodule