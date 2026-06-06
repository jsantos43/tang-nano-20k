# ─────────────────────────────────────────────────────────────
#  Makefile — Tang Nano 20K
#  Uso: make <target> LAB=00_blink
# ─────────────────────────────────────────────────────────────

LAB    ?= 00_blink
TOP    ?= top
OUTPUT  = $(TOP)

DEVICE = GW2AR-LV18QN88C8/I7
FAMILY = GW2A-18C

SRCS   = $(LAB)/$(TOP).v
TBSRC  = $(LAB)/sim/$(TOP)_tb.v

# ── Gowin EDA — variáveis de ambiente (Arch Linux + Wayland) ──
GOWIN_ENV = QT_PLUGIN_PATH=/opt/gowin-eda-edu-ide/plugins/qt \
            LD_LIBRARY_PATH=/opt/gowin-eda-edu-ide/lib \
            QT_QPA_PLATFORM=xcb \
            DISPLAY=:0 \
            LIBGL_ALWAYS_SOFTWARE=1

# ─────────────────────────────────────────────────────────────
#  SIMULAÇÃO
# ─────────────────────────────────────────────────────────────

sim: $(LAB)/sim/sim.out
	vvp $(LAB)/sim/sim.out
	@[ -f $(LAB)/sim/dump.vcd ] && gtkwave $(LAB)/sim/dump.vcd & || echo "Nenhum dump.vcd gerado"

$(LAB)/sim/sim.out: $(SRCS) $(TBSRC)
	iverilog -o $(LAB)/sim/sim.out $(SRCS) $(TBSRC)

# ─────────────────────────────────────────────────────────────
#  FLUXO OPEN SOURCE: yosys → nextpnr → gowin_pack
# ─────────────────────────────────────────────────────────────

build: impl/$(OUTPUT).fs
	@echo "✓ Bitstream: impl/$(OUTPUT).fs"

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
#  FLUXO GOWIN EDA
# ─────────────────────────────────────────────────────────────

build-gowin:
	echo "source projeto.tcl" | $(GOWIN_ENV) LAB=$(LAB) gw_sh

# ─────────────────────────────────────────────────────────────
#  GRAVAÇÃO
# ─────────────────────────────────────────────────────────────

flash: impl/$(OUTPUT).fs
	openFPGALoader -b tangnano20k impl/$(OUTPUT).fs

flash-gowin: impl/pnr/$(OUTPUT).fs
	openFPGALoader -b tangnano20k impl/pnr/$(OUTPUT).fs

flash-persistent:
	openFPGALoader -b tangnano20k --write-flash impl/$(OUTPUT).fs

# ─────────────────────────────────────────────────────────────
#  UTILITÁRIOS
# ─────────────────────────────────────────────────────────────

clean:
	rm -rf impl/ $(LAB)/sim/sim.out $(LAB)/sim/dump.vcd

detect:
	openFPGALoader --detect

help:
	@echo "Uso: make <target> LAB=<pasta>"
	@echo ""
	@echo "  sim              Simula com iverilog + GTKWave"
	@echo "  build            Sintetiza com fluxo open source"
	@echo "  build-gowin      Sintetiza com Gowin EDA"
	@echo "  flash            Grava (volátil) — open source"
	@echo "  flash-gowin      Grava (volátil) — Gowin"
	@echo "  flash-persistent Grava na flash (permanente)"
	@echo "  clean            Remove arquivos gerados"
	@echo "  detect           Detecta FPGA conectada"
	@echo ""
	@echo "Labs disponíveis:"
	@ls -d */ 2>/dev/null | grep -v "impl" | sed 's|/||'

.PHONY: sim build-oss build-gowin flash flash-oss flash-persistent clean detect help
