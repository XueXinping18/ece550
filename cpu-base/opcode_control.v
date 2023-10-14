// The detail of opcode to signals is subject to change after adding more instructions
// The implementation here is temporary
module opcode_control(opcode, second_readReg, use_immediate);
	input[4:0] opcode;
	output second_readReg, immediate_type;
	assign second_readReg = opcode[1];
	
	// decide whether to use immediate as the second operand of ALU
	assign use_immediate = opcode[1] | opcode[2] | opcode[3];
endmodule


