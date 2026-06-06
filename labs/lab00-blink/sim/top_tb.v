// top_tb.v — Testbench Lab 00: Blink
`timescale 1ns/1ps

module top_tb;

    reg        clk;
    wire [2:0] led;

    top uut (
        .clk(clk),
        .led(led)
    );

    // Clock 27MHz (~37ns de período)
    initial clk = 0;
    always #18.5 clk = ~clk;

    initial begin
        $dumpfile("sim/dump.vcd");
        $dumpvars(0, top_tb);
    end

    // Simula tempo suficiente para ver algumas trocas de LED
    // (usando contador reduzido para simulação não demorar)
    initial begin
        #5_000_000;
        $finish;
    end

    initial begin
        $monitor("t=%0t ns | led=%03b", $time, led);
    end

endmodule
