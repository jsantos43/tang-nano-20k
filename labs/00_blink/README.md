# Lab 00 — Blink

Primeiro projeto: LED piscando na Tang Nano 20K.

## Objetivo

Fazer os 3 LEDs onboard ciclarem usando o clock de 27MHz da placa.

## Conceitos

- Clock e divisão de frequência via contador
- Saída digital
- Constraints de pinos (`.cst`)
- Diferença entre SRAM (volátil) e Flash (persistente)

## Como funciona

O clock da placa é 27MHz — ciclos por segundo muito rápidos para enxergar.
Um contador de 24 bits incrementa a cada ciclo. Quando chega em ~12 milhões
(≈ 0,44 segundos), ele reseta e incrementa os LEDs, fazendo-os percorrer
os 8 padrões de 3 bits em sequência.

## Uso

```bash
# Simular
make sim

# Sintetizar e gravar (fluxo open source)
make build-oss
make flash-oss

# Ou com Gowin EDA
make build-gowin   # depois: % source projeto.tcl
make flash
```

## Resultado esperado

Os 3 LEDs percorrem os padrões 000 → 001 → 010 → ... → 111 ciclicamente,
com troca a cada ~0,44 segundos.

> ⚠️ Os LEDs são **ativos em nível baixo** — `0` acende, `1` apaga.
