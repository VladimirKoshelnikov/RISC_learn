module rf_tb();
    parameter REGISTER_ADDRESS_WIDTH = 5;
    parameter DATA_WIDTH = 32;


    bit clk;
    bit a_reset_n;
    bit we;
    bit [REGISTER_ADDRESS_WIDTH - 1 : 0] address1;
    bit [REGISTER_ADDRESS_WIDTH - 1 : 0] address2;
    bit [REGISTER_ADDRESS_WIDTH - 1 : 0] address3;
    bit [DATA_WIDTH - 1 : 0] read_data_1;
    bit [DATA_WIDTH - 1 : 0] read_data_2;
    bit [DATA_WIDTH - 1 : 0] write_data;


    rf dut (.*);

    initial begin
        clk = 0;
        forever begin
            #1; clk = ~clk;
        end
    end


    initial begin
        a_reset_n = 1'b0;
        #1;
        a_reset_n = 1'b1;
        
    end

    task FillMemory();

        $display("Start write memory:");
        we = 1;
        for (address3 = 0; address3 < 31 ; address3 = address3 + 1) begin
            write_data = $urandom();
            @(posedge clk);
            $display("time: %0t; Address: %5b; Data: %8h", $time, address3, write_data);
        end
        we = 0;
    endtask 


    task ReadMemory1();
        $display("Start read memory RD1 :");
        for (address1 = 0; address1 < 31 ; address1 = address1 + 1) begin
            @(negedge clk);
            $display("time: %0t; Address1: %5b; RD1: : %8h", $time, address1, read_data_1);
        end
    endtask 

    task ReadMemory2();
        $display("Start read memory RD2 :");
        for (address2 = 0; address2 < 31 ; address2 = address2 + 1) begin
            @(negedge clk);
            $display("time: %0t; Address2: %5b; RD2: : %8h", $time, address2, read_data_2);
        end
    endtask 

    task TestScenario();
        $display("");
        $display("************************************************************");
        $display("");
        FillMemory();
        $display("");
        $display("************************************************************");
        $display("");
        ReadMemory1();
        $display("************************************************************");
        $display("");
        ReadMemory2();
    endtask


    initial begin
        @(posedge a_reset_n);
        TestScenario();
    end

    
endmodule