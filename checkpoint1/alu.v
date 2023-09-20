module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
	// decide the input for CSA
	wire cin;
	wire [31:0] not_operandB, real_operandB;
	assign cin = ctrl_ALUopcode[0];
	// obtain the real operandB
	// negate the operandB
	genvar i;
	generate
		for (i = 0; i < 32; i=i+1) begin : negate_vector
			not n0(not_operandB[i], data_operandB[i]);
		end
	endgenerate
	// mux to decide + or -
	assign real_operandB = cin ? not_operandB : data_operandB;
	// pass to CSA
	wire unused_cout;
	CSA_32bits addition(data_result, unused_cout, overflow, data_operandA, real_operandB, cin);
	// calculate isLessThan and isNotEqual
	xor xo1(isLessThan, data_result[31], overflow);
	not_equal_to_zero_32bits zero_checker(isNotEqual, data_result);
endmodule



