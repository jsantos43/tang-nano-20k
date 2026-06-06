// top_tb.v — testbench do módulo top
`timescale 1ns/1ps

module top_tb;

    // ── Entradas ──────────────────────────────────────────────
    reg clk;

    // ── Saídas ────────────────────────────────────────────────
    wire [2:0] led;

    // ── Instancia o módulo sob teste ──────────────────────────
    top uut (
        .clk(clk),
        .led(led)
    );

    // ── Clock 27MHz (período = ~37ns) ─────────────────────────
    initial clk = 0;
    always #18.5 clk = ~clk;

    // ── Dump para GTKWave ─────────────────────────────────────
    initial begin
        $dumpfile("sim/dump.vcd");
        $dumpvars(0, top_tb);
    end

    // ── Estímulos ─────────────────────────────────────────────
    initial begin
        // Adicione seus estímulos aqui
        #1000;
        $finish;
    end

    // ── Monitor ───────────────────────────────────────────────
    initial begin
        $monitor("t=%0t | led=%03b", $time, led);
    end

endmodule
