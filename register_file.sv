module register_file (
  input  logic        clk,
  input  logic        reg_write,
  input  logic [4:0]  read_addr1,
  input  logic [4:0]  read_addr2,
  input  logic [4:0]  write_addr,
  input  logic [31:0] write_data,
  output logic [31:0] read_data1,
  output logic [31:0] read_data2
);
  logic [31:0] regs [0:31];

  always_comb begin
    if (read_addr1 == 0) read_data1 = 0;
    else read_data1 = regs[read_addr1];

    if (read_addr2 == 0) read_data2 = 0;
    else read_data2 = regs[read_addr2];
  end

  always_ff @(posedge clk) begin
    if (reg_write && write_addr != 0)
      regs[write_addr] <= write_data;
  end
endmodule
