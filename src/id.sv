module id #(
    parameter INSTRUCTON_WIDTH = 32
) (
    
    input   bit [INSTRUCTON_WIDTH -1 : 0] input_instruction,

    output  bit [6 : 0]     out_opcode,
    output  bit [4 : 0]     out_rd,
    output  bit [4 : 0]     out_rs1,
    output  bit [4 : 0]     out_rs2,
    output  bit [2 : 0]     out_funct3,
    output  bit [31 : 0]    out_imm,
    output  bit [6 : 0]     out_funct7
);


    string op_type_decoder [bit [6:0]];

    initial begin
        op_type_decoder = '{
            7'b0110011 : "R-Type",
            7'b0010011 : "I-Type",
            7'b0000011 : "I-Type",
            7'b0100011 : "S-Type",
            7'b1100011 : "B-Type",
            7'b1101111 : "J-Type",
            7'b1100111 : "I-Type",
            7'b0010111 : "U-Type",
            7'b0110111 : "U-Type",
            7'b1110011 : "I-Type",
            7'b0101111 : "R-Type"
        };
    end
    
    assign out_opcode   = input_instruction[6:0];

    always_comb begin
        case (op_type_decoder[input_instruction[6:0]])
        // -----------------------------------------------------------       
        // R-Type
        // -----------------------------------------------------------
        // |                   input_instruction                     |
        // -----------------------------------------------------------
        // |31     :     25| 24:20 | 19:15 | 14 : 12 | 11:7 | 6 : 0  |
        // |    funct7     |  rs2  |  rs1  | funct3  |  rd  | opcode |
        // -----------------------------------------------------------

            "R-Type" : begin    
                out_rd      = input_instruction[11 : 7];
                out_funct3  = input_instruction[14 : 12];
                out_rs1     = input_instruction[19 : 15];
                out_rs2     = input_instruction[24 : 20];
                out_imm     = '0;
                out_funct7  = input_instruction[31 : 25];
            end

        // -----------------------------------------------------------
        // I-Type
        // -----------------------------------------------------------
        // |                   input_instruction                     |
        // -----------------------------------------------------------
        // |31         :        20 | 19:15 | 14 : 12 | 11:7 | 6 : 0  |
        // |       imm[11:0]       |  rs1  | funct3  |  rd  | opcode |
        // -----------------------------------------------------------
        
            "I-Type" : begin    
                out_rd      = input_instruction[11 : 7];
                out_funct3  = input_instruction[14 : 12];
                out_rs1     = input_instruction[19 : 15];
                out_rs2     = '0;
                out_imm     = {20'b0, input_instruction[31 : 20]};
                out_funct7  = '0;
            end
        // -----------------------------------------------------------------
        // S-Type
        // -----------------------------------------------------------------
        // |                      input_instruction                        |
        // -----------------------------------------------------------------
        // |31     :     25| 24:20 | 19:15 | 14 : 12 | 11:7       | 6 : 0  |
        // |   imm[11:5]   |  rs2  |  rs1  | funct3  |  imm[4:0]  | opcode |
        // -----------------------------------------------------------------
        
            "S-Type" : begin    
                out_rd      = '0;
                out_funct3  = input_instruction[14 : 12];
                out_rs1     = input_instruction[19 : 15];
                out_rs2     = input_instruction[24 : 20];
                out_imm     = {20'b0, input_instruction[31 : 25], input_instruction[11 : 7]};
                out_funct7  = '0;
            end
        // --------------------------------------------------------------------
        // B-Type
        // --------------------------------------------------------------------
        // |                      input_instruction                           |
        // --------------------------------------------------------------------
        // |31     :     25| 24:20 | 19:15 | 14 : 12 |     11:7      | 6 : 0  |
        // | imm[12|10:5]  |  rs2  |  rs1  | funct3  |  imm[4:1|11]  | opcode |
        // --------------------------------------------------------------------
            
            "B-Type" : begin    
                out_rd      = '0;
                out_funct3  = input_instruction[14 : 12];
                out_rs1     = input_instruction[19 : 15];
                out_rs2     = input_instruction[24 : 20];
                out_imm     = { 19'b0,
                                input_instruction[31], 
                                input_instruction[7],
                                input_instruction[30 : 25], 
                                input_instruction[11 : 8], 
                                1'b0};
                out_funct7  = '0;
            end
        // -------------------------------------------------------
        // U-Type
        // -------------------------------------------------------
        // |                 input_instruction                   |
        // -------------------------------------------------------
        // | 31 : 25 | 24:20 | 19:15 | 14 : 12 |  11:7  | 6 : 0  |
        // |             imm[31:12]            |   rd   | opcode |
        // -------------------------------------------------------
        
            "U-Type" : begin    
                out_rd      = input_instruction[11 : 7];
                out_funct3  = '0;
                out_rs1     = '0;
                out_rs2     = '0;
                out_imm     = {input_instruction[31 : 12], 12'b0};
                out_funct7  = '0;
            end
        // -------------------------------------------------------
        // J-Type    
        // -------------------------------------------------------
        // |                 input_instruction                   |
        // -------------------------------------------------------
        // | 31 : 25 | 24:20 | 19:15 | 14 : 12 |  11:7  | 6 : 0  |
        // |        imm[20|10:1|11|19:12       |   rd   | opcode |
        // -------------------------------------------------------
                "J-Type" : begin    
                out_rd      = input_instruction[11 : 7];
                out_funct3  = '0;
                out_rs1     = '0;
                out_rs2     = '0;
                out_imm     = { 10'b0,
                                input_instruction[31], 
                                input_instruction[19 : 12], 
                                input_instruction[20], 
                                input_instruction[30 : 21], 
                                1'b0};
                out_funct7  = '0;
            end
        endcase
    end
    
endmodule