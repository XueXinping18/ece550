module extend_sign(immediate, sx_immediate);
	 parameter N_PREV = 17;
	 parameter N_EXTENDED = 32;

	 input[N_PREV - 1 : 0] immediate;
	 output[N_EXTENDED - 1 : 0] sx_immediate;

	 assign sx_immediate[N_PREV - 1:0] = immediate;
	 genvar i;
	 generate
		  for(i = N_PREV; i < N_EXTENDED; i = i + 1) begin: sign_extension
		      assign sx_immediate[i] = immediate[N_PREV - 1];
		  end
	 endgenerate
endmodule

// decide overflow happened or not according to the overflow signal of alu, and operation type.
// Provide the the value to be written in rstatus register if overflow occurred according to operation type.
module overflow_decider(overflow, opcode, aluop, true_overflow, rstatus_value);
	 input overflow;
	 input[4:0] opcode, aluop;
	 output true_overflow;
	 output[31:0] rstatus_value;

	 wire is_addi, is_add_or_sub;
	 assign is_addi = ~opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & opcode[0];
	 assign is_add_or_sub = ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0] & ~aluop[4] & ~aluop[3] & ~aluop[2] & ~aluop[1];
	 assign true_overflow = overflow & (is_addi | is_add_or_sub);
	 // no matter what type of calculation, always set rstatus_value
	 assign rstatus_value[31:2] = {30{1'b0}};
	 assign rstatus_value[0] = is_add_or_sub;
	 assign rstatus_value[1] = (is_add_or_sub & aluop[0]) | is_addi;
endmodule

// Abstract out all the clock generator
module clock_generator(imem_clock, dmem_clock, processor_clock, regfile_clock, original_clock, reset);
	input original_clock, reset;
	output imem_clock, dmem_clock, processor_clock, regfile_clock;
	// To reserve enough time for fetching IMEM, make everything slower
	clock_divider basic_clock(original_clock, clock);
	// faster imem and regfile
	assign imem_clock = clock;
	// slower dmem
	wire reverse_dmem_clock;
	clock_divider reverse_dmem(clock, reverse_dmem_clock);
	clock_divider regfile(clock, regfile_clock);
	assign dmem_clock = ~reverse_dmem_clock;
	// much slower processor
	wire middle_clock;
	clock_divider middle(clock, middle_clock);
	clock_divider processor(middle_clock, processor_clock);
endmodule


