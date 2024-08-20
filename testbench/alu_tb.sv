module alu_tb();
      
    parameter  DATA_WIDTH = 32;
    parameter  RAM_WIDTH  = 31;

    bit [6:0] opcodes [string];
    bit [9:0] functions [string][string];

    initial begin
        opcodes =   '{
            "REG_TO_REG_OP"  : 7'b0010011,
            "REG_TO_IMM_OP"  : 7'b0110011,
            "BRANCH_OP"      : 7'b1100011,
            "ZLOAD_OP"       : 7'b0000011,
            "STORE_OP"       : 7'b0100011,
            "LUI_OP"         : 7'b0110111,
            "AUIPC_OP"       : 7'b0010111,
            "JAL_OP"         : 7'b1101111,
            "JALR_OP"        : 7'b1100111
        };

        functions = '{  
            "REG_TO_REG_OP" : '{            
                "ADD"  : 10'b0000000000,
                "SUB"  : 10'b0100000000,
                "XOR"  : 10'b0000000100,
                "OR"   : 10'b0000000110,
                "AND"  : 10'b0000000111,
                "SLL"  : 10'b0000000001,
                "SRL"  : 10'b0000000101,
                "SRA"  : 10'b0100000101,
                "SLT"  : 10'b0000000010,
                "SLTU" : 10'b0000000011
                },

            "REG_TO_IMM_OP" :{
                "ADD"  : 10'b0000000000,
                "SUB"  : 10'b0100000000,
                "XOR"  : 10'b0000000100,
                "OR"   : 10'b0000000110,
                "AND"  : 10'b0000000111,
                "SLL"  : 10'b0000000001,
                "SRL"  : 10'b0000000101,
                "SRA"  : 10'b0100000101,
                "SLT"  : 10'b0000000010,
                "SLTU" : 10'b0000000011
                },

            "BRANCH_OP" : {
                "BEQ"  : 10'b0000000000,
                "BNE"  : 10'b0000000001,
                "BLT"  : 10'b0000000100,
                "BLTU" : 10'b0000000101,
                "BGE"  : 10'b0000000110,
                "BGEU" : 10'b0000000111
                },

            "ZLOAD_OP"   : {
                "LB"   : 10'b0000000000,
                "LH"   : 10'b0000000001,
                "LW"   : 10'b0000000010,
                "LBU"  : 10'b0000000100,
                "LHU"  : 10'b0000000101
                },
            "STORE_OP"  : {
                "SB"   : 10'b0000000000,
                "SH"   : 10'b0000000001,
                "SW"   : 10'b0000000010
                },

            "LUI_OP"    : {
                "LUI"        : 10'b0000000000
                },
            "AUIPC_OP"  : {
                "AUIPC"      : 10'b0000000000
                },
            "JAL_OP"    : {
                "JAL"        : 10'b0000000000
                },
            "JALR_OP"   : {
                "JALR"       : 10'b0000000000
                }

 } ;
    end
    bit [2:0] func3;
    bit [6:0] func7;
    bit [6:0] opcode;

    bit [DATA_WIDTH - 1:0]      rs1_data;
    bit [DATA_WIDTH - 1:0]      rs2_data;
    bit [DATA_WIDTH - 1:0]      rd_data;    
    bit                         rf_we;

    bit [DATA_WIDTH - 1:0]      imm;

    wire [DATA_WIDTH - 1:0]     ram_data;
    bit                         ram_we;
    bit [RAM_WIDTH-1:0]         ram_address;
    bit [DATA_WIDTH-1:0]        mem_check;

    bit [DATA_WIDTH - 1:0]   pc_current_address;
    bit [DATA_WIDTH - 1:0]   pc_next_address;

    bit clk;
   
    alu #(.DATA_WIDTH(DATA_WIDTH)) dut (.*);

    ram # ( .RAM_WIDTH (RAM_WIDTH),
            .DATA_WIDTH(DATA_WIDTH)) ram (
                .ram_address(ram_address),
                .we(ram_we),
                .clk(clk),
                .data(ram_data)
            );
    initial begin
        clk = 0;
        forever begin
            #0.5; clk = ~clk;
        end
    end



    task getRandomData();
        @(posedge clk);
        $display();
        rs1_data    <= $urandom();
        rs2_data    <= $urandom();
        imm         <= $urandom();
    endtask //

    task getEveryCommand();
        foreach (functions[opcode_name]) begin
            opcode = opcodes[opcode_name];
            $display();
            $display("opcode name: %s; opcode value: %7b", opcode_name, opcode);
            getEveryFunction(opcode_name);
        end 
    endtask 

    task getEveryFunction(string opcode_name);
        foreach (functions[opcode_name][name]) begin
            func3 <= functions[opcode_name][name][2:0];
            func7 <= functions[opcode_name][name][9:3];
            @(posedge clk);
            $display("time: %0t; ALU_Operation: %5s rs1_data: %8h; rs2_data: %8h; imm: %8h; out_rd: %8h; rf_we: %1b; ram_data: %8h; ram_we: %1b; ram_address: %8h; pc_current_address: %8h; pc_next_address:%8h", $time, name, rs1_data, rs2_data, imm, rd_data, rf_we, ram_data, ram_we, ram_address, pc_current_address, pc_next_address);
        end 
    endtask //

    task Watchdog(int stop_tick);
        $display("Start test:");
        for (int i = 0; i < stop_tick; i = i + 1) begin
            @(posedge clk);
        end
        $display("Test Finished by Wachdog timer");
        $stop();
    endtask 

    task TestScenario();
        forever begin
            getRandomData();
            getEveryCommand();
        end
    endtask 



    initial begin
        fork
            Watchdog(10000);
            TestScenario();
        join
    end

    initial begin
        
        $dumpfile("alu.vcd");
        $dumpvars();
    end
endmodule