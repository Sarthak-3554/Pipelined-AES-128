# 🔐 Pipelined AES-128 Encryption on PYNQ Board

[![Vivado](https://img.shields.io/badge/Tool-Vivado-007ACC?logo=xilinx&logoColor=white)]()
[![Vitis](https://img.shields.io/badge/Tool-Vitis-00A3E0?logo=xilinx&logoColor=white)]()
[![Language](https://img.shields.io/badge/Language-Verilog%20%7C%20C-blue)]()
[![Board](https://img.shields.io/badge/Target-PYNQ--Z2-orange)]()
[![License](https://img.shields.io/badge/License-MIT-green)]()

---

## 🧠 Overview

This project implements a **pipelined AES-128 encryption module** on the **PYNQ board** using **Verilog HDL**.  
The design emphasizes **high throughput** and **low latency** through a **half-round pipelined architecture** and a **sequential key expansion** mechanism.

---

## ⚙️ Features

- ✅ Fully pipelined AES-128 encryption  
- ⚡ High throughput and low latency performance  
- 🔁 Sequential key expansion for optimized resource usage  
- 🧩 Compatible with **Vivado** and **Vitis** design flow  
- 🧠 Includes testbench and performance report  

---
## 🧰 How to Use

### 1. **Vivado**
- Open the Vivado project from `/vivado/project.xpr`
- Synthesize and implement the design  
- Generate bitstream and export hardware

### 2. **Vitis**
- Import the exported hardware into Vitis  
- Compile and run the C application from `/vitis/`  
- Observe AES-128 encryption results on PYNQ

### 3. **Simulation**
- Run the provided testbench in `/verilog/`  
- Verify correctness of each AES round and final ciphertext

---






