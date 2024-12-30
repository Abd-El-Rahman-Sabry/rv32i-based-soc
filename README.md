# RV32I-Based-SoC

# 🚀 RISC-V Processor Design Project

This project focuses on designing a RISC-V processor with both **single-cycle** and **pipelined** implementations. The verification phase is yet to be completed.

---

## 📂 Project Structure

```plaintext
RISC-V_Project/
├── SingleCycle/
│   ├── rtl/          # RTL design files for Single-Cycle Processor
│   ├── testbench/    # Testbench files for simulation
│   └── docs/         # Documentation for Single-Cycle Processor
├── Pipelined/
│   ├── rtl/          # RTL design files for Pipelined Processor
│   ├── testbench/    # Testbench files for simulation
│   └── docs/         # Documentation for Pipelined Processor
├── scripts/          # Helper scripts and Makefile
├── Makefile          # Automation of compilation and simulation
└── README.md         # Project README
```

---

## 🛠️ Features

### ✅ Single-Cycle Processor
- Implements a simple RISC-V processor with a single clock cycle per instruction.

### ✅ Pipelined Processor
- **5-Stage Pipeline Design**:
  1. Instruction Fetch (IF)
  2. Instruction Decode (ID)
  3. Execute (EX)
  4. Memory Access (MEM)
  5. Write Back (WB)
- Optimized for performance with:
  - Hazard detection unit
  - Forwarding logic for data dependencies

---

## 📜 Implemented Instructions

| **Category**      | **Instruction** | **Description**                                    | **Encoding**       |
|--------------------|-----------------|----------------------------------------------------|--------------------|
| **Arithmetic**     | `ADD`           | Add two registers.                                | `0000000 rs2 rs1 000 rd 0110011` |
|                    | `SUB`           | Subtract two registers.                           | `0100000 rs2 rs1 000 rd 0110011` |
|                    | `MUL`           | Multiply two registers.                           | `0000001 rs2 rs1 000 rd 0110011` |
| **Logical**        | `AND`           | Bitwise AND of two registers.                     | `0000000 rs2 rs1 111 rd 0110011` |
|                    | `OR`            | Bitwise OR of two registers.                      | `0000000 rs2 rs1 110 rd 0110011` |
|                    | `XOR`           | Bitwise XOR of two registers.                     | `0000000 rs2 rs1 100 rd 0110011` |
| **Shift**          | `SLL`           | Shift left logical.                               | `0000000 rs2 rs1 001 rd 0110011` |
|                    | `SRL`           | Shift right logical.                              | `0000000 rs2 rs1 101 rd 0110011` |
|                    | `SRA`           | Shift right arithmetic.                           | `0100000 rs2 rs1 101 rd 0110011` |
| **Load/Store**     | `LW`            | Load word from memory.                            | `xxxxxxxxx rs1 010 rd 0000011`   |
|                    | `SW`            | Store word to memory.                             | `xxxxxxxxx rs1 010 rs2 0100011`  |
| **Branch**         | `BEQ`           | Branch if equal.                                  | `xxxxxxxxx rs1 000 rs2 1100011`  |
|                    | `BNE`           | Branch if not equal.                              | `xxxxxxxxx rs1 001 rs2 1100011`  |
|                    | `BLT`           | Branch if less than (signed).                     | `xxxxxxxxx rs1 100 rs2 1100011`  |
|                    | `BGE`           | Branch if greater than or equal (signed).         | `xxxxxxxxx rs1 101 rs2 1100011`  |
| **Jump**           | `JAL`           | Jump and link.                                    | `xxxxxxxxxxxxxxxxx rd 1101111`   |
| **Immediate**      | `ADDI`          | Add immediate value to register.                  | `xxxxxxxx rs1 000 rd 0010011`    |

---

## 📜 Commands and Usage

### Environment Setup

| Command                          | Description                                         |
|----------------------------------|-----------------------------------------------------|
| `git clone https://github.com/Abd-El-Rahman-Sabry/rv32i-based-soc.git` | Clone the project repository.                     |
| `cd riscv-project`               | Navigate to the project directory.                 |

---

### Single-Cycle Processor Workflow

| Command                          | Description                                         |
|----------------------------------|-----------------------------------------------------|
| `cd SingleCycle/rtl`             | Go to the Single-Cycle processor RTL directory.    |
| `iverilog -o single_cycle_top single_cycle_top.v` | Compile the Single-Cycle design.                  |
| `vvp single_cycle_top`           | Run the compiled simulation.                       |
| `gtkwave single_cycle_top.vcd`   | View the waveform using GTKWave.                   |

---

### Pipelined Processor Workflow

| Command                          | Description                                         |
|----------------------------------|-----------------------------------------------------|
| `cd Pipelined/rtl`               | Go to the Pipelined processor RTL directory.        |
| `iverilog -o pipelined_top pipelined_top.v` | Compile the Pipelined design.                     |
| `vvp pipelined_top`              | Run the compiled simulation.                       |
| `gtkwave pipelined_top.vcd`      | View the waveform using GTKWave.                   |

---

## 📈 Future Enhancements

- 🚧 **Verification**:
  - Develop testbenches using **UVM** to verify both designs.
  - Perform regression testing and functional coverage.
- 🚧 **Integration**:
  - Incorporate the processor into a complete **System-on-Chip (SoC)** environment.

---

## 🔧 Tools and Technologies

| Tool/Technology   | Purpose                                           |
|--------------------|---------------------------------------------------|
| **Verilog**        | RTL design                                        |
| **Icarus Verilog** | Simulation of designs (`iverilog`, `vvp`)         |
| **GTKWave**        | Waveform visualization                           |

---

## 👨‍💻 About the Author

- **Name**: Sabry  
- **Role**: Hardware Verification Engineer and IC Design Enthusiast  
- **Interests**: EDA, Machine Learning, Deep Learning, and AI in VLSI fields  
- **Contact**: aersabry@gmail.com  

---

✨ *Happy Designing!*  
```


