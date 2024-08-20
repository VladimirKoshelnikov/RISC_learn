module ram
#(
    parameter  RAM_WIDTH    = 31,
    parameter DATA_WIDTH    = 32
 // 2 ^ 32 - 1
)
(
    input bit   [RAM_WIDTH - 1 :0] ram_address,
    input bit   we,
    input bit   clk,
    inout logic [DATA_WIDTH - 1:0] data,
    output bit  [DATA_WIDTH - 1:0] mem_check
);

    localparam RAM_SIZE      = {{(RAM_WIDTH){1'b1}}};
    bit [DATA_WIDTH - 1:0] memory [RAM_SIZE - 1:0];

    assign data = we ? 32'bz : memory [ram_address];
    assign mem_check = memory [ram_address];

    always_ff @(posedge clk) begin
        if (we) begin
            memory [ram_address] <= data;
        end
    end

endmodule