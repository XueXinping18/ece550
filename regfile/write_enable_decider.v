// Given the writeEnable bit and 5-bit ctrl codes to decide which to enable
// Note that the 0th register is always disabled and the ouput is always 0
module write_enable_decider(enable_final, ctrl_writeEnable, ctrl_writeReg);
	input ctrl_writeEnable;
	input [4:0] ctrl_writeReg;
	output [31:0] enable_final;
	
	// obtain onehot result
	wire [31 : 0] enable_onehot;
	decoder_32bits dec(ctrl_writeReg, enable_onehot);
	
	// obtain final enable
	assign enable_final[0] = 0;
	genvar j;
	generate
		for(j = 1; j < 32; j = j + 1) begin : decide_final_writable
			and a(enable_final[j], ctrl_writeEnable, enable_onehot[j]);
		end
	endgenerate
endmodule
