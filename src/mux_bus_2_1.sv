module mux_bus_2_1 #(
    parameter BUS_WIDTH = 32
) (
    input bit[BUS_WIDTH - 1 : 0] in_a,
    input bit[BUS_WIDTH - 1 : 0] in_b,
    input bit s,
    output bit[BUS_WIDTH - 1 : 0] out
);
    assign out = s ? in_b : in_a;
endmodule