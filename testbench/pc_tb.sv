module pc_tb();
    
    bit clk;
    bit a_reset_n;
    bit [31:0] cmd_address;

    pc dut (.clk(clk), .a_reset_n(a_reset_n), .cmd_address(cmd_address));

    initial begin
        clk = 0;
        forever begin
            #0.5; clk = ~clk;
        end
    end


    initial begin
        #5;
        a_reset_n = 1'b0;
        #1;
        a_reset_n = 1'b1;
        #50;
        $stop();
    end

    initial begin
        $monitor("clk: %1b; a_reset_n: %1b, cmd_address %32h",clk, a_reset_n, cmd_address);
    end
endmodule