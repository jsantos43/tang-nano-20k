# ─────────────────────────────────────────────────────────────
#  Makefile — Tang Nano 20K
#  Suporta dois fluxos: Gowin EDA (proprietário) e Open Source
# ─────────────────────────────────────────────────────────────

# Nome do módulo top e do projeto
TOP    = top
OUTPUT = $(TOP)

# Device — Tang Nano 20K
DEVICE = GW2AR-LV18QN88C8/I7
FAMILY = GW2A-18C

# Arquivos fonte (adicione mais com espaço)
SRCS = src/$(TOP).v

# ── Gowin EDA — variáveis de ambiente (Arch Linux + Wayland) ──
# Ver docs/troubleshooting.md para explicação
GOWIN_ENV = QT_PLUGIN_PATH=/opt/gowin-eda-edu-ide/plugins/qt \
            LD_LIBRARY_PATH=/opt/gowin-eda-edu-ide/lib \
            QT_QPA_PLATFORM=xcb \
            DISPLAY=:0 \
            LIBGL_ALWAYS_SOFTWARE=1

# ─────────────────────────────────────────────────────────────
#  SIMULAÇÃO
# ─────────────────────────────────────────────────────────────

sim: sim/sim.out
	vvp sim/sim.out
	@[ -f sim/dump.vcd ] && gtkwave sim/dump.vcd & || echo "Nenhum dump.vcd gerado"

sim/sim.out: $(SRCS) sim/$(TOP)_tb.v
	@mkdir -p sim
	iverilog -o sim/sim.out $(SRCS) sim/$(TOP)_tb.v

# ─────────────────────────────────────────────────────────────
#  FLUXO OPEN SOURCE: yosys → nextpnr → gowin_pack
# ─────────────────────────────────────────────────────────────

build-oss: impl/$(OUTPUT).fs
	@echo "✓ Bitstream gerado: impl/$(OUTPUT).fs"

impl/:
	mkdir -p impl

impl/$(OUTPUT).json: $(SRCS) | impl/
	yosys -p "synth_gowin -top $(TOP) -json impl/$(OUTPUT).json" $(SRCS)

impl/$(OUTPUT).pnr.json: impl/$(OUTPUT).json constraints.cst
	nextpnr-himbaechel \
		--device $(DEVICE) \
		--json impl/$(OUTPUT).json \
		--write impl/$(OUTPUT).pnr.json \
		--vopt family=$(FAMILY) \
		--vopt cst=constraints.cst

impl/$(OUTPUT).fs: impl/$(OUTPUT).pnr.json
	gowin_pack -d $(FAMILY) -o impl/$(OUTPUT).fs impl/$(OUTPUT).pnr.json

# ─────────────────────────────────────────────────────────────
#  FLUXO GOWIN EDA: gw_sh (síntese + P&R + bitstream)
# ─────────────────────────────────────────────────────────────

build-gowin:
	$(GOWIN_ENV) gw_sh -run projeto.tcl

# ─────────────────────────────────────────────────────────────
#  GRAVAÇÃO
# ─────────────────────────────────────────────────────────────

# Fluxo open source — SRAM (volátil, para testes)
flash-oss: impl/$(OUTPUT).fs
	openFPGALoader -b tangnano20k impl/$(OUTPUT).fs

# Fluxo Gowin — SRAM (volátil, para testes)
flash: impl/pnr/$(OUTPUT).fs
	openFPGALoader -b tangnano20k impl/pnr/$(OUTPUT).fs

# Flash persistente (não desgaste desnecessariamente)
flash-persistent: impl/$(OUTPUT).fs
	openFPGALoader -b tangnano20k --write-flash impl/$(OUTPUT).fs

flash-gowin-persistent: impl/pnr/$(OUTPUT).fs
	openFPGALoader -b tangnano20k --write-flash impl/pnr/$(OUTPUT).fs

# ─────────────────────────────────────────────────────────────
#  UTILITÁRIOS
# ─────────────────────────────────────────────────────────────

clean:
	rm -rf impl/ sim/sim.out sim/dump.vcd

# Detecta a FPGA conectada
detect:
	openFPGALoader --detect

.PHONY: sim build-oss build-gowin flash flash-oss flash-persistent flash-gowin-persistent clean detect
