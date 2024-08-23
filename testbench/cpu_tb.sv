module cpu_tb();
    parameter CPU_WIDTH = 32;
    parameter RAM_WIDTH = 31;  
    parameter FW_LENGTH = 28;  
    parameter COUNTER_WIDTH = 12;  
    parameter FW_PATH   = "src/firmware/hex/BRANCHES.hex";
    
    bit clk;
    bit a_reset_n;

    cpu #(
        .CPU_WIDTH(CPU_WIDTH),
        .RAM_WIDTH(RAM_WIDTH),
        .FW_LENGTH(FW_LENGTH),
        .FW_PATH(FW_PATH),
        .COUNTER_WIDTH(COUNTER_WIDTH)
    ) 
    RISC_V_CPU
    (   
        .clk(clk), 
        .a_reset_n(a_reset_n)
        );

    task ResetCPU ();
        a_reset_n = 1'b0;
        #1;
        a_reset_n = 1'b1;
    endtask

    initial begin
        clk = 0;
        forever begin
            #0.5; clk = ~clk;
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

    initial begin
        fork
            Watchdog(10000);
            ResetCPU();
        join
    end

    initial begin
        $dumpfile ("result_vcd/BRANCHES.vcd");
        $dumpvars();
    end
    


endmodule
