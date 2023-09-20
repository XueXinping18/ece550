module CSA_32bits(sum, cout, overflow, in1, in2, cin);
	input [31:0] in1, in2;
	input cin;
	output [31:0] sum;
	output cout, overflow;
	
	// upper half result, cout and overflow candidates
	wire [15:0] select_ONE, select_ZERO;
	wire overflow_ONE, overflow_ZERO;
	wire cout_ZERO, cout_ONE;
	
	// unused values, should be ignored
	wire ignored_value;
	
	RCA #(.SIZE(16)) half_adder_ZERO(select_ZERO, cout_ZERO, overflow_ZERO, in1[31:16], in2[31:16], 0);
	RCA #(.SIZE(16)) half_adder_ONE(select_ONE, cout_ONE, overflow_ONE, in1[31:16], in2[31:16], 1);
	
	// lower half adder
	wire selector;
	RCA #(.SIZE(16)) lower_half_adder(sum[15:0], selector, ignored_value, in1[15:0], in2[15:0], cin);
	
	// determine upper half cout, result and overflow using mux
	assign sum[31:16] = selector ? select_ONE : select_ZERO;
	assign overflow = selector ? overflow_ONE : overflow_ZERO;
	assign cout = selector ? cout_ONE : cout_ZERO;
	
endmodule
