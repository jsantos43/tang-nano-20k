# Troubleshooting — Gowin EDA no Arch Linux + Wayland

Diagnóstico e soluções dos problemas encontrados durante a configuração do Gowin EDA
no Arch Linux com GNOME rodando Wayland.

---

## Problema 1: grupo `plugdev` inexistente

**Erro:**
```
usermod: group 'plugdev' does not exist
```

**Causa:** O Arch Linux não cria o grupo `plugdev` por padrão — isso é uma convenção Debian/Ubuntu.

**Solução:**
```bash
sudo groupadd plugdev
sudo usermod -aG plugdev $USER
# Fazer logout e login
```

---

## Problema 2: Plugin Qt xcb não carrega

**Erro:**
```
qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.
Available platform plugins are: eglfs, linuxfb, minimal, ...
```

**Causa:** O `QT_PLUGIN_PATH` não estava apontando para os plugins Qt bundlados pelo Gowin EDA.
Os plugins ficam em `/opt/gowin-eda-edu-ide/plugins/qt/`, não no caminho padrão do sistema.

**Solução:**
```bash
export QT_PLUGIN_PATH=/opt/gowin-eda-edu-ide/plugins/qt
```

---

## Problema 3: `libQt5*.so` not found

**Erro:**
```
ldd: libQt5Gui.so.5 => not found
ldd: libQt5Core.so.5 => not found
```

**Causa:** As libs Qt bundladas do Gowin EDA ficam em `/opt/gowin-eda-edu-ide/lib/` e não
estão no `LD_LIBRARY_PATH` padrão.

**Solução:**
```bash
export LD_LIBRARY_PATH=/opt/gowin-eda-edu-ide/lib
```

---

## Problema 4: `libxcb-icccm` not found (nome errado no Arch)

**Erro:**
```
error: target not found: xcb-util-icccm
```

**Causa:** No Arch Linux o pacote se chama `xcb-util-wm`, não `xcb-util-icccm` (nome Debian).

**Solução:**
```bash
sudo pacman -S xcb-util-wm xcb-util-image xcb-util-keysyms xcb-util-renderutil
```

---

## Problema 5: `Could not initialize GLX` (crash)

**Erro:**
```
qt.glx: qglx_findConfig: Failed to finding matching FBConfig for QSurfaceFormat(...)
Could not initialize GLX
[1] abort (core dumped)
```

**Causa:** O binário `gw_sh` foi compilado com uma versão do Qt5 que inicializa o subsistema
GLX (OpenGL via X11) antes de carregar o plugin de plataforma. Em sessões Wayland puras, não
há servidor X11 disponível para GLX.

**Solução:** Usar o Xwayland (que o GNOME expõe automaticamente em `:0`) com software rendering:

```bash
QT_PLUGIN_PATH=/opt/gowin-eda-edu-ide/plugins/qt \
LD_LIBRARY_PATH=/opt/gowin-eda-edu-ide/lib \
QT_QPA_PLATFORM=xcb \
DISPLAY=:0 \
LIBGL_ALWAYS_SOFTWARE=1 \
gw_sh
```

O `LIBGL_ALWAYS_SOFTWARE=1` força o Mesa a usar software rendering em vez de tentar
GLX de hardware. O aviso `QXcbIntegration: Cannot create platform OpenGL context` que
ainda aparece é inofensivo — o `gw_sh` não usa OpenGL para síntese.

---

## Problema 6: argumento `-run` ignorado

**Sintoma:** `gw_sh -run projeto.tcl` cai no prompt interativo `%` em vez de executar o arquivo.

**Causa:** O binário parece ignorar o argumento `-run` quando encontra problemas de
inicialização Qt, caindo no REPL Tcl interativo.

**Solução:** Usar o comando `source` dentro do prompt:
```
% source projeto.tcl
```

---

## Problema 7: `CT1136` — conflito de VCCIO

**Erro:**
```
ERROR (CT1136): Bank 7 vccio(3.3) is locked by other constraint or embedded port,
  conflicting BANK_VCCIO set by 'clk_ibuf': IO_TYPE = LVCMOS18 in the same bank
```

**Causa:** Os bancos 6 e 7 da Tang Nano 20K operam fisicamente em 3.3V. O netlist gerado
pela síntese já trava esses bancos em 3.3V internamente. Usar `LVCMOS18` entra em conflito.

**Solução:** Usar `LVCMOS33` no `.cst` para pinos dos bancos 6 e 7:
```
IO_PORT "clk" IO_TYPE=LVCMOS33;
IO_PORT "led[0]" IO_TYPE=LVCMOS33 PULL_MODE=UP;
```

---

## Warnings conhecidos (não críticos)

| Warning | Explicação |
|---|---|
| `Ignoring XDG_SESSION_TYPE=wayland` | Aviso informativo do Qt5. Inofensivo. |
| `QXcbIntegration: Cannot create platform OpenGL context` | gw_sh não usa OpenGL para síntese. Inofensivo. |
| `EX3791: Expression size truncated` | Overflow intencional em contadores. Esperado. |
| `TA1132: clk not created as clock` | Adicionar `CLOCK_LOC "clk" BUFG;` no `.cst` resolve. |
| `PR1014: Generic routing for clock` | Consequência do TA1132. Inofensivo em projetos simples. |
