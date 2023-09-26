module shift (data_operand, ctrl_shiftamt, direction, data_result);
   input [31:0] data_operand;
   input [4:0] ctrl_shiftamt;
	input direction;
   output [31:0] data_result;
	// calculate both the result of SLL and SRA and use mux to decide the final result
	wire [31:0] SLL_result, SRA_result;
	logical_left_shift SLL(data_operand, ctrl_shiftamt, SLL_result);
	arithmetic_right_shift SRA(data_operand, ctrl_shiftamt, SRA_result);
	assign data_result = direction ? SRA_result : SLL_result;
	
endmodule

module logical_left_shift (data_operand, ctrl_shiftamt, result);
	input [31:0] data_operand;
	input [4:0] ctrl_shiftamt;
	output [31:0] result;
	// generic_shift #(.DIRECTION(-1)) shif(data_operand, 1'b0, ctrl_shiftamt, result);
	// store all intermediate ports, the initial and result
	wire [(5 + 1) * 32 - 1:0] intermediate;
	assign intermediate[31 : 0] = data_operand;
	generate
		genvar i;
		for (i = 1; i < 6; i = i + 1) begin : stage
			wire[31 : 0] shifted_data, data_before_shift;
			assign data_before_shift = intermediate[32 * i - 1 : 32 * (i - 1)];
			one_time_left_shift #(.SHIFT_INT(2 ** (i - 1))) shif(data_before_shift, 1'b0, shifted_data);
			assign intermediate[32 * (i + 1) - 1 : 32 * i] = ctrl_shiftamt[i - 1] ? shifted_data : data_before_shift;
		end
	endgenerate
	assign result = intermediate[32 * 6 - 1 : 32 * 5];
	
endmodule

module arithmetic_right_shift (data_operand, ctrl_shiftamt, result);
	input [31:0] data_operand;
	input [4:0] ctrl_shiftamt;
	output [31:0] result;
	// decide padding
	wire padding;
	assign padding = data_operand[31];
	// generic_shift #(.DIRECTION(1)) shif(data_operand, padding, ctrl_shiftamt, result);
	
	// store all intermediate ports, the initial and result
	wire [(5 + 1) * 32 - 1:0] intermediate;
	assign intermediate[31 : 0] = data_operand;
	generate
		genvar i;
		for (i = 1; i < 6; i = i + 1) begin : stage
			wire[31 : 0] shifted_data, data_before_shift;
			assign data_before_shift = intermediate[32 * i - 1 : 32 * (i - 1)];
			one_time_right_shift #(.SHIFT_INT(2 ** (i - 1))) shif(data_before_shift, padding, shifted_data);
			assign intermediate[32 * (i + 1) - 1 : 32 * i] = ctrl_shiftamt[i - 1] ? shifted_data : data_before_shift;
		end
	endgenerate
	assign result = intermediate[32 * 6 - 1 : 32 * 5];
endmodule

// The left shift function that use parameter SHIFT_INT to control shift amount
// padding represents what to pads: O or 1
module one_time_left_shift(data, padding, result);
	parameter SHIFT_INT = 0;
	
	localparam SIZE = 32;
	input[SIZE - 1:0] data;
	input padding;
	output[SIZE - 1:0] result;
	generate
		genvar i;
		for (i = 0; i < SHIFT_INT; i=i+1) begin : pad_index
			assign result[i] = padding;
		end
	endgenerate
	generate 
		genvar j;
		for (j = SHIFT_INT; j < SIZE; j=j+1) begin : shift_index
			assign result[j] = data[j - SHIFT_INT];
		end
	endgenerate
endmodule

// The right shift function that use parameter SHIFT_INT to control shift amount
// padding represents what to pads: O or 1
module one_time_right_shift(data, padding, result);
	parameter SHIFT_INT = 0;
	
	localparam SIZE = 32;
	input[SIZE - 1:0] data;
	input padding;
	output[SIZE - 1:0] result;
	generate
		genvar i;
		for(i = 0; i < SIZE - SHIFT_INT; i=i+1) begin : shift_index
			assign result[i] = data[i + SHIFT_INT];
 		end
	endgenerate
	generate
		genvar j;
		for(j = SIZE - SHIFT_INT; j < SIZE; j=j+1) begin : pad_index
			assign result[j] = padding;
 		end
	endgenerate
endmodule

// This part of code is outdated as the new requirements does not allow generate if statement.
//// The shift function that use ports to control shift amount and parameter to control direction 
//module generic_shift (data, padding, ctrl_shiftamt, result);
//	// a parameter decide the direction of shift
//	parameter DIRECTION = 1;
//	//number of bits in ctrl_shiftamt
//	localparam N = 5;
//	localparam SIZE = 2 ** N;
//	input [SIZE - 1:0] data;
//	input padding;
//	input [N - 1:0] ctrl_shiftamt;
//	output [SIZE - 1:0] result;
//	
//	generate 
//		genvar i;
//		// By naming each iteration, we can refer to ports defined in any stage anywhere
//		for (i = 0; i < N; i = i + 1) begin : stage
//			// for the mux: after_shift = shouldshift ? do_shift : before_shift
//			wire [SIZE - 1:0] before_shift, do_shift, after_shift;
//			if(i != 0) 
//				assign before_shift = stage[i - 1].after_shift;
//			else
//				assign before_shift = data;
//			one_time_shift #(.SHIFT_INT((2 ** i) * DIRECTION)) shif(before_shift, padding, do_shift);	
//			assign after_shift = ctrl_shiftamt[i] ? do_shift : before_shift;
//		end
//	endgenerate
//	assign result = stage[N - 1].after_shift;
//endmodule
