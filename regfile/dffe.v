// periodically change and manifest the state of DFFE
// The DFFE contains a register, whose size is decided by a parameter N.
module dffe_ref(q, d, clk, en, clr);
	parameter N = 32;
   //Inputs
   input clk, clr, en;
   input[N - 1: 0] d; 
	
	//Output
   output[N - 1: 0] q;
	
   //Internal wire
   wire clr;

   //Register
   reg[N - 1: 0] q;

   //Intialize q to N-bit zeros
   initial
   begin
       q = {N{1'b0}};
   end

   //Set value of q on positive edge of the clock or clear
   always @(posedge clk or posedge clr) begin
       //If clear is high, set q to zeros
       if (clr) begin
           q <= {N{1'b0}};
       //If enable is high, set q to the value of d
       end else if (en) begin
           q <= d;
       end
   end
endmodule

