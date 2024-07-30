module pc #(
    parameter COUNTER_WIDTH = 32,
    parameter CMD_WIDTH = 32'h4,
    parameter START_ADDRESS = 32'h0
) (
    input   bit clk,
    input   bit a_reset_n,
    output  bit [COUNTER_WIDTH -1 : 0] cmd_address
);

    always_ff @(posedge clk, negedge a_reset_n) begin
        cmd_address <= ~a_reset_n ? START_ADDRESS : cmd_address + CMD_WIDTH;
    end

endmodule