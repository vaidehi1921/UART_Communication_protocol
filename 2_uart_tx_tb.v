// testbench for UART transmitter 

`timescale 1ns / 1ps

module uart_tx_tb;

    // DUT inputs
    reg i_clk = 0;
    reg i_tx_dv = 0;
    reg [7:0] i_tx_byte = 8'h00;

    // DUT outputs
    wire o_tx_serial;
    wire o_tx_active;
    wire o_tx_done;

    // Instantiate the UART Transmitter
    uart_tx #(.clk_per_bit(87)) dut (
        .i_clk(i_clk),
        .i_tx_dv(i_tx_dv),
        .i_tx_byte(i_tx_byte),
        .o_tx_serial(o_tx_serial),
        .o_tx_active(o_tx_active),
        .o_tx_done(o_tx_done)
    );

    // Generate 100 MHz clock
    always #5 i_clk = ~i_clk;

    // Stimulus
    initial begin
        $dumpfile("uart_tx_tb.vcd");
        $dumpvars(0, uart_tx_tb);

        // Wait for system to stabilize
        #20;

        // Send one byte (synchronized with clk)
        @(posedge i_clk);
        i_tx_byte = 8'hA5;
        i_tx_dv   = 1'b1;

        @(posedge i_clk);
        i_tx_dv   = 1'b0;

        // Wait for full UART transmission (10 bits * 87 clocks * 10ns)
        #9000;

        $finish;
    end

endmodule


