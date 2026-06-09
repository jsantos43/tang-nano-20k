// top_tb.v — Testbench Lab 01: Tabuada
`timescale 1ns/1ps

module top_tb;

  reg        clk, load;
  reg  [7:0] i_a;
  wire [7:0] res;
  wire       done;
  wire [9:0] bcd;

  tabuada_b uut (
    .clk(clk), .load(load),
    .i_a(i_a), .res(res), .done(done)
  );

  bin2bcd conv (
    .bin(res), .bcd(bcd)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("01_tables/sim/dump.vcd");
    $dumpvars(0, top_tb);
  end

  initial begin
    load = 0;
    i_a  = 8'd7; // tabuada do 7

    // pulsa load por 1 ciclo para carregar i_a
    @(posedge clk); #1;
    load = 1;
    @(posedge clk); #1;
    load = 0;

    // aguarda os 10 resultados + 1 ciclo extra
    repeat(12) @(posedge clk);
    $finish;
  end

  // exibe resultado a cada ciclo quando não está em load
  always @(posedge clk) begin
    if (!load)
      $display("t=%0t | %0d x %0d = %0d%0d (done=%b)",
               $time, i_a, uut.counter,
               bcd[7:4], bcd[3:0], done);
  end

endmodule
