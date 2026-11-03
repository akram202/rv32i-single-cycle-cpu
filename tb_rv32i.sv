`timescale 1ns/1ps
module tb_rv32i;
  logic clk = 0;
  logic reset = 1;
  logic [31:0] pc_debug, instr_debug, alu_result_debug;
  logic regwrite_debug;

  // Explicit VCD-visible aliases for the architectural results.
  wire [31:0] checked_x3;
  wire [31:0] checked_x4;
  wire [31:0] checked_x6;
  wire [31:0] checked_x7;
  wire [31:0] checked_mem0;

  assign checked_x3 = dut.registers.regs[3];
  assign checked_x4 = dut.registers.regs[4];
  assign checked_x6 = dut.registers.regs[6];
  assign checked_x7 = dut.registers.regs[7];
  assign checked_mem0 = dut.data_memory.mem[0];

  rv32i_top #(.IMEM_FILE("program.hex")) dut (
    .clk(clk), .reset(reset), .pc_debug(pc_debug),
    .instr_debug(instr_debug), .alu_result_debug(alu_result_debug),
    .regwrite_debug(regwrite_debug)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("rv32i.vcd");
    $dumpvars(0, tb_rv32i);
  end

  initial begin
    repeat (2) @(posedge clk);
    #1 reset = 0;

    // x1=5, x2=7, x3=12, memory[0]=12, x4=12.
    // BEQ skips the instruction that would write 99 to x5.
    // JAL writes PC+4 (=36) to x6, skips x7=99, then target writes x7=42.
    repeat (13) @(posedge clk);
    #1;

    if (checked_x3 !== 32'd12) $fatal(1, "Error ADD x3");
    if (checked_x4 !== 32'd12) $fatal(1, "Error LW x4");
    if (checked_x6 !== 32'd36) $fatal(1, "Error JAL link x6");
    if (checked_x7 !== 32'd42) $fatal(1, "Error JAL target x7");
    if (checked_mem0 !== 32'd12) $fatal(1, "Error SW memory[0]");

    $display("PASS: ADD, SW, LW, BEQ, and JAL verified.");
    $display("Expected registers: x1=5 x2=7 x3=%0d x4=%0d x5=1 x6=%0d x7=%0d",
             checked_x3, checked_x4, checked_x6, checked_x7);
    $display("Expected data memory: mem[0]=%0d", checked_mem0);
    $finish;
  end

  initial begin
    #500;
    $fatal(1, "Testbench timeout");
  end
endmodule
