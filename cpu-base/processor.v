/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 // record all meaningful sections in the opcode
	 wire[4:0] opcode;
	 assign opcode = q_imem[31:27];

    wire[4:0] rd, rs, rt;
	 assign rd = q_imem[26:22];
	 assign rs = q_imem[21:17];
	 assign rt = q_imem[16:12];

	 wire[4:0] shamt, aluop;
	 assign shamt = q_imem[11:7];
	 wire is_Itype;
	 assign is_Itype = opcode[0] | opcode[1] | opcode[2] | opcode[3] | opcode[4];
	 assign aluop = is_Itype ? 5'b00000 : q_imem[6:2];

	 wire[16:0] immediate;
	 assign immediate = q_imem[16:0];

	 // decide all control bits
	 wire use_rd_as_second_readReg, immediate_type, load_reg_from_memory;
	 opcode_control u_opc(opcode, use_rd_as_second_readReg, immediate_type,
		  wren, ctrl_writeEnable, load_reg_from_memory);

	 // decide readRegs for register file
	 assign ctrl_readRegA = rs;
	 assign ctrl_readRegB = use_rd_as_second_readReg ? rd : rt;

	 // decide data to be written in dram
	 assign data = data_readRegB;

	 // decide data operand B of the ALU to be immediate or value of regB
	 wire [31:0] data_operandB;
	 wire [31:0] sx_immediate;
	 extend_sign #(.N_PREV(17), .N_EXTENDED(32)) u_xs(immediate, sx_immediate);
	 assign data_operandB = immediate_type ? immediate : data_readRegB;

	 // alu module
	 wire isNotEqual, isLessThan, alu_overflow;
	 wire [31:0] alu_output;
	 alu u_alu(data_readRegA, data_operandB, aluop, shamt,
			alu_output, isNotEqual, isLessThan, alu_overflow);
	 // decide the value of data_writeReg when regfile is not handling exception
	 wire [4:0] ctrl_writeReg_non_exception;
	 wire [31:0] data_writeReg_non_exception;
	 assign ctrl_writeReg_non_exception = rd;
	 assign data_writeReg_non_exception = load_reg_from_memory ? q_dmem : alu_output;

	 // The Bypass logic for rstatus_value
	 // decide if we are handling exception in the current cycle
	 wire exception_overflow;
	 wire [31:0] rstatus_value;
	 overflow_decider u_od(alu_overflow, opcode, aluop, exception_overflow, rstatus_value);
	 // according to overflow or not, decide which register to write
	 // according to overflow or not, decide which value to written to register
	 // ctrl_writeEnable doesn't change
	 assign ctrl_writeReg = exception_overflow ? 5'b11110 : ctrl_writeReg_non_exception;
	 assign data_writeReg = exception_overflow ? rstatus_value : data_writeReg_non_exception;

	 // decide address for dmem
	 assign address_dmem = alu_output[11:0];
	 /* The logic for program counter*/
	 // create the program counter
	 wire [11:0] pc; // the input wire of programming counter
	 dffe_ref #(.N(12)) program_counter(address_imem, pc, clock, 1'b1, reset);

	 // determine the pc of next cycle
	 wire ignored1, ignored2;
	 wire [11:0] incremented_pc;
	 RCA #(.SIZE(12)) u_incr(incremented_pc, ignored1, ignored2, address_imem, {{11{1'b0}}, 1'b1}, 1'b0);
	 assign pc = incremented_pc;
endmodule
