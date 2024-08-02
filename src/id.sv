module id #(
    parameter INSTRUCTON_WIDTH = 32
) (
    
    input   bit [INSTRUCTON_WIDTH -1 : 0] input_instruction,

    output  bit [6 : 0]     opcode,
    output  bit [4 : 0]     rd,
    output  bit [4 : 0]     rs1,
    output  bit [4 : 0]     rs2,
    output  bit [2 : 0]     funct3,
    output  bit [31 : 0]    imm,
    output  bit [6 : 0]     funct7,

    output  bit             alu_reg_reg_op,
    output  bit             alu_reg_con_op,
    output  bit             alu_branch_op

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
    
    assign  opcode   = input_instruction[6:0];
    assign  alu_reg_reg_op = input_instruction[6:0] == 7'b0110011;
    assign  alu_reg_con_op = input_instruction[6:0] == 7'b0010011;
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
                  rd      = input_instruction[11 : 7];
                  funct3  = input_instruction[14 : 12];
                  rs1     = input_instruction[19 : 15];
                  rs2     = input_instruction[24 : 20];
                  imm     = '0;
                  funct7  = input_instruction[31 : 25];
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
                  rd      = input_instruction[11 : 7];
                  funct3  = input_instruction[14 : 12];
                  rs1     = input_instruction[19 : 15];
                  rs2     = '0;
                  imm     = {20'b0, input_instruction[31 : 20]};
                  funct7  = '0;
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
                  rd      = '0;
                  funct3  = input_instruction[14 : 12];
                  rs1     = input_instruction[19 : 15];
                  rs2     = input_instruction[24 : 20];
                  imm     = {20'b0, input_instruction[31 : 25], input_instruction[11 : 7]};
                  funct7  = '0;
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
                  rd      = '0;
                  funct3  = input_instruction[14 : 12];
                  rs1     = input_instruction[19 : 15];
                  rs2     = input_instruction[24 : 20];
                  imm     = { 19'b0,
                                input_instruction[31], 
                                input_instruction[7],
                                input_instruction[30 : 25], 
                                input_instruction[11 : 8], 
                                1'b0};
                  funct7  = '0;
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
                  rd      = input_instruction[11 : 7];
                  funct3  = '0;
                  rs1     = '0;
                  rs2     = '0;
                  imm     = {input_instruction[31 : 12], 12'b0};
                  funct7  = '0;
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
                  rd      = input_instruction[11 : 7];
                  funct3  = '0;
                  rs1     = '0;
                  rs2     = '0;
                  imm     = { 10'b0,
                                input_instruction[31], 
                                input_instruction[19 : 12], 
                                input_instruction[20], 
                                input_instruction[30 : 21], 
                                1'b0};
                  funct7  = '0;
            end
        endcase
    end
    
endmodule