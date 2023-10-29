# Checkpoint4
## name: Xinping Xue, Haolou Sun
## netID: xx99, hs392

### General description
> There are three units in the processor: the Instruction Memory, the Register File, and the Data Memory. The processor will read a 32-bits instruction from the Instruction Memory and converts it into operation code, input address and output address. Then, using the operation code, input and output address, the processor will handle the intruction.

### opcode_control.v
> This file decides the signals to write register file port, write data memomry port, and the signal to each mux based on the 5-bits operation code the processor generates.

### utility.v
> This file contains three helper function that will be used in <b> processor.v </b>file:
>>The <b>extend_sign</b> function extend the 17-bits <b>immediate</b> part to 32-bits.
The <b>overflow_decider</b> function decides overflow happened or not according to the overflow signal of alu, and operation type, and provide the value to be written in <b>rstatus</b> register.
The <b>clock_generator</b> fucntion generates the clock for Instruction Memory, Register File, Data Memory and Processor.

### processor.v
> This file convert the 32-bit instruction to 5-bit operation code, destination register, source register, memory address and PC address according to different types of instructions. Then read or write data from or to the registers or memory.

### Clock
>Instruction Memory and Register File's clock freqeuncy is four times of the clock frequency of Processor so that the longest path within the datapath can be finished within a clock cycle of the processor and the instruction is updated right after the update of PC. To avoid dirty write to the memory, Data Memory's clock frequency is double of the clock frequency of the processor, with the value being reversed.