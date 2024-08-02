module cpu #( parameter CPU_WIDTH ) ();

    localparam COUNTER_WIDTH = CPU_WIDTH;
    localparam DATA_WIDTH = CPU_WIDTH;
    localparam INSTRUCTON_WIDTH = CPU_WIDTH;
    localparam DATA_WIDTH = CPU_WIDTH;
    
    localparam CMD_WIDTH = 32'h4;
    localparam START_ADDRESS = 32'h0;

    localparam ROM_SIZE = 64;
    
    localparam REGISTER_ADDRESS_WIDTH = 5;
    localparam REGISTER_ADDRESS_DEPTH = 32;

    alu alu (.*);
    id instruction_decoder(.*);
    mux_bus_2_1 #(.BUS_WIDTH(32)) mux_bus_32b_2_1 (.*);
    pc program_counter(.*);
    rf register_file (.*);
    rom rom(.*);


endmodule