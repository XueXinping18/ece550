// This is a stupid and ugly five-bit decoder
module decoder_32bits(compact, one_hot);
	input[4:0] compact;
	output[31:0] one_hot;
	assign one_hot[0] = (~compact[4]) & (~compact[3]) & (~compact[2]) & (~compact[1]) & (~compact[0]);
	assign one_hot[1] = (~compact[4]) & (~compact[3]) & (~compact[2]) & (~compact[1]) & (compact[0]);
	assign one_hot[2] = (~compact[4]) & (~compact[3]) & (~compact[2]) & (compact[1]) & (~compact[0]);
	assign one_hot[3] = (~compact[4]) & (~compact[3]) & (~compact[2]) & (compact[1]) & (compact[0]);
	assign one_hot[4] = (~compact[4]) & (~compact[3]) & (compact[2]) & (~compact[1]) & (~compact[0]);
	assign one_hot[5] = (~compact[4]) & (~compact[3]) & (compact[2]) & (~compact[1]) & (compact[0]);
	assign one_hot[6] = (~compact[4]) & (~compact[3]) & (compact[2]) & (compact[1]) & (~compact[0]);
	assign one_hot[7] = (~compact[4]) & (~compact[3]) & (compact[2]) & (compact[1]) & (compact[0]);
	assign one_hot[8] = (~compact[4]) & (compact[3]) & (~compact[2]) & (~compact[1]) & (~compact[0]);
	assign one_hot[9] = (~compact[4]) & (compact[3]) & (~compact[2]) & (~compact[1]) & (compact[0]);
	assign one_hot[10] = (~compact[4]) & (compact[3]) & (~compact[2]) & (compact[1]) & (~compact[0]);
	assign one_hot[11] = (~compact[4]) & (compact[3]) & (~compact[2]) & (compact[1]) & (compact[0]);
	assign one_hot[12] = (~compact[4]) & (compact[3]) & (compact[2]) & (~compact[1]) & (~compact[0]);
	assign one_hot[13] = (~compact[4]) & (compact[3]) & (compact[2]) & (~compact[1]) & (compact[0]);
	assign one_hot[14] = (~compact[4]) & (compact[3]) & (compact[2]) & (compact[1]) & (~compact[0]);
	assign one_hot[15] = (~compact[4]) & (compact[3]) & (compact[2]) & (compact[1]) & (compact[0]);
	assign one_hot[16] = (compact[4]) & (~compact[3]) & (~compact[2]) & (~compact[1]) & (~compact[0]);
	assign one_hot[17] = (compact[4]) & (~compact[3]) & (~compact[2]) & (~compact[1]) & (compact[0]);
	assign one_hot[18] = (compact[4]) & (~compact[3]) & (~compact[2]) & (compact[1]) & (~compact[0]);
	assign one_hot[19] = (compact[4]) & (~compact[3]) & (~compact[2]) & (compact[1]) & (compact[0]);
	assign one_hot[20] = (compact[4]) & (~compact[3]) & (compact[2]) & (~compact[1]) & (~compact[0]);
	assign one_hot[21] = (compact[4]) & (~compact[3]) & (compact[2]) & (~compact[1]) & (compact[0]);
	assign one_hot[22] = (compact[4]) & (~compact[3]) & (compact[2]) & (compact[1]) & (~compact[0]);
	assign one_hot[23] = (compact[4]) & (~compact[3]) & (compact[2]) & (compact[1]) & (compact[0]);
	assign one_hot[24] = (compact[4]) & (compact[3]) & (~compact[2]) & (~compact[1]) & (~compact[0]);
	assign one_hot[25] = (compact[4]) & (compact[3]) & (~compact[2]) & (~compact[1]) & (compact[0]);
	assign one_hot[26] = (compact[4]) & (compact[3]) & (~compact[2]) & (compact[1]) & (~compact[0]);
	assign one_hot[27] = (compact[4]) & (compact[3]) & (~compact[2]) & (compact[1]) & (compact[0]);
	assign one_hot[28] = (compact[4]) & (compact[3]) & (compact[2]) & (~compact[1]) & (~compact[0]);
	assign one_hot[29] = (compact[4]) & (compact[3]) & (compact[2]) & (~compact[1]) & (compact[0]);
	assign one_hot[30] = (compact[4]) & (compact[3]) & (compact[2]) & (compact[1]) & (~compact[0]);
	assign one_hot[31] = (compact[4]) & (compact[3]) & (compact[2]) & (compact[1]) & (compact[0]);
endmodule



