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
	generic_shift #(.DIRECTION(-1)) shif(data_operand, 1'b0, ctrl_shiftamt, result);
endmodule

module arithmetic_right_shift (data_operand, ctrl_shiftamt, result);
	input [31:0] data_operand;
	input [4:0] ctrl_shiftamt;
	output [31:0] result;
	// decide padding
	wire padding;
	assign padding = data_operand[31];
	generic_shift #(.DIRECTION(1)) shif(data_operand, padding, ctrl_shiftamt, result);
endmodule


// The shift function that use ports to control shift amount and parameter to control direction 
module generic_shift (data, padding, ctrl_shiftamt, result);
	// a parameter decide the direction of shift
	parameter DIRECTION;
	//number of bits in ctrl_shiftamt
	localparam N = 5;
	localparam SIZE = 2 ** N;
	input [SIZE - 1:0] data;
	input padding;
	input [N - 1:0] ctrl_shiftamt;
	output [SIZE - 1:0] result;
	
	generate 
		genvar i;
		// By naming each iteration, we can refer to ports defined in any stage anywhere
		for (i = 0; i < N; i = i + 1) begin : stage
			// for the mux: after_shift = shouldshift ? do_shift : before_shift
			wire [SIZE - 1:0] before_shift, do_shift, after_shift;
			if(i != 0) 
				assign before_shift = stage[i - 1].after_shift;
			else
				assign before_shift = data;
			one_time_shift #(.SHIFT_INT((2 ** i) * DIRECTION)) shif(before_shift, padding, do_shift);	
			assign after_shift = ctrl_shiftamt[i] ? do_shift : before_shift;
		end
	endgenerate
	assign result = stage[N - 1].after_shift;
endmodule


// The shift function that use parameter SHIFT_INT to control shift amount and direction
// positive SHIFT_INT represents shift right, and negative represents shift left;
// padding represents what to pads: O or 1
module one_time_shift(data, padding, result);
	parameter SHIFT_INT;
	
	localparam SIZE = 32;
	input[SIZE - 1:0] data;
	input padding;
	output[SIZE - 1:0] result;
	generate
		genvar i;
		for (i = 0; i < SIZE; i=i+1) begin : index
			if(i + SHIFT_INT < SIZE && i + SHIFT_INT >= 0)
				assign result[i] = data[i + SHIFT_INT];
			else
				assign result[i] = padding;
		end
	endgenerate
endmodule
