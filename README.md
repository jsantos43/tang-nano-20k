# Tang Nano 20K — Ambiente de Desenvolvimento

Repositório de laboratórios para a FPGA **Sipeed Tang Nano 20K** (chip Gowin GW2AR-18C) no Linux, usando linha de comando.

## Hardware

| Item | Detalhe |
|---|---|
| Placa | Sipeed Tang Nano 20K |
| Chip | Gowin GW2AR-LV18QN88C8/I7 (GW2AR-18C) |
| Clock onboard | 27 MHz (pino 4) |
| LEDs onboard | 3 LEDs ativos em nível baixo (pinos 15, 16, 17) |

- 📌 [Pinout completo](docs/pinout.md)
- 🛠️ [Guia de instalação](docs/setup.md)
- 🐛 [Troubleshooting](docs/troubleshooting.md)

## Fluxos de desenvolvimento

| Fluxo | Ferramentas | Quando usar |
|---|---|---|
| Open Source | yosys + nextpnr + gowin_pack | Maioria dos projetos |
| Gowin EDA | gw_sh | Recursos avançados (BRAM, DSP, PLL) |

## Estrutura

```
labs/
├── Makefile          ← compartilhado por todos os labs
├── projeto.tcl       ← fluxo Gowin EDA
├── constraints.cst   ← pinos da placa
└── 00_blink/         ← cada lab em sua pasta
    ├── README.md
    ├── top.v
    └── sim/top_tb.v
```

## Uso

```bash
cd labs/

make sim          LAB=00_blink   # simula com iverilog + GTKWave
make build        LAB=00_blink   # sintetiza (open source)
make flash        LAB=00_blink   # grava na FPGA (volátil)
make build-gowin  LAB=00_blink   # sintetiza (Gowin EDA)
make flash-gowin  LAB=00_blink   # grava na FPGA (volátil)
make help                        # lista todos os comandos
```

## Laboratórios

| Lab | Descrição | Conceitos |
|---|---|---|
| [00_blink](labs/00_blink/) | LED piscando | Clock, contador, saída digital |