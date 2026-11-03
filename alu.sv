module alu (
  input  logic [31:0] a,
  input  logic [31:0] b,
  input  logic [3:0]  alu_control,
  output logic [31:0] result,
  output logic        zero
);
  // Codes: 0000 ADD, 0001 SUB, 0010 AND, 0011 OR, 0100 SLT
  always_comb begin
    case (alu_control)
      4'b0000: result = a + b;
      4'b0001: result = a - b;
      4'b0010: result = a & b;
      4'b0011: result = a | b;
      4'b0100: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
      default: result = 32'd0;
    endcase
    zero = (result == 0);
  end
endmodule
