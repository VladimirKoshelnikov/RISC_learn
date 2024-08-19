module rf #(
    parameter REGISTER_ADDRESS_WIDTH    = 5,
    parameter REGISTER_ADDRESS_DEPTH    = 32,
    parameter DATA_WIDTH                = 32
) (
    input   bit clk,
    input   bit a_reset_n,

    input   bit we,

    input   bit [REGISTER_ADDRESS_WIDTH - 1 : 0] address1,
    input   bit [REGISTER_ADDRESS_WIDTH - 1 : 0] address2,
    input   bit [REGISTER_ADDRESS_WIDTH - 1 : 0] address3,

    output  bit [DATA_WIDTH - 1 : 0] read_data_1,
    output  bit [DATA_WIDTH - 1 : 0] read_data_2,
    
    input   bit [DATA_WIDTH - 1 : 0] write_data
);

    bit [REGISTER_ADDRESS_DEPTH - 1 : 0] [DATA_WIDTH - 1: 0] RF_DATA ;   /*block ram*/

    always_ff @(posedge clk, negedge a_reset_n) begin
        if (~a_reset_n)  begin
            RF_DATA <= 'b0;
        end
        else begin
            read_data_1 <= RF_DATA[address1];
            read_data_2 <= RF_DATA[address2];
            if (we & address3 != 0 ) RF_DATA[address3] <= write_data;
        end 
    end

endmodule