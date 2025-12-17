# 🖥️ 5-Stage Pipelined MIPS Processor (VHDL)

## 📌 Overview
This folder contains an implementation of a **5-stage pipelined MIPS processor** designed using **VHDL**.  
The design follows the **classic MIPS pipeline architecture**, demonstrating how instruction-level parallelism improves processor performance compared to single-cycle designs.

This implementation is intended for **educational and academic purposes**, focusing on pipeline behavior, hazards, and control logic.

---

## 🧠 Pipeline Architecture
The processor is divided into **five pipeline stages**:

1. **Instruction Fetch (IF)**  
   - Fetches the instruction from Instruction Memory  
   - Updates the Program Counter (PC)

2. **Instruction Decode (ID)**  
   - Decodes the instruction  
   - Reads operands from the Register File  
   - Generates control signals

3. **Execute (EX)**  
   - Performs arithmetic and logical operations  
   - Calculates branch targets  
   - Handles comparison operations

4. **Memory Access (MEM)**  
   - Accesses Data Memory for load and store instructions

5. **Write Back (WB)**  
   - Writes results back to the Register File

---

## 📊 Pipelined MIPS Datapath

<img width="1131" height="790" alt="image" src="https://github.com/user-attachments/assets/b7f822b6-8e6e-44d0-9226-5332d934a216" />


---

## ⚙️ Pipeline Registers
To separate stages and allow parallel execution, the following **pipeline registers** are implemented:

- **IF/ID**
- **ID/EX**
- **EX/MEM**
- **MEM/WB**

Each register stores both **data signals** and **control signals** required for the next stage.

---

## 🚧 Hazard Handling

### 🔹 Data Hazards
- Resolved using a **Forwarding Unit**
- Allows results to be forwarded directly from later stages without waiting for write-back

### 🔹 Load-Use Hazards
- Detected by a **Hazard Detection Unit**
- Pipeline stall is inserted when necessary

### 🔹 Control Hazards
- Handled using branch logic
- Incorrectly fetched instructions are flushed when required

---

## 🧩 Supported Instructions

### R-Type Instructions
- `add`, `sub`
- `and`, `or`, `xor`, `nor`
- `slt`
- `sll`, `srl`, `sra`
- `jr`

### I-Type Instructions
- `addi`, `andi`, `ori`, `xori`
- `lw`, `sw`
- `beq`, `bne`
- `slti`
- `lui`

### J-Type Instructions
- `j`
- `jal`

---

## 🏗️ Core Components
- **Program Counter (PC)**
- **Instruction Memory**
- **Register File (32 registers)**
- **ALU**
- **Data Memory**
- **Main Control Unit**
- **Forwarding Unit**
- **Hazard Detection Unit**
- **Pipeline Registers**

---

## 🎯 Design Goals
- Demonstrate instruction-level parallelism
- Compare pipelined vs single-cycle performance
- Understand pipeline hazards and their solutions
- Practice modular CPU design using **VHDL**

---

## 🛠️ Technology Used
- **Hardware Description Language:** VHDL  
- **Design Style:** Structural & Modular  
- **Target Use:** Computer Architecture courses and academic projects

---

## 📝 Notes
- This design follows the **classic MIPS pipeline model**
- Intended for **learning and experimentation**
- Easily extendable to support more instructions or advanced features

---

