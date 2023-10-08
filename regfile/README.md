# Checkpoint 3: Implement a Register File #
### Xinping (Kevin) Xue ### 
### xx99 ### 
The general design of the register file is including 32 32-bit registers. The functionality of each module is described as follows: <br>
```
module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);
```
The module regfile is the main module, which enable one write or two simultaneous reads on the registers.
```
module write_enable_decider(enable_writes, ctrl_writeEnable, ctrl_writeReg);
```
The write_enable_decider decide which register to write by returning a 32-bit one-hot or all-zero array. Each bit decide if one register will be overwritten.
```
module dffe_ref(q, d, clk, en, clr);
```
The dffe_ref module takes a parameter N to be the size to create a single register. It periodically output its register states as q.
```
module read_from_registers (result, register_file, ctrl);
```
The read_from_registers module take the value of all 32-bit registers, using a 5-bit control code to decide which register is returned.
```
module decoder_32bits(compact, one_hot);
```
Decoder can decode a 5-bit integer to its 32-bit one-hot representation.
