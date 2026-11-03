module pc_adder (
  input  logic [31:0] pc,
  input  logic [31:0] imm_ext,
  output logic [31:0] pc_plus4,
  output logic [31:0] pc_target
);
  always_comb begin
    pc_plus4 = pc + 4;
    pc_target = pc + imm_ext;
  end
endmodule
