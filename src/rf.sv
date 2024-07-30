module rf #(
    parameter REGISTER_ADDRESS_WIDTH = 5,
    parameter ADDRESS_DEPTH = 32,
    parameter DATA_WIDTH = 32
) (
    input   bit clk,
    input   bit a_reset_n,

    input   bit we,

    input   bit [REGISTER_ADDRESS_WIDTH - 1 : 0] address1,
    input   bit [REGISTER_ADDRESS_WIDTH - 1 : 0] address2,
    input   bit [REGISTER_ADDRESS_WIDTH - 1 : 0] address3,

    output  bit [DATA_WIDTH - 1 : 0] read_data_1,
    output  bit [DATA_WIDTH - 1 : 0] read_data_2,
    
    input  bit [DATA_WIDTH - 1 : 0] write_data
);

    bit [ADDRESS_DEPTH - 1 : 0] [DATA_WIDTH - 1: 0] RAM ;   /*block ram*/

    always_ff @(posedge clk, negedge a_reset_n) begin
        if (~a_reset_n)  begin
            RAM <= 'b0;
        end
        else begin
            read_data_1 <= RAM[address1];
            read_data_2 <= RAM[address2];
            if (we & address3 != 0 ) RAM[address3] <= write_data;
        end 
    end

endmodule