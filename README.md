# 🖥️ MIPS Processor Implementations (VHDL)

## 📌 Overview
This repository contains multiple implementations of the **MIPS (Microprocessor without Interlocked Pipelined Stages)** architecture using **VHDL**.  
The project is designed for **educational and academic purposes**, helping students understand CPU architecture and datapath/control design.

It includes **Single-Cycle**, **Multi-Cycle**, and **5-Stage Pipelined** MIPS processors.

---

## 📂 Repository Structure
```text
32-bit-MIPS-processor/
│
├── Single-Cycle/ # Single-cycle MIPS processor
├── Multi-Cycle/ # Multi-cycle MIPS processor
├── Pipeline/ # 5-stage pipelined MIPS processor
└── README.md # Project overview
```

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
- Learn datapath and control unit design using VHDL
- Practice hazard detection and resolution techniques
- Build a strong foundation in CPU microarchitecture

---

## 🛠️ Technology Used
- **Hardware Description Language:** VHDL
- **Design Style:** Structural & Modular
- **Target Use:** Academic projects, learning computer architecture

---
## 👥 Team Members


<div align="center">

<table width="100%" style="table-layout: fixed;">
  <tr>
    <td align="center" width="20%">
      <a href="https://github.com/abdulrahman-hussieni">
        <img src="https://github.com/abdulrahman-hussieni.png?size=200" width="110" height="110" style="border-radius:50%; border:5px solid #3498db;">
        <br><br>
        <strong>Abdulrahman Hussieni</strong>
        <br><sub>Single Cycle</sub>
      </a>
    </td>
    <td align="center" width="20%">
      <a href="https://github.com/AhmedHamed408">
        <img src="https://github.com/AhmedHamed408.png?size=200" width="110" height="110" style="border-radius:50%; border:5px solid #2ecc71;">
        <br><br>
        <strong>Ahmed Hamed</strong>
        <br><sub>Single Cycle</sub>
      </a>
    </td>
    <td align="center" width="20%">
      <a href="https://github.com/">
        <img src="https://github.com/Ahmedmohamed360.png?size=200" width="110" height="110" style="border-radius:50%; border:5px solid #e74c3c;">
        <br><br>
        <strong>Anas Mohamed</strong>
        <br><sub>Single Cycle</sub>
      </a>
    </td>
    <td align="center" width="20%">
      <a href="https://github.com/mohamad0ahmad">
        <img src="https://github.com/mohamad0ahmad.png?size=200" width="110" height="110" style="border-radius:50%; border:5px solid #f39c12;">
        <br><br>
        <strong>Mohamad Ahmad Hassan</strong>
        <br><sub>Single Cycle</sub>
      </a>
    </td>
    <td align="center" width="20%">
      <a href="https://github.com/">
        <img src="https://github.com/Ahmedmohamed360.png?size=200" width="110" height="110" style="border-radius:50%; border:5px solid #9b59b6;">
        <br><br>
        <strong>Ahmed Ay</strong>
        <br><sub>Single Cycle</sub>
      </a>
    </td>
  </tr>
</table>
</div>
<br>
---
<div align="center">
<table width="100%" style="table-layout: fixed;">
  <tr>
    <td align="center" width="20%">
      <a href="https://github.com/3mrakml">
        <img src="https://github.com/3mrakml.png?size=200" width="110" height="110" style="border-radius:50%; border:5px solid #3498db;">
        <br><br>
        <strong>Amr Akmal</strong>
        <br><sub>PipeLine</sub>
      </a>
    </td>
    <td align="center" width="20%">
      <a href="https://github.com/AbdelrahmanA7mad">
        <img src="https://github.com/AbdelrahmanA7mad.png?size=200" width="110" height="110" style="border-radius:50%; border:5px solid #2ecc71;">
        <br><br>
        <strong>Abdelrahman Ahmed</strong>
        <br><sub>PipeLine</sub>
      </a>
    </td>
    <td align="center" width="20%">
      <a href="https://github.com/AhmedAbdelkader77">
        <img src="https://github.com/AhmedAbdelkader77.png?size=200" width="110" height="110" style="border-radius:50%; border:5px solid #e74c3c;">
        <br><br>
        <strong>Ahmed Mohamed</strong>
        <br><sub>PipeLine</sub>
      </a>
    </td>
    <td align="center" width="20%">
      <a href="https://github.com/assem52">
        <img src="https://github.com/assem52.png?size=200" width="110" height="110" style="border-radius:50%; border:5px solid #f39c12;">
        <br><br>
        <strong>Assem Melege</strong>
        <br><sub>PipeLine</sub>
      </a>
    </td>
    <td align="center" width="20%">
      <a href="https://github.com/Mohamed-Eldeeb-Dev">
        <img src="https://github.com/Mohamed-Eldeeb-Dev.png?size=200" width="110" height="110" style="border-radius:50%; border:5px solid #9b59b6;">
        <br><br>
        <strong>Mohamed Eldeeb</strong>
        <br><sub>PipeLine</sub>
      </a>
    </td>
  </tr>
</table>

<br>
</div>



