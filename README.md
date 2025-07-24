# UART_Communication_protocol
UART Communication System with Metastability-Resilient Receiver Architecture.


UART Communication System with Metastability-Resilient Receiver Architecture
created a UART module for reliable 8-bit serial data transmission using 1 start and 1 stop bit. Integrated a dual flip-flop synchronizer in the receiver to prevent metastability during asynchronous sampling, ensuring stable and glitch-free data capture.

UART Communication System with Metastability-Resilient Receiver Architecture
This project implements a Universal Asynchronous Receiver Transmitter (UART) protocol in Verilog, designed for reliable 8-bit serial data communication. UART is a widely used hardware communication protocol that enables full-duplex data exchange between devices without requiring a separate clock signal, making it ideal for low-pin count serial interfaces.

✨ Key Features
8-bit Data Transfer with 1 Start Bit and 1 Stop Bit

Asynchronous Serial Communication

Modular Design – separate Transmitter and Receiver modules

Glitch-Free Sampling using Dual Flip-Flop Synchronizer to handle metastability in the receiver

🔧 Transmitter Module (UART_TX)
The UART transmitter takes an 8-bit parallel data byte and transmits it serially, framed with a start bit (logic 0) and a stop bit (logic 1). The module ensures proper timing using a baud rate clock divider, enabling precise control of bit transmission duration.

Features:

Detects valid transmission requests via a tx_dv signal

Transmits LSB first

Supports configurable baud rate through a parameterized clock divider

 Receiver Module (UART_RX)
The UART receiver captures incoming serial data, resynchronizing it to the system clock using a dual flip-flop synchronizer, minimizing the risk of metastability due to asynchronous sampling.

Features:

Starts data reception upon detecting a falling edge on the start bit

Samples bits at the mid-point of their expected durations to reduce sampling error

Assembles serial bits into an 8-bit parallel byte

Outputs a rx_dv signal upon valid data reception

🧪 Metastability Handling
The receiver architecture integrates a 2-stage synchronizer on the incoming serial line to mitigate metastability. This ensures reliable operation even when the transmitting and receiving clocks are asynchronous or loosely coupled.
