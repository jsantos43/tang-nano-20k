// top.v — módulo principal
// Tang Nano 20K — clock 27MHz, LEDs ativos em nível baixo

module top (
    input  wire        clk,
    output wire [2:0]  led
);

    // Insira sua lógica aqui
    assign led = 3'b111; // todos apagados (nível alto = apagado)

endmodule
