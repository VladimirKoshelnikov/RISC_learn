module alu_tb();
      
    parameter  DATA_WIDTH = 8;

    bit [9:0] alu_opcodes [string];

    initial begin
        alu_opcodes = '{  
            "ALU_ADD"           : 10'b0000000000, 
            "ALU_SUB"           : 10'b0100000000,  
            "ALU_XOR"           : 10'b0000000100,   
            "ALU_OR"            : 10'b0000000110,  
            "ALU_AND"           : 10'b0000000111,   
            "ALU_SLL"           : 10'b0000000001,   
            "ALU_SRL"           : 10'b0000000101,   
            "ALU_SRA"           : 10'b0100000101,   
            "ALU_SLT"           : 10'b0000000010,   
            "ALU_SLTU"          : 10'b0000000011,
            "ALU_EQ"            : 10'b1000000100,
            "ALU_NOT_EQ"        : 10'b1000000110,
            "ALU_LESS"          : 10'b1000000111,
            "ALU_LESS_U"        : 10'b1000000001,
            "ALU_MORE_OR_EQ"    : 10'b1000000101,
            "ALU_MORE_OR_EQ_U"  : 10'b1100000101 } ;
    end
    
    bit [DATA_WIDTH - 1:0] rs1_data;
    bit [DATA_WIDTH - 1:0] rs2_data;

    bit [DATA_WIDTH - 1:0] rd_data;
    bit logic_data;

    bit [2:0] func3;
    bit [6:0] func7;


    bit clk;
   
    alu #(.DATA_WIDTH(DATA_WIDTH)) dut (.*);

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
    endtask //


    task getEveryALUCode();
        foreach (alu_opcodes[name]) begin
            func3 <= alu_opcodes[name][2:0];
            func7 <= alu_opcodes[name][9:3];
            @(posedge clk);
            $display("time: %0t; ALU_Operation: %20s rs1_data: %8b; rs2_data: %8b; out_rd: %8b; out_logic: %1b;", $time, name, rs1_data, rs2_data, rd_data, logic_data);
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
            getEveryALUCode();
        end
    endtask 



    initial begin
        fork
            Watchdog(10000);
            TestScenario();
        join
    end

    
endmodule