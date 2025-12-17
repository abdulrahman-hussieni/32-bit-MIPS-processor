# 🖥️ MIPS Processor Implementations (Verilog HDL)

## 📌 Overview
This repository contains multiple implementations of the **MIPS (Microprocessor without Interlocked Pipelined Stages)** architecture using **Verilog HDL**.  
The project is designed for **educational and academic purposes**, helping students understand CPU architecture and datapath/control design.

It includes **Single-Cycle**, **Multi-Cycle**, and **5-Stage Pipelined** MIPS processors.

---

## 📂 Repository Structure

32-bit-MIPS-processor/
│
├── Single-Cycle/ # Single-cycle MIPS processor
├── Multi-Cycle/ # Multi-cycle MIPS processor
├── Pipeline/ # 5-stage pipelined MIPS processor
└── README.md # Project overview
---

## 🧠 Implemented Architectures

### 🔹 Single-Cycle Processor
- Each instruction completes in **one clock cycle**
- Simple and clear datapath
- Ideal for learning CPU fundamentals
- Best for understanding datapath and control logic

📁 Folder: `Single-Cycle/`

---

### 🔹 Multi-Cycle Processor
- Instructions are executed over **multiple clock cycles**
- Reuses hardware components across cycles
- More efficient than single-cycle in terms of clock period
- Demonstrates FSM-based control design

📁 Folder: `Multi-Cycle/`

---

### 🔹 Pipelined Processor
- Classic **5-stage MIPS pipeline**:
  - Instruction Fetch (IF)
  - Instruction Decode (ID)
  - Execute (EX)
  - Memory Access (MEM)
  - Write Back (WB)
- Includes:
  - Forwarding unit
  - Hazard detection
  - Stall insertion
- Higher instruction throughput compared to single-cycle

📁 Folder: `Pipeline/`

---

## 🧩 Supported Instruction Types
- **R-Type Instructions**
- **I-Type Instructions**
- **J-Type Instructions**

(Details for each instruction set can be found inside the README of each folder.)

---

## 🎯 Project Goals
- Understand MIPS architecture fundamentals
- Compare single-cycle, multi-cycle, and pipelined designs
- Learn datapath and control unit design using Verilog
- Practice hazard detection and resolution techniques
- Build a strong foundation in CPU microarchitecture

---

## 🛠️ Technology Used
- **Hardware Description Language:** Verilog HDL
- **Design Style:** Structural & Modular
- **Target Use:** Academic projects, learning computer architecture

---

## 👥 Team Members

<table align="center">
  <tr>
    <td align="center" width="50%">
      <a href="https://github.com/abdulrahman-hussieni">
        <img src="https://github.com/abdulrahman-hussieni.png?size=200"
             width="110" height="110"
             style="border-radius:50%; border:5px solid #3498db;">
        <br><br>
        <strong>Abdulrahman Hussieni</strong>
        <br><sub>Single Cycle</sub>
      </a>
    </td>

    <td align="center" width="50%">
      <a href="https://github.com/AhmedHamed408">
        <img src="https://github.com/AhmedHamed408.png?size=200"
             width="110" height="110"
             style="border-radius:50%; border:5px solid #2ecc71;">
        <br><br>
        <strong>Ahmed Hamed</strong>
        <br><sub>Single Cycle</sub>
      </a>
    </td>
  </tr>
</table>

---

## 📝 Notes
- This project is intended for **educational use**
- Designs follow the **classic MIPS architecture**
- Each folder contains its own detailed README

---

