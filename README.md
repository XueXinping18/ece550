# Checkpoint5
## name: Xinping Xue, Haolou Sun
## netID: xx99, hs392

### General description
> There are four units in the processor with each having its own clock: Instruction Memory, Register File, and Data Memory and programming counter. The processor will read a 32-bits instruction from the Instruction Memory and converts it into operation code, input address and output address. Then, using the operation code, input and output address, the processor will handle the intruction, writing the appropriate values into Register File, Data Memory and programming counter accordingly.

### opcode_control.v
> This file contains modules that abstract out the logic to convert operation code and into a variety of specific signals that are used as inputs of muxes, enable bits in DFFEs or memories, and other useful signals. Also, the type of operation in ALU is also decided according to the opcode and aluop bits in the instruction.

### utility.v
> This file contains three helper function that will be used in <b> processor.v </b>file:
>>The <b>extend_sign</b> function extend the 17-bits <b>immediate</b> to 32 bits.
The <b>overflow_decider</b> function decides whether overflow happened or not according to the overflow signal of alu, and operation type, and provide the value to be written in <b>rstatus</b> register if overflows happened.
The <b>clock_generator</b> fucntion encapsulates the logics to decide the clocks for Instruction Memory, Register File, Data Memory and Programming Counter, respectively.

### processor.v
> This file convert the 32-bit instruction to 5-bit operation code, destination register, source register, memory address, PC address and so on according to different types of instructions. Then read or write data from or to the registers, memory and PCs. The DFFE for PC is also defined in the processor.

### Clock
The Clock cycles involving the cycles for programmming counter (The processor), Imem, Dmem and Register file.<br>
>The Clock frequency of Imem is 4 times of the processor so that the update in PC can trigger the update in instruction fetched from Imem in a timely manner, i.e., the delay is only 1/4 clock period of programming counter.<br>
Clock cycle of Register file is 2 times of the processor so that the longest data path, i.e., lw can finish two register operation interleaved by one memory operation within one clock cycle of processor. Also, the clock cycle can't be 4 times of the processor because otherwise it might cause dirty writes to registers in jal operation where the update of PC might triggered an additional update to the 31st register.<br>
Clock cycle of dmem is 2 times of the processor and being reversed to avoid dirty write and allows the memory operation to be interleaved into register operations.<br>