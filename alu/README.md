# Checkpoint 2 Submission
### Xinping Xue
### xx99
The general design of this ALU includes a module that is capable of doing addition and subtraction, a module that is capable of doing bitwise "and" and "or" operations, and a module that does shifts. After the calculation of shifts, bitwise "and" and "or", and addition (or subtraction), there will be muxes to select according to opcode which result is our desired result. <br>
Here will be the description for all the modules:<br>
```
module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
```
The main module, doing the operations for the two operands according to ALUopcode.
```
module addition(data_operandA, data_operandB, cin, data_result, isNotEqual, isLessThan, overflow);
```
Addition module is capable of doing addition and subtraction according to the cin bit. Overflow is determined according to whether the carry-in and carry-out bits of the full adder for the highest bits are the same. isLessThan is determined by XORing the most significant bit of data_result and the overflow bit. isNotEqual is 1 if and only if all the bits after the subtraction is zero. The add operation is delegated to module CSA_32bits. 
```
module CSA_32bits(sum, cout, overflow, in1, in2, cin)
```
The 32bits adder composed of three RCA and a mux. Overflow is determined according to whether the carry-in and carry-out bits of the full adder for the highest bits are the same. 
```
module RCA(sum, cout, overflow, in1, in2, cin);
```
An general RCA that is capable of taking a parameter SIZE to perform the addition.

```
module bitwise_operation (data_operandA, data_operandB, last_bit_opcode, data_result);
```
The bitwire_operation module is capable of doing bitwise-and and bitwise-or according to the last_bit_opcode. It is achieved by calculating both "and" and "or" and then mux them.
```
module shift (data_operand, ctrl_shiftamt, direction, data_result);
```
Shift module shifts data_operand by ctrl_shiftamt length. When direction equal to 0, it performs arithmetic right shift. When direction equal to 1, it performs logical left shift. It is implemented by calculate both type of shifts and then mux them. The actual work is delegated to generic_shift module.
```
module generic_shift (data, padding, ctrl_shiftamt, result)(parameter DIRECTION);
```
The generic shift module requires padding as input port and DIRECTION as parameter to perform shifts. padding is defined as the number filled in when shifting. e.g. SLL always has padding 0 and SRA has padding according to the highest bit before shift. When shifting left, DIRECTION is -1. When shifting Right, DIRECTION is 1. The number of bits in ctrl_shiftamt is the number of stages for the shift operation. For the stage i, every bit is updated as the mux between the 2^i left/right bit and the current bit, according to the ctrl_shiftamt[i]. The shift operation in every stage (corresponding to the shift by 2^i bits) is delegated by the module one_time_shift.  
```
module one_time_shift(data, padding, result)(parameter SHIFT_INT);
```
Shift the data to right by SHIFT_INT bits. (When SHIFT_INT is negative, the data will shift left). 
```
module not_equal_to_zero_32bits(not_zero, data);
```
A parallel function to decide whether a 32 bits vector to be zero. Output 0 if all bits are zero. When deciding whether or not all the bits of a vector are zeros, parallel OR gates are used to determine the first round result, and applying parallel OR gates to determine the second round result, so on, until the last OR gate decides the final result. This design has much shorter delay than a naive chain of OR gates.

