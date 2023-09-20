module RCA(sum, cout, overflow, in1, in2, cin);
	parameter SIZE = 16;
	
	input [SIZE - 1:0] in1, in2;
	input cin;
	output [SIZE - 1:0] sum;
	output cout, overflow;
	
	wire [SIZE:0] carrybit;
	assign carrybit[0] = cin;
	// generate the code to build RCA
	genvar i;
	generate
		for (i = 0; i < SIZE; i=i+1) begin : adder_generator
			full_adder adder(sum[i], carrybit[i+1], in1[i], in2[i], carrybit[i]);
		end
	endgenerate
	assign cout = carrybit[SIZE];
	// decide if overflowed
	xor overflow_decider(overflow, carrybit[SIZE - 1], carrybit[SIZE]);
endmodule
// outdated codes in recitation 2 for reference
//	full_adder ad1(out[0], carrybit[0], in1[0], in2[0], cin);
//	full_adder ad2(out[1], carrybit[1], in1[1], in2[1], carrybit[0]);
//	full_adder ad3(out[2], carrybit[2], in1[2], in2[2], carrybit[1]);
//	full_adder ad4(out[3], cout, in1[3], in2[3], carrybit[2]);


