# Guia de Instalação — Arch Linux

Configuração do ambiente de desenvolvimento para Tang Nano 20K no **Arch Linux com GNOME/Wayland**.

> Para outros distros, os pacotes equivalentes existem mas os nomes diferem.  
> O problema do grupo `plugdev` é específico do Arch (não existe por padrão).

---

## 1. Pacotes necessários

### Gowin EDA (síntese proprietária)
```bash
yay -S gowin-eda
```

### openFPGALoader (gravação)
```bash
sudo pacman -S openfpgaloader
```

### Dependências Qt5 do Gowin EDA
```bash
sudo pacman -S xcb-util-wm xcb-util-image xcb-util-keysyms xcb-util-renderutil
```

### Simulação
```bash
sudo pacman -S iverilog gtkwave
```

### Fluxo open source completo
```bash
sudo pacman -S yosys
yay -S nextpnr-git prjapicula
```

---

## 2. Regras udev (acesso USB sem sudo)

```bash
sudo curl -o /etc/udev/rules.d/99-openfpgaloader.rules \
  https://raw.githubusercontent.com/trabucayre/openFPGALoader/master/99-openfpgaloader.rules

sudo udevadm control --reload-rules
sudo udevadm trigger
```

---

## 3. Grupo plugdev

O Arch Linux não cria o grupo `plugdev` por padrão (diferente do Debian/Ubuntu):

```bash
sudo groupadd plugdev
sudo usermod -aG plugdev $USER
```

Faça logout e login para o grupo entrar em vigor. Verifique:

```bash
groups $USER   # deve incluir plugdev
```

---

## 4. Alias para o gw_sh (Arch Linux + GNOME Wayland)

O `gw_sh` usa Qt5 internamente e requer variáveis de ambiente específicas para funcionar
no Wayland. Adicione ao seu `~/.zshrc` ou `~/.bashrc`:

```bash
alias gw_sh='QT_PLUGIN_PATH=/opt/gowin-eda-edu-ide/plugins/qt \
  LD_LIBRARY_PATH=/opt/gowin-eda-edu-ide/lib \
  QT_QPA_PLATFORM=xcb \
  DISPLAY=:0 \
  LIBGL_ALWAYS_SOFTWARE=1 \
  gw_sh'
```

```bash
source ~/.zshrc
```

> **Por quê isso é necessário?**  
> Ver [troubleshooting.md](troubleshooting.md) para a explicação completa.

---

## 5. Licença do Gowin EDA

O Gowin EDA requer uma licença gratuita para funcionar:

1. Cadastre em: https://www.gowinsemi.com/en/support/license/
2. Eles enviam um arquivo `.lic` por e-mail
3. Coloque em `~/.gowin/gowin.lic` e exporte:

```bash
export LM_LICENSE_FILE=~/.gowin/gowin.lic
```

Adicione essa linha ao seu `~/.zshrc` para persistir.

---

## 6. Verificação da instalação

```bash
# Gowin EDA
gw_sh   # deve abrir o prompt interativo %

# openFPGALoader (com a placa conectada)
openFPGALoader --detect

# Yosys
yosys --version

# nextpnr
nextpnr-himbaechel --version

# Simulação
iverilog -V
gtkwave --version
```
