module tabuada_b ( //comportamental
  input clk, load, 
  input [7:0] i_a,
  output reg [7:0] res, //resultado
  output reg done); //pronto

  reg [7:0] a_reg;

  integer counter = 0; // Deve ir de 0 a 10
  always @(posedge clk) begin
    if (load) begin
      counter <= 0; // Zera quando estiver no modo carregando(load)
      res <= 8'b00000000; // Deve zerar a saída
      a_reg <= i_a; // Zera o registrador
      done <= 0;
    end else begin
      if (counter < 10) begin
        counter <= counter + 1; // Incrementa
        res <= res + a_reg;
      end else begin
        done <= 1;
      end
    end
  end   
endmodule