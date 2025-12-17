# 🖥️ 5-Stage Pipelined MIPS Processor (VHDL)

## 📌 Overview
implementation of a **5-stage pipelined MIPS processor** designed using **VHDL**.  

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

