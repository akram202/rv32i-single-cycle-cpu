module control_unit (
  input  logic [6:0] opcode,
  output logic       reg_write,
  output logic       alu_src,
  output logic       mem_read,
  output logic       mem_write,
  output logic [1:0] result_src,
  output logic       branch,
  output logic       jump,
  output logic [1:0] alu_op
);
  always_comb begin
    // Valeurs par défaut: aucun effet architectural.
    reg_write = 0;
    alu_src = 0;
    mem_read = 0;
    mem_write = 0;
    result_src = 2'b00;
    branch = 0;
    jump = 0;
    alu_op = 2'b00;

    case (opcode)
      7'b0110011: begin // Instructions de registre: ADD/SUB/AND/OR/SLT
        reg_write = 1;
        alu_op = 2'b10;
      end
      7'b0010011: begin // ADDI
        reg_write = 1;
        alu_src = 1;
        alu_op = 2'b00;
      end
      7'b0000011: begin // LW
        reg_write = 1;
        alu_src = 1;
        mem_read = 1;
        result_src = 2'b01;
        alu_op = 2'b00;
      end
      7'b0100011: begin // SW
        alu_src = 1;
        mem_write = 1;
        alu_op = 2'b00;
      end
      7'b1100011: begin // BEQ
        branch = 1;
        alu_op = 2'b01;
      end
      7'b1101111: begin // JAL
        reg_write = 1;
        jump = 1;
        result_src = 2'b10; // écrire PC+4 dans rd
        alu_op = 2'b00;
      end
      default: begin end
    endcase
  end
endmodule
