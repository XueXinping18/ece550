module extend_sign(immediate, sx_immediate);
	 parameter N_PREV = 17;
	 parameter N_EXTENDED = 32;
	 
	 input[N_PREV - 1 : 0] immediate;
	 output[N_EXTENDED - 1 : 0] sx_immediate;
	 
	 assign sx_immediate[N_PREV - 1:0] = immediate;
	 genvar i;
	 generate
		  for(i = N_PREV; i < N_EXTENDED; i = i + 1) begin: sign_extension
		      sx_immediate[i] = immediate[N_PREV - 1];
		  end
	 endgenerate
endmodule
