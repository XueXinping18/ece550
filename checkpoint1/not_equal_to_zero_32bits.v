// a parallel function to decide a 32 bits vector not to be zero
module not_equal_to_zero_32bits(not_zero, data);
	input [31:0] data;
	output not_zero;
	wire [15:0] tmp1;
	wire [7:0] tmp2;
	wire [3:0] tmp3;
	wire [1:0] tmp4;
	or_vectorized #(.SIZE(16)) o1(tmp1, data[31:16], data[15:0]);
	or_vectorized #(.SIZE(8)) o2(tmp2, tmp1[15:8], tmp1[7:0]);
	or_vectorized #(.SIZE(4)) o3(tmp3, tmp2[7:4], tmp2[3:0]);
	or_vectorized #(.SIZE(2)) o4(tmp4, tmp3[3:2], tmp3[1:0]);
	or o5(not_zero, tmp4[1], tmp4[0]);
endmodule

// a handy function to conduct or operations on two vector of ports
module or_vectorized(result, in1, in2);
	parameter SIZE = 1;
	input[SIZE - 1:0] in1, in2;
	output[SIZE - 1:0] result;
	
	genvar i;
	generate
		for (i = 0; i < SIZE; i = i + 1) begin : generate_or
			or o(result[i], in1[i], in2[i]);
		end
	endgenerate
endmodule
