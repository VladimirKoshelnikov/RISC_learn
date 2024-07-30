`timescale 1ps/1ps
module pc_tb();
    
    bit clk;
    bit a_reset_n;
    bit [31 : 0] cmd_address_next;
    bit [31 : 0] cmd_address_current;

    pc dut (.clk(clk), .a_reset_n(a_reset_n), .cmd_address_next(cmd_address_next), .cmd_address_current(cmd_address_current));

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
        #1;
        cmd_address_next = 4;
        #2;     cmd_address_next = 8;
        #2;     cmd_address_next = 12;
        #2;     cmd_address_next = 16;
        #2;     cmd_address_next = 20;
        #2;     cmd_address_next = 24;
        a_reset_n = 1'b0;
        #10;
        $stop();
    end

    initial begin
        $monitor("time: %0d; clk: %1b; a_reset_n: %1b, cmd_address_next %32h, cmd_address_current: %32h",$time(), clk, a_reset_n, cmd_address_next, cmd_address_current);
    end
endmodule