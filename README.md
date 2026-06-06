# Tang Nano 20K — Ambiente de Desenvolvimento

Repositório de laboratórios e referências para desenvolvimento na FPGA **Sipeed Tang Nano 20K** (chip Gowin GW2AR-18C) no Linux, usando linha de comando.

## Hardware

| Item | Detalhe |
|---|---|
| Placa | Sipeed Tang Nano 20K |
| Chip | Gowin GW2AR-LV18QN88C8/I7 (GW2AR-18C) |
| Clock onboard | 27 MHz (pino 4) |
| LEDs onboard | 3 LEDs ativos em nível baixo (pinos 15, 16, 17) |
| Banco 6 (LEDs) | VCCIO = 3.3V → usar `LVCMOS33` |
| Banco 7 (Clock) | VCCIO = 3.3V → usar `LVCMOS33` |

- 📌 [Pinout completo](docs/pinout.md)
- 🛠️ [Guia de instalação do ambiente](docs/setup.md)
- 📋 [Relatório técnico de configuração](docs/troubleshooting.md)

## Fluxos de desenvolvimento

### Fluxo Gowin EDA (proprietário, recomendado para recursos avançados)
```
Verilog → gw_sh (síntese + P&R + bitstream) → openFPGALoader
```

### Fluxo Open Source
```
Verilog → yosys → nextpnr-himbaechel → gowin_pack → openFPGALoader
```

## Laboratórios

| Lab | Descrição | Conceitos |
|---|---|---|
| [lab00](labs/lab00-blink/) | Blink — LED piscando | Clock, contador, saída digital |

## Uso rápido

```bash
# Copia o template para um novo projeto
cp -r template/ labs/lab01-meu-projeto
cd labs/lab01-meu-projeto

# Edita top.v e constraints.cst
# Depois:

make sim          # simula com iverilog + GTKWave
make build-oss    # sintetiza com fluxo open source
make build-gowin  # sintetiza com Gowin EDA
make flash-oss    # grava (volátil) — fluxo open source
make flash        # grava (volátil) — fluxo Gowin
```
