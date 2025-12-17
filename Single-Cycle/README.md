# 🖥️ Single-Cycle MIPS Processor (VHDL)

## 📌 Overview
This repository contains an implementation of a **Single-Cycle MIPS processor** designed using **VHDL**.  
In this architecture, **each instruction completes in exactly one clock cycle**, making it ideal for learning and understanding the fundamentals of CPU datapath and control design.

The project closely follows the **classic MIPS ISA** and is intended for **educational and academic purposes**.

---

## 🧠 Single-Cycle Architecture
- One instruction executed per clock cycle
- Simple and clear datapath
- No pipelining or hazard handling
- Clock period determined by the slowest instruction

This design is best suited for **learning CPU basics** before moving to pipelined architectures.

---

## ✨ Features
- Complete single-cycle datapath
- Unified control unit
- Modular and readable Verilog code
- Supports R-type, I-type, and J-type instructions
- Follows standard MIPS architecture

---

## 🧩 Supported Instructions

### 🔹 R-Type
- `add`, `sub`
- `and`, `or`, `xor`, `nor`
- `slt`
- `sll`, `srl`, `sra`
- `jr`

### 🔹 I-Type
- `addi`, `andi`, `ori`, `xori`
- `lw`, `sw`
- `beq`, `bne`
- `slti`
- `lui`

### 🔹 J-Type
- `j`
- `jal`

---

## 🏗️ Architecture Components

### Core Modules
- **Program Counter (PC)** – Holds the address of the current instruction  
- **Instruction Memory (IM)** – Stores program instructions  
- **Register File** – 32 registers with two read ports and one write port  
- **ALU** – Performs arithmetic and logical operations  
- **Data Memory (DM)** – Used for load and store instructions  
- **Main Control Unit** – Generates control signals for the datapath  

---

## 🎯 Project Goals
- Understand MIPS single-cycle processor design
- Learn datapath and control signal generation
- Practice VHDL using a modular approach
- Build a foundation for pipelined CPU designs

---

## 🛠️ Technology Used
- **Hardware Description Language:** VHDL  
- **Design Style:** Structural & Modular  
- **Target Use:** Academic projects and CPU design learning

---

## 📝 Notes
- Intended for educational use only
- Based on the classic MIPS architecture
- Easily extendable for additional instructions or features



