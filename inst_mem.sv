module inst_mem #(
  parameter integer WORDS = 256,
  parameter INIT_FILE = "program.hex"
) (
  input  logic [31:0] address,
  output logic [31:0] instruction
);
  logic [31:0] mem [0:WORDS-1];
  integer i;

  initial begin
    for (i = 0; i < WORDS; i = i + 1)
      mem[i] = 32'h00000013; // NOP: addi x0,x0,0
    if (INIT_FILE != "") $readmemh(INIT_FILE, mem);
  end

  always_comb begin
    if (address[1:0] == 0 && (address >> 2) < WORDS)
      instruction = mem[address[31:2]];
    else
      instruction = 32'h00000013;
  end
endmodule
