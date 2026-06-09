module dec7seg (
  input  [3:0] hex,
  output reg [6:0] segs);
  always @(hex)        // gfedcba
    case (hex)         // 6543210
      4'b0000 : segs = 7'b0111111; // 0
      4'b0001 : segs = 7'b0000110; // 1
      4'b0010 : segs = 7'b1011011; // 2
      4'b0011 : segs = 7'b1001111; // 3
      4'b0100 : segs = 7'b1100110; // 4
      4'b0101 : segs = 7'b1101101; // 5
      4'b0110 : segs = 7'b1111101; // 6
      4'b0111 : segs = 7'b0000111; // 7
      4'b1000 : segs = 7'b1111111; // 8
      4'b1001 : segs = 7'b1101111; // 9
      default : segs = 7'b1000000; // -
    endcase
endmodule