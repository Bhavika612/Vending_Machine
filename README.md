#  FPGA Based Vending Machine System

This repository contains a Verilog-based vending machine project designed to run on the Digilent **Zybo Z7-20** FPGA development board.

The project simulates a coin-operated vending machine with product selection, balance tracking, cancellation, and product dispensing, visualized using standard and RGB LEDs.

---

## Modules

### `clk_divider.v`
- Divides the 125 MHz system clock down to ~10 Hz for user input responsiveness and FSM timing.

### `vending_machine_core.v`
- Implements the finite state machine (FSM) and internal logic for:
  - Coin value processing
  - Product selection and cost calculation
  - Balance handling
  - Dispensing
  - Change return
  - LED feedback

### `vending_machine_fpga.v`
- Top-level module connecting hardware I/O (switches, buttons, LEDs) to the core logic and debouncing circuitry.

---

## 🔌 Constraints File

Located in: `constraints/zybo_z7_constraints.xdc`  

Feel free to add an image or gif here showing your vending machine in action!

