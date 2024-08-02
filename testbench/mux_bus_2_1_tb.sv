module mux_bus_2_1_tb();
    parameter BUS_WIDTH = 32;
    bit[BUS_WIDTH - 1 : 0] in_a;
    bit[BUS_WIDTH - 1 : 0] in_b;
    bit s;
    bit[BUS_WIDTH - 1 : 0] out;


    bit clk;
   
    mux_bus_2_1 dut (.*);

    initial begin
        clk = 0;
        forever begin
            #1; clk = ~clk;
        end
    end


    initial begin
        forever begin
            @(posedge clk);
            s       <= $urandom();
            in_a    <= $urandom();
            in_b    <= $urandom();
            $display("time: %0t; s: %1b in_a: %15d; in_b: %15d; out: %15d; ", $time, s, in_a, in_b, out);
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
        Watchdog(10000);
    endtask


    initial begin
        TestScenario();
    end

    
endmodule