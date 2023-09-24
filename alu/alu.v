module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
	// according to the last bit to do addition/subtraction
	// decide the input for CSA
//	wire cin;
//	wire [31:0] not_operandB, real_operandB;
//	assign cin = ctrl_ALUopcode[0];
//	// obtain the real operandB
//	// negate the operandB
//	genvar i;
//	generate
//		for (i = 0; i < 32; i=i+1) begin : negate_vector
//			not n0(not_operandB[i], data_operandB[i]);
//		end
//	endgenerate
//	// mux to decide + or -
//	assign real_operandB = cin ? not_operandB : data_operandB;
//	// pass to CSA
//	wire unused_cout;
//	CSA_32bits addition(data_result, unused_cout, overflow, data_operandA, real_operandB, cin);
//	// calculate isLessThan and isNotEqual
//	xor xo1(isLessThan, data_result[31], overflow);
//	not_equal_to_zero_32bits zero_checker(isNotEqual, data_result);
//	
	wire[31:0] data_result_addition, data_result_bitop, data_result_shift;
	// according to the last bit to do addition or subtraction
	addition addi(data_operandA, data_operandB, ctrl_ALUopcode[0], data_result_addition, isNotEqual, isLessThan, overflow);
	// according to the last bit to do bitwise operation and/or
	bitwise_operation bitop(data_operandA, data_operandB, ctrl_ALUopcode[0], data_result_bitop);
	// according to the last bit to do shift
	shift shif(data_operandA, ctrl_shiftamt, ctrl_ALUopcode[0], data_result_shift);
	// using muxes to determine data_result
	assign data_result = ctrl_ALUopcode[2] ? data_result_shift : (ctrl_ALUopcode[1] ? data_result_bitop : data_result_addition);
	
endmodule



