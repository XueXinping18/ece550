module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //

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



