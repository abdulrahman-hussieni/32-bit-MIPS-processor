# 🖥️ Single-Cycle MIPS Processor (VHDL)

## 📌 Overview
This repository contains an implementation of a **Single-Cycle MIPS processor** designed using **VHDL**.  
In this architecture, **each instruction completes in exactly one clock cycle**

---

## 🧠 Single-Cycle Architecture
- One instruction executed per clock cycle
- Simple and clear datapath
- No pipelining or hazard handling
- Clock period determined by the slowest instruction
  
---
## 🧠 Single-Cycle MIPS Datapath

<img width="1219" height="951" alt="image" src="https://github.com/user-attachments/assets/74010cff-f6a9-4564-bcc1-b363b0bbc411" />

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





