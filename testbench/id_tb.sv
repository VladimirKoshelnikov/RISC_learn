module id_tb();
    parameter INSTRUCTON_WIDTH = 32;
    
    bit [INSTRUCTON_WIDTH -1 : 0] input_instruction;
    bit [6 : 0]      opcode;
    bit [4 : 0]      rd;
    bit [4 : 0]      rs1;
    bit [4 : 0]      rs2;
    bit [2 : 0]      func3;
    bit [31 : 0]     imm;
    bit [6 : 0]      func7;

    id dut(.*);
    
    bit clk;

    initial begin
        clk = 0;
        forever begin
            #1; clk = ~clk;
        end
    end

    string op_type_decoder [bit [6:0]];

    initial begin
        op_type_decoder = '{
            7'b0110011 : "R-Type",
            7'b0010011 : "I-Type",
            7'b0000011 : "I-Type",
            7'b0100011 : "S-Type",
            7'b1100011 : "B-Type",
            7'b1101111 : "J-Type",
            7'b1100111 : "I-Type",
            7'b0010111 : "U-Type",
            7'b0110111 : "U-Type",
            7'b1110011 : "I-Type",
            7'b0101111 : "R-Type"
        };
    end

    initial begin
        forever begin
            @(posedge clk);
            $display("time: %0t; input_instruction: %32b op_type: %6s;  rd: %5b;  rs1: %5b;  rs2: %5b;  func3: %3b   imm: %32b   func7: %7b", $time, input_instruction, op_type_decoder[ opcode],  rd,  rs1,  rs2,  func3,  imm, func7);
            std::randomize (input_instruction) with { 
                input_instruction[6:0] == 7'b0110011 |
                input_instruction[6:0] == 7'b0010011 |
                input_instruction[6:0] == 7'b0000011 |
                input_instruction[6:0] == 7'b0100011 |
                input_instruction[6:0] == 7'b1100011 |
                input_instruction[6:0] == 7'b1101111 |
                input_instruction[6:0] == 7'b1100111 |
                input_instruction[6:0] == 7'b0010111 |
                input_instruction[6:0] == 7'b0110111 |
                input_instruction[6:0] == 7'b1110011 |
                input_instruction[6:0] == 7'b0101111;};
        end
    end

    task Watchdog(int stop_tick);
        $display("Start test:");
        for (int i = 0; i < stop_tick; i = i + 1) begin
            @(posedge clk);
        end
        $display("Test Finished by Wachdog timer");
        $stop();
    endtask 


    task TestScenario();
        Watchdog(100);
    endtask


    initial begin
        TestScenario();
    end


endmodule
