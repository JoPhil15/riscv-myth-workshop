# Day 1: Introduction to RISC-V and TL-Verilog

Welcome to the **RISC-V MYTH Workshop**! In this session, we explored the basics of **RISC-V architecture**, how to set up **Makerchip**, and write simple **TL-Verilog code**.

## From C Code to Layout

The C code is first compiled into RISC-V assembly, which is then converted to machine code (binary instructions). These instructions are meant to run on hardware.

To execute them, a hardware interface is required. This is provided by an HDL (Hardware Description Language) implementation of the RISC-V architecture at the RTL (Register Transfer Level). The RTL design is then synthesized and transformed into a physical layout.

**Summary:**

C Code → RISC-V Assembly → Machine Code → RTL (via HDL) → Layout

![image](https://github.com/user-attachments/assets/a46a0984-7ce1-4977-b511-6d0d0d1eb31e)
![image](https://github.com/user-attachments/assets/67646345-ab5a-4363-b1f5-741ec1d4c19e)
![image](https://github.com/user-attachments/assets/7dced23a-1a88-4ec3-bea1-4f4e67690222)


## How Applications Run on Hardware

Applications run on hardware through the help of system software, which translates high-level code into machine-level binary understood by the hardware. This system software includes:

- Compiler  
- Assembler  
- Operating System  

The compiler converts the code into assembly instructions, which follow the syntax specific to the target hardware (e.g., Intel x86 or RISC-V). The assembler then translates these instructions into binary (machine code).

The hardware is designed to recognize specific binary sequences and perform corresponding tasks, enabling the execution of applications.

---

## Instruction Types and Core

RISC-V includes several types of instructions:

- Pseudo Instructions  
- Base Integer Instructions  
- Multiply Instructions  
- Others  

A core that implements all these types is known as an **RV64IMFD** core.

---

## Running Applications on Hardware

To run an application on hardware, multiple software and hardware layers are involved:

- Compiler  
- Assembler  
- Operating System  
- ABI (Application Binary Interface)  
- RTL Hardware  

Some parts of the ISA (Instruction Set Architecture) are available to both user and system modes, while others are restricted to user mode. When an application needs access to hardware resources like registers, it does so through **system calls** using the **ABI** (System Call Interface).

![image](https://github.com/user-attachments/assets/802513f2-3cb8-40f9-87d2-94c93fe839fb)

