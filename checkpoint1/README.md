# Checkpoint 1 Submission
### Xinping Xue
### xx99
In general, the ALU mainly includes a 32-bit CSA adder, which is composed of three 16-bit RCAs. Each RCA is composed of a number of full adders chaining together. Note that carry-out bits and overflow bits are calculated for every RCA and CSA.
```
module CSA_32bits(sum, cout, overflow, in1, in2, cin)
module RCA(sum, cout, overflow, in1, in2, cin);
```

For the ALU, the plus and minus functions are utilizing the same CSA adder, with plus and minus distingushed by the carry-in bit of the CSA adder and a mux to determine whether or not we need to negate the data_operandB. Overflow is determined according to whether the carry-in and carry-out bits of the full adder for the highest bits are the same. Note that the overflow bit is also selected by a mux, similar to the higher 16 bits of data_result.

The output isLessThan is determined by an XOR gate between the most significant bit of data_result and the overflow bit.

The output isNotEqual is set to be zero iff all the bits of the data_result are zeros. When deciding whether or not all the bits of a vector are zeros, I utilized the parallelism by using parallel OR gates to determine the first round result, and applying parallel OR gates to determine the second round result, so on, until the last OR gate decides the final result. This design has much shorter delay than a naive chain of OR gates.
```
module not_equal_to_zero_32bits(not_zero, data);
```