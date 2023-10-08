module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;
	
	
	// The periodic manifest of the registers_value
	wire [32 * 32 - 1 : 0] registers_value;
	
	// write block
	// decide whether and which register to enable
	wire [31:0] enable_writes;
	write_enable_decider decide0(enable_writes, ctrl_writeEnable, ctrl_writeReg);
	// use 32-bit DFFEs to write the registers
	genvar i;
	// for each register, create a 32-bit DFFE
	generate
		for(i = 0; i < 32; i = i + 1) begin: reg_loop
			dffe_ref #(.N(32)) dffe(registers_value[32 * (i + 1) - 1 : 32 * i], data_writeReg, clock, enable_writes[i], ctrl_reset);
		end
	endgenerate
	
	// output the registers to obtain the read results
	read_from_registers u_readA(data_readRegA, registers_value, ctrl_readRegA);
	read_from_registers u_readB(data_readRegB, registers_value, ctrl_readRegB);
	
endmodule


 

