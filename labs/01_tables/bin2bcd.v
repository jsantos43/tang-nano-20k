module bin2bcd ( 
  input [7:0] bin,
  output reg [9:0] bcd);

  integer i;

  always @(bin) begin
    bcd = 0;
    for(i = 7; i >= 0; i = i-1)
    begin
       if (bcd[7:4] > 4)
          bcd[7:4] = bcd[7:4] + 3;
       if (bcd[3:0] > 4)
          bcd[3:0] = bcd[3:0] + 3;   
       bcd = {bcd,bin[i]};
    end
  end
endmodule