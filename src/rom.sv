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
    parameter ROM_SIZE = 8
)
(
    input  [31:0] cmd_address_current,
    output [31:0] current_instruction
);
    reg [31:0] rom [ROM_SIZE - 1:0];
    assign current_instruction = rom [cmd_address_current>>2];

    initial begin
        $readmemh ("src/program.hex", rom);
    end

endmodule