# Day 2: Introduction to Application Binary Interface (ABI)

# ABI (Application Binary Interface)

The **ABI** acts as a bridge between the application and the system. It defines how application code interacts with the operating system and hardware at the binary level.

Through the ABI and system call interface, user programs can access hardware resources in a controlled manner, ensuring compatibility and portability across systems.

---

The slides show three types of RISC-V instructions: **load**, **add**, and **store**, each using a different instruction format.

- The **load** instruction  
  ```asm
  ld x8, 16(x23)
is an I-type format. It loads a 64-bit value from the memory address x23 + 16 into register x8.

- The **add** instruction  
  ```asm
  add x8, x24, x8
is an R-type format. It adds the values in x24 and x8, and stores the result back in x8.

- The **store** instruction  
  ```asm
  sd x8, 8(x23)
is an S-type format. It stores the value from x8 into the memory address x23 + 8.

![image](https://github.com/user-attachments/assets/e327891e-7115-4161-a659-145176c709d3)
