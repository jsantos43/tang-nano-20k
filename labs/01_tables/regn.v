module regn #(parameter N = 8)  (
  input ld, clk, en,
  input [N-1:0] data_l, data_i,
  output reg [N-1:0] data_o);
  always @(posedge clk)
    if (ld) data_o  = data_l;
    else if (en) data_o = data_i;
endmodule
