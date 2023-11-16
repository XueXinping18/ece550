// The detail of opcode to signals is subject to change after adding more instructions
// The implementation here is temporary
module opcode_control(opcode, rd_second_readReg, use_immediate,
	dmem_writeEnable, reg_writeEnable, load_reg_from_memory, 
	is_bne, is_blt, is_j, is_jal, is_jr, is_bex, is_setx);
	input[4:0] opcode;
	output rd_second_readReg, use_immediate, dmem_writeEnable, reg_writeEnable, load_reg_from_memory;
	output is_bne, is_blt, is_j, is_jal, is_jr, is_bex, is_setx;
	// Identify the operation type
	wire is_Rtype, is_addi, is_sw, is_lw;
	
	assign is_Rtype = ~opcode[0] & ~opcode[1] & ~opcode[2] & ~opcode[3] & ~opcode[4];
	assign is_addi = opcode[0] & ~opcode[1] & opcode[2] & ~opcode[3] & ~opcode[4];
	assign is_sw = opcode[0] & opcode[1] & opcode[2] & ~opcode[3] & ~opcode[4];
	assign is_lw = ~opcode[0] & ~opcode[1] & ~opcode[2] & opcode[3] & ~opcode[4];
	
	// decide if the operation is bne
	assign is_bne = ~opcode[0] & opcode[1] & ~opcode[2] & ~opcode[3] & ~opcode[4];
	// decide if the operation is blt
	assign is_blt = ~opcode[0] & opcode[1] & opcode[2] & ~opcode[3] & ~opcode[4];
	// decide if the operation is jr
	assign is_jr = ~opcode[0] & ~opcode[1] & opcode[2] & ~opcode[3] & ~opcode[4];
	// decide if the operation is j
	assign is_j = opcode[0] & ~opcode[1] & ~opcode[2] & ~opcode[3] & ~opcode[4];
	// decide if the operation is jal;
	assign is_jal = opcode[0] & opcode[1] & ~opcode[2] & ~opcode[3] & ~opcode[4];
	// decide if the operation is bex;
	assign is_bex = ~opcode[0] & opcode[1] & opcode[2] & ~opcode[3] & opcode[4];
	// decide if the operation is setx;
	assign is_setx = opcode[0] & ~opcode[1] & opcode[2] & ~opcode[3] & opcode[4];
	
	// decide which reg is used as the second input reg, 1 represents rd to be the second reg
	assign rd_second_readReg = is_sw | is_bne | is_blt | is_jr;

	// decide whether to use immediate as the second operand of ALU
	assign use_immediate = is_addi | is_sw | is_lw;

	// decide whether dmem is writable
	assign dmem_writeEnable = is_sw;

	// decide whether register is writable
	assign reg_writeEnable = is_Rtype | is_addi | is_lw | is_jal | is_setx;

	// decide if the register will be loaded from memory
	assign load_reg_from_memory = is_lw;
	
endmodule

module decide_alu_operation(opcode, raw_aluop, alu_operation_type);
	 input[4:0] opcode;
	 input[4:0] raw_aluop;
	 output[4:0] alu_operation_type;
	 // decide if it is of R type
	 wire is_Rtype;
	 assign is_Rtype = ~(opcode[0] | opcode[1] | opcode[2] | opcode[3] | opcode[4]);
	 // decide if there is comparison for the non-Rtype instruction (which requires minus)
	 wire with_comparison; // shorthand for bex, blt, bne
	 assign with_comparison = ~opcode[0] & opcode[1];
	 // decide the final aluop type;
	 assign alu_operation_type = is_Rtype ? raw_aluop: {4'b0000, with_comparison};
endmodule

