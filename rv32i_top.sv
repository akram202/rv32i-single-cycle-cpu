module rv32i_top #(
  parameter IMEM_FILE = "program.hex",
  parameter integer IMEM_WORDS = 256,
  parameter integer DMEM_WORDS = 256
) (
  input  logic        clk,
  input  logic        reset,
  output logic [31:0] pc_debug,
  output logic [31:0] instr_debug,
  output logic [31:0] alu_result_debug,
  output logic        regwrite_debug
);
  logic [31:0] pc, pc_next, pc_plus4, pc_target;
  logic [31:0] instruction, immediate;
  logic [31:0] read_data1, read_data2, alu_b, alu_result;
  logic [31:0] memory_read_data, write_back_data;
  logic [3:0] alu_control;
  logic [1:0] alu_op, result_src;
  logic reg_write, alu_src, mem_read, mem_write, branch, jump;
  logic zero, pc_src;

  pc_reg pc_unit (
    .clk(clk), .reset(reset), .pc_next(pc_next), .pc(pc)
  );

  inst_mem #(.WORDS(IMEM_WORDS), .INIT_FILE(IMEM_FILE)) instruction_memory (
    .address(pc), .instruction(instruction)
  );

  pc_adder pc_adders (
    .pc(pc), .imm_ext(immediate),
    .pc_plus4(pc_plus4), .pc_target(pc_target)
  );

  imm_decoder immediate_decoder (
    .instruction(instruction), .immediate(immediate)
  );

  control_unit control (
    .opcode(instruction[6:0]), .reg_write(reg_write), .alu_src(alu_src),
    .mem_read(mem_read), .mem_write(mem_write), .result_src(result_src),
    .branch(branch), .jump(jump), .alu_op(alu_op)
  );

  register_file registers (
    .clk(clk), .reg_write(reg_write),
    .read_addr1(instruction[19:15]), .read_addr2(instruction[24:20]),
    .write_addr(instruction[11:7]), .write_data(write_back_data),
    .read_data1(read_data1), .read_data2(read_data2)
  );

  always_comb begin
    if (alu_src) alu_b = immediate;
    else alu_b = read_data2;

    pc_src = jump | (branch & zero);
    if (pc_src) pc_next = pc_target;
    else pc_next = pc_plus4;

    case (result_src)
      2'b00: write_back_data = alu_result;
      2'b01: write_back_data = memory_read_data;
      2'b10: write_back_data = pc_plus4;
      default: write_back_data = 0;
    endcase
  end

  alu_decoder alu_control_decoder (
    .alu_op(alu_op), .funct3(instruction[14:12]),
    .funct7_bit5(instruction[30]), .alu_control(alu_control)
  );

  alu execution_alu (
    .a(read_data1), .b(alu_b), .alu_control(alu_control),
    .result(alu_result), .zero(zero)
  );

  data_mem #(.WORDS(DMEM_WORDS)) data_memory (
    .clk(clk), .mem_read(mem_read), .mem_write(mem_write),
    .address(alu_result), .write_data(read_data2),
    .read_data(memory_read_data)
  );

  assign pc_debug = pc;
  assign instr_debug = instruction;
  assign alu_result_debug = alu_result;
  assign regwrite_debug = reg_write;
endmodule
