module ram
#(
    parameter RAM_BLOCK_DEPTH   = 17,
    parameter DATA_WIDTH        = 32,
)
(
    input bit   [RAM_BLOCK_DEPTH - 1 :0] ram_address,
    input bit   we,
    input bit   clk,
    inout logic [DATA_WIDTH - 1:0] data
);
    bit [DATA_WIDTH - 1:0] ram [RAM_BLOCK_DEPTH - 1:0];

    assign data = we ? 32'bz : ram [ram_address];

    always_ff @(posedge clk) begin
        if (we) begin
            ram [ram_address] <= data;
        end
    end

endmodule