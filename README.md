**FPGA implementation of the Complete "Tiny" Processor Design which runs one program.**

### This Repository contains:

- Verilog Codes for Tiny-Processor
- Testbench
- XDC Files
- Simulation results
---

## Processor Description

The processor has a register file consisting of 16 registers, each of 8 bits. The processor can execute the following instructions. The instructions that need 2 operands will take one operand from the Register file and another from the accumulator. The result will be transferred to the Accumulator. There is an 8-bit extended (EXT) register used only during multiplication and division operations. This register stores the higher order bits during multiplication and the quotient during division. The C/B register holds the carry and borrow during addition and subtraction, respectively.

**Note:**

- Each instruction takes 1 clock cycle.
- Division operation can never have 0 as the divisor.
- Branch instructions can only branch within the program.

### Instruction format:

**Direct Instruction**  
`Operation code Register address`

**Branch Instruction**  
`Operation code 4-bit address (label)`

---

## Instruction Set

| Instruction Opcode  | Operation | Explanation |
|----------------------|-----------|-------------|
| NOP         | 0000 0000 | No operation | 
| ADD Ri      | 0001 xxxx | Add ACC with Register contents and store the result in ACC. Updates C/B | 
| SUB Ri      | 0010 xxxx | Subtract ACC with Register contents and store the result in ACC. Updates C/B | 
| MUL Ri      | 0011 xxxx | Multiply ACC with Register contents and store the result in ACC. Updates EXT | 
| DIV Ri      | 0100 xxxx | Divide ACC with Register contents and store the Quotient in ACC. Updates EXT with remainder. |
| LSL ACC     | 0000 0001 | Left shift logical the contents of ACC. Does not update C/B |
| LSR ACC     | 0000 0010 | Right shift logical the contents of ACC. Does not update C/B | 
| CIR ACC     | 0000 0011 | Circular right shift ACC contents. Does not update C/B | 
| CIL ACC     | 0000 0100 | Circular left shift ACC contents. Does not update C/B | 
| ASR ACC     | 0000 0101 | Arithmetic Shift Right ACC contents | - |
| AND Ri      | 0101 xxxx | AND ACC with Register contents (bitwise) and store the result in ACC. C/B is not updated | 
| XRA Ri      | 0110 xxxx | XOR ACC with Register contents (bitwise) and store the result in ACC. C/B is not updated | 
| CMP Ri      | 0111 xxxx | Compare ACC with Register contents (ACC-Reg) and update C/B. If ACC >= Reg, C/B = 0; else C/B = 1 | 
| INC ACC     | 0000 0110 | Increment ACC, updates C/B when overflows | 
| DEC ACC     | 0000 0111 | Decrement ACC, updates C/B when underflows | 
| Br \<4-bit address\> | 1000 xxxx | Update PC and branch to 4-bit address if C/B = 1 |
| MOV ACC, Ri | 1001 xxxx | Move the contents of Ri to ACC |
| MOV Ri, ACC | 1010 xxxx | Move the contents of ACC to Ri |
| Ret \<4-bit address\> | 1011 xxxx | Update PC and return to the called program |
| HLT         | 1111 1111 | Stop the program (last instruction) |

---

---

## Sample Code

**Add the contents of R5 and R6, and store the result in R7:**

```assembly
MOV ACC, R1  ; Load R1 in ACC
XRA R1       ; Clear ACC
ADD R5       ; ACC + R5
ADD R6       ; ACC + R6 (which is R5 + R6)
MOV R7, ACC  ; Store the result in R7
HLT          ; Stop the program
```
### Simulation Result
![Simulation Result Waveform](https://github.com/KailashDusad/Tiny-Processor/blob/main/Simulation%20Result.png)
