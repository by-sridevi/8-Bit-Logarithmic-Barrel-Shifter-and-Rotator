8-Bit Logarithmic Barrel Shifter and Rotator

Project Overview :

This project implements an 8-bit Multi-Stage Logarithmic Barrel Shifter and Rotator using Verilog HDL in Xilinx Vivado.

The design performs different shifting and rotating operations using a three-stage logarithmic multiplexer architecture.

Features :

- Logical Shift Left (LSL)
- Logical Shift Right (LSR)
- Arithmetic Shift Right (ASR)
- Rotate Left (ROL)
- Rotate Right (ROR)
- 8-bit input and output data
- 3-bit shift amount (0 to 7)
- Three-stage logarithmic MUX architecture
- Combinational logic design

Operation Encoding :


| Operation | Opcode |
|-----------|--------|
| LSL       | 000    |
| LSR       | 001    |
| ASR       | 010    |
| ROL       | 011    |
| ROR       | 100    |


Architecture :

The design uses three logarithmic stages:

1. Stage 1 – Conditional shift/rotate by 1 bit.
2. Stage 2 – Conditional shift/rotate by 2 bits.
3. Stage 3 – Conditional shift/rotate by 4 bits.

Input preprocessing and output postprocessing are used to support left-shift and left-rotate operations using the right-shift core.

Tools and Technologies :

- Verilog HDL
- Xilinx Vivado
- RTL Design
- Digital Logic Design

Project Files :

- "barrel_shifter.v" – Main RTL design.
- "barrel_shifter_tb.v" – Testbench for verifying all five operations and shift amounts from 0 to 7.

Applications :

- Processor datapaths
- Arithmetic and logic units (ALU)
- Digital signal processing
- FPGA-based digital systems

Author :

Developed as an academic project using Verilog HDL.
