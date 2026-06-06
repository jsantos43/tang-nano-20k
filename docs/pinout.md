# Pinout — Tang Nano 20K

Referência de pinos da Sipeed Tang Nano 20K (GW2AR-LV18QN88C8/I7).

Fonte oficial: https://wiki.sipeed.com/hardware/en/tang/tang-nano-20k/nano-20k.html

---

## Recursos onboard

| Recurso | Pino | Banco | VCCIO | IO_TYPE |
|---|---|---|---|---|
| Clock 27MHz | 4 | 7 | 3.3V | LVCMOS33 |
| LED 0 (vermelho) | 15 | 6 | 3.3V | LVCMOS33 |
| LED 1 (verde) | 16 | 6 | 3.3V | LVCMOS33 |
| LED 2 (azul) | 17 | 6 | 3.3V | LVCMOS33 |
| Botão S1 | 88 | 3 | 3.3V | LVCMOS33 |
| Botão S2 | 87 | 3 | 3.3V | LVCMOS33 |
| UART TX | 17 | — | — | LVCMOS33 |
| UART RX | 18 | — | — | LVCMOS33 |
| HDMI CLK+ | 69 | — | — | LVCMOS33D |
| HDMI CLK- | 68 | — | — | LVCMOS33D |

> ⚠️ **LEDs são ativos em nível baixo** — `led = 0` acende, `led = 1` apaga.  
> Use `PULL_MODE=UP` nos pinos de LED.

---

## Bancos de IO e tensões

| Banco | VCCIO | IO_TYPE padrão |
|---|---|---|
| 0 | 3.3V | LVCMOS33 |
| 1 | 3.3V | LVCMOS33 |
| 2 | 3.3V | LVCMOS33 |
| 3 | 3.3V | LVCMOS33 |
| 4 | 1.8V | LVCMOS18 |
| 5 | 1.8V | LVCMOS18 |
| 6 | 3.3V | LVCMOS33 |
| 7 | 3.3V | LVCMOS33 |

---

## Template de constraints (.cst)

```
# Clock
IO_LOC "clk" 4;
IO_PORT "clk" IO_TYPE=LVCMOS33;
CLOCK_LOC "clk" BUFG;

# LEDs onboard (ativos em nível baixo)
IO_LOC "led[0]" 15;
IO_LOC "led[1]" 16;
IO_LOC "led[2]" 17;
IO_PORT "led[0]" IO_TYPE=LVCMOS33 PULL_MODE=UP;
IO_PORT "led[1]" IO_TYPE=LVCMOS33 PULL_MODE=UP;
IO_PORT "led[2]" IO_TYPE=LVCMOS33 PULL_MODE=UP;

# Botões onboard
IO_LOC "btn[0]" 88;
IO_LOC "btn[1]" 87;
IO_PORT "btn[0]" IO_TYPE=LVCMOS33 PULL_MODE=UP;
IO_PORT "btn[1]" IO_TYPE=LVCMOS33 PULL_MODE=UP;
```
