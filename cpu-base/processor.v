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

	 wire[4:0] shamt, raw_aluop;
	 assign shamt = q_imem[11:7];
	 assign raw_aluop = q_imem[6:2];

	 wire[16:0] immediate;
	 assign immediate = q_imem[16:0];
	 
	 wire[26:0] target;
	 assign target = q_imem[26:0];
	 
	 // decide all control bits
	 wire use_rd_as_second_readReg, immediate_type, load_reg_from_memory;
	 wire is_bne, is_blt, is_j, is_jal, is_jr, is_bex, is_setx;
	 opcode_control u_opc(opcode, use_rd_as_second_readReg, immediate_type,
		  wren, ctrl_writeEnable, load_reg_from_memory, is_bne, is_blt, 
		  is_j, is_jal, is_jr, is_bex, is_setx);
	 
	 // decide readRegs for register file
	 assign ctrl_readRegA = is_bex ? 5'b11110: rs;
	 assign ctrl_readRegB = is_bex ? 5'b00000: (use_rd_as_second_readReg ? rd : rt);

	 // decide data to be written in dram
	 assign data = data_readRegB;

	 // decide data operand B of the ALU to be immediate or value of regB
	 wire [31:0] data_operandB;
	 wire [31:0] sx_immediate;
	 extend_sign #(.N_PREV(17), .N_EXTENDED(32)) u_xs(immediate, sx_immediate);
	 assign data_operandB = immediate_type ? sx_immediate : data_readRegB;
	 
	 // Decide which alu operation will be used
	 wire [4:0] alu_operation_type;
	 decide_alu_operation decider_ao(opcode, raw_aluop, alu_operation_type);
	 
	 // alu module
	 wire isNotEqual, isLessThan, alu_overflow;
	 wire [31:0] alu_output;
	 alu u_alu(data_readRegA, data_operandB, alu_operation_type, shamt,
			alu_output, isNotEqual, isLessThan, alu_overflow);
	 // decide the value of data_writeReg when regfile is not handling exception and not Jtype
	 wire [4:0] ctrl_writeReg_non_exception;
	 wire [31:0] data_writeReg_non_exception;
	 assign ctrl_writeReg_non_exception = rd;
	 assign data_writeReg_non_exception = load_reg_from_memory ? q_dmem : alu_output;
	
	 // The Bypass logic for rstatus_value
	 // decide if we are handling exception in the current cycle
	 wire exception_overflow;
	 wire [31:0] rstatus_value_overflow;
	 overflow_decider u_od(alu_overflow, opcode, alu_operation_type, exception_overflow, rstatus_value_overflow);
	 // according to overflow or not, decide which register to write what data
	 wire [4:0] ctrl_writeReg_not_Jtype;
	 wire [31:0] data_writeReg_not_Jtype;
	 assign ctrl_writeReg_not_Jtype = exception_overflow ? 5'b11110 : ctrl_writeReg_non_exception;
	 assign data_writeReg_not_Jtype = exception_overflow ? rstatus_value_overflow : data_writeReg_non_exception;
	
	 // decide the what data is written into which register for J type 
	 assign ctrl_writeReg = is_jal ? 5'b11111 : (is_setx ? 5'b11110 : ctrl_writeReg_not_Jtype);
	 assign data_writeReg = is_jal ? {{20{1'b0}}, incremented_pc} : (is_setx ? {{5{1'b0}}, target} : data_writeReg_not_Jtype);
	 /* TODO : Handling the Dirty write of registers */
	 
	 // decide address for dmem
	 assign address_dmem = alu_output[11:0];
	 /* The logic for program counter*/
	 // create the program counter
	 wire [11:0] input_pc; // the input wire of programming counter
	 dffe_ref #(.N(12)) program_counter(address_imem, input_pc, clock, 1'b1, reset);

	 // determine the pc of next cycle
	 wire ignored1, ignored2, ignore3, ignore4;
	 wire [11:0] incremented_pc;
	 // increment pc: address_imem is the output of pc, input of the adder
	 RCA #(.SIZE(12)) u_incr(incremented_pc, ignored1, ignored2, address_imem, {{11{1'b0}}, 1'b1}, 1'b0);
	 // add immediate on it
	 /* TODO: whether immediate can be negative? contatenation of immediate is used assuming no negative */
	 wire [11:0] immediate_pc;
	 RCA #(.SIZE(12)) u_incr_immed(immediate_pc, ignore3, ignore4, incremented_pc, immediate[11:0], 1'b0);
	 // mux to decide whether to add immediate after increment
	 wire should_pc_jump_by_N;
	 assign should_pc_jump_by_N = (is_bne & isNotEqual) | (is_blt & ~isLessThan & isNotEqual);
	 wire[11:0] imme_or_incr_pc;
	 assign imme_or_incr_pc = should_pc_jump_by_N ? immediate_pc : incremented_pc;
	 // mux to decide whether to jump to target
	 wire should_jump_to_target;
	 assign should_jump_to_target = is_j | is_jal | (is_bex & isNotEqual);
	 wire[11:0] target_or_imme_or_incr_pc;
	 assign target_or_imme_or_incr_pc = should_jump_to_target ? target[11:0] : imme_or_incr_pc;
	 // mux to decide whether to jump to rd register value
	 wire should_jump_to_rd;
	 assign should_jump_to_rd = is_jr;
	 assign input_pc = should_jump_to_rd ? data_readRegB[11:0] : target_or_imme_or_incr_pc;
	 
endmodule
