module ram
#(
    parameter  RAM_WIDTH    = 31,
    parameter DATA_WIDTH    = 32
)
(
    input bit   [RAM_WIDTH - 1 :0] address,
    input bit   we,
    input bit   clk,
    inout logic [DATA_WIDTH - 1:0] data
);

    localparam RAM_SIZE      = {{(RAM_WIDTH){1'b1}}};
    bit [DATA_WIDTH - 1:0] memory [RAM_SIZE - 1:0];

    assign data = we ? 32'bz : memory [address];
    assign mem_check = memory [address];

    always_ff @(posedge clk) begin
        if (we) begin
            memory [address] <= data;
        end
    end

endmodule