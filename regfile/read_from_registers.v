// According to 5-bit ctrl, select a 32-bit register from the entire register file.
module read_from_registers (result, register_file, ctrl);
	input [4 : 0] ctrl;
	input [32 * 32 - 1 : 0] register_file;
	output [31 : 0] result;
	
	wire [31 : 0] one_hot;
	decoder_32bits u_dec(ctrl, one_hot);
	
	// using tri-state buffers to determine the output: connect all buffers together by repeatedly assigning
	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin : tri_buffer
			assign result = one_hot[i] ? register_file[32 * i + 31 : 32 * i] : {32{1'bz}};
		end
	endgenerate
endmodule
