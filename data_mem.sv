module data_mem #(
  parameter integer WORDS = 256
) (
  input  logic        clk,
  input  logic        mem_read,
  input  logic        mem_write,
  input  logic [31:0] address,
  input  logic [31:0] write_data,
  output logic [31:0] read_data
);
  logic [31:0] mem [0:WORDS-1];
  logic valid_address;

  always_comb begin
    valid_address = (address[1:0] == 0) && ((address >> 2) < WORDS);
    if (mem_read && valid_address) read_data = mem[address[31:2]];
    else read_data = 0;
  end

  always_ff @(posedge clk) begin
    if (mem_write && valid_address)
      mem[address[31:2]] <= write_data;
  end
endmodule
