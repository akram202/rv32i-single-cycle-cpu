module alu_decoder (
  input  logic [1:0] alu_op,
  input  logic [2:0] funct3,
  input  logic       funct7_bit5,
  output logic [3:0] alu_control
);
  // ALUOp: 00=ADD adresse/immédiat, 01=SUB branchement, 10=R-type.
  always_comb begin
    case (alu_op)
      2'b00: alu_control = 4'b0000;
      2'b01: alu_control = 4'b0001;
      2'b10: begin
        case (funct3)
          3'b000: begin
            if (funct7_bit5) alu_control = 4'b0001; // SUB
            else alu_control = 4'b0000;             // ADD
          end
          3'b111: alu_control = 4'b0010; // AND
          3'b110: alu_control = 4'b0011; // OR
          3'b010: alu_control = 4'b0100; // SLT
          default: alu_control = 4'b0000;
        endcase
      end
      default: alu_control = 4'b0000;
    endcase
  end
endmodule
