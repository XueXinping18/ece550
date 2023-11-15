// The detail of opcode to signals is subject to change after adding more instructions
// The implementation here is temporary
module opcode_control(opcode, second_readReg, use_immediate,
	dmem_writeEnable, reg_writeEnable, load_reg_from_memory);
	input[4:0] opcode;
	output second_readReg, use_immediate, dmem_writeEnable, reg_writeEnable, load_reg_from_memory;

	// decide which reg is used as the second input reg
	assign second_readReg = opcode[1];

	// decide whether to use immediate as the second operand of ALU
	assign use_immediate = opcode[1] | opcode[2] | opcode[3];

	// decide whether dmem is writable
	assign dmem_writeEnable = opcode[0] & opcode[1] & opcode[2];

	// decide whether register is writable
	assign reg_writeEnable = ~opcode[1]; // TODO: should change in next checkpoint

	// decide if the register will be loaded from memory
	assign load_reg_from_memory = opcode[3];
endmodule


