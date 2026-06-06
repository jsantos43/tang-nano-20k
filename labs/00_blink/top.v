// top.v — Lab 00: Blink
// Tang Nano 20K — clock 27MHz
// LEDs ativos em nível baixo (0 = aceso, 1 = apagado)

module top (
    input  wire        clk,
    output reg  [2:0]  led
);

    reg [23:0] counter;

    always @(posedge clk) begin
        if (counter == 24'd12_000_000) begin
            counter <= 0;
            led     <= led + 1;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule
