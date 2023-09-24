module bitwise_operation (data_operandA, data_operandB, last_bit_opcode, data_result);
	input [31:0] data_operandA, data_operandB;
	input last_bit_opcode;
	output [31:0] data_result;
	
	wire [31:0] and_result, or_result;
	and_vectorized #(.SIZE(32)) av(and_result, data_operandA, data_operandB);
	or_vectorized #(.SIZE(32)) ov(or_result, data_operandA, data_operandB);

	assign data_result = last_bit_opcode ? or_result : and_result;
endmodule

module or_vectorized (result, in1, in2);
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

module and_vectorized (result, in1, in2);
	parameter SIZE = 1;
	input[SIZE - 1:0] in1, in2;
	output[SIZE - 1:0] result;
	
	genvar i;
	generate
		for (i = 0; i < SIZE; i = i + 1) begin : generate_and
			and a(result[i], in1[i], in2[i]);
		end
	endgenerate
endmodule

