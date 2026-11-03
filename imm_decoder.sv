module imm_decoder (
  input  logic [31:0] instruction,
  output logic [31:0] immediate
);
  always_comb begin
    case (instruction[6:0])
      7'b0100011: // S-type: SW
        immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
      7'b1100011: // B-type: BEQ
        immediate = {{19{instruction[31]}}, instruction[31], instruction[7],
                     instruction[30:25], instruction[11:8], 1'b0};
      7'b1101111: // J-type: JAL
        immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12],
                     instruction[20], instruction[30:21], 1'b0};
      default: // I-type: ADDI, LW
        immediate = {{20{instruction[31]}}, instruction[31:20]};
    endcase
  end
endmodule
