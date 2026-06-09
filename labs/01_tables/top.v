module top(
  input  sysclk,
  input  [3:0] table_sel,
  input  load_btn,
  output done_led,
  output bcd_h1, bcd_h0,
  output [6:0] seg);

  wire        clk;
  wire [7:0]  res;
  wire [9:0]  bcd;
  wire [6:0]  segs;
  wire        done;
  integer     counter = 0;

  always @(posedge sysclk)
    counter = counter + 1;

  assign clk = counter[24]; // 27MHz / 2^25 ≈ 0.8Hz (~1Hz)

  tabuada_b tabuada (
    .clk  (clk),
    .load (load_btn),          // botão ativo em nível baixo
    .i_a  ({4'b0, table_sel}),
    .res  (res),
    .done (done)
  );

  bin2bcd conv (
    .bin(res),
    .bcd(bcd)
  );

  dec7seg display (
    .hex (bcd[3:0]),            // dígito das unidades
    .segs(segs)
  );

  assign seg              = segs;
  assign done_led         = ~done;     // LED ativo em nível baixo
  assign {bcd_h1, bcd_h0} = ~bcd[9:8];

endmodule
