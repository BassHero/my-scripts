#!/bin/bash

# 1. Baixar o Duckstation e o ícone - Link: https://github.com/stenzek/duckstation
# 2. Baixar as BIOS
# 3. Criar um arquivo .desktop
# 4. Mover os arquivos para seus locais corretos

# 1. Baixar o Duckstation

DUCKSTATION=https://github.com/stenzek/duckstation/releases/download/latest/DuckStation-x64.AppImage

DUCK_ICON=https://raw.githubusercontent.com/stenzek/duckstation/refs/heads/master/src/duckstation-qt/resources/icons/duck.png

cd $HOME/Downloads
mkdir duckstation && cd duckstation
wget $DUCKSTATION $DUCK_ICON

# 2. Baixar as BIOS

wget https://ps1emulator.com/SCPH1001.BIN

# 3. Criar um arquivo .desktop

echo "[Desktop Entry]
Name=Duckstation
Comment=Playstation Emulator
Exec=./DuckStation-x64.AppImage
Icon=duck
Terminal=false
Type=Application
Categories=Game;
" > duckstation.desktop

chmod a+x DuckStation-x64.AppImage duckstation.desktop

# 4. Mover os arquivos para seus locais corretos

mkdir -p $HOME/.local/share/duckstation/bios
mkdir -p $HOME/.local/share/icons

mv DuckStation-x64.AppImage $HOME/DuckStation-x64.AppImage
mv duck.png $HOME/.local/share/icons/duck.png
mv duckstation.desktop $HOME/.local/share/applications
mv SCPH1001.BIN $HOME/.local/share/duckstation/bios/SCPH1001.BIN

cd $HOME
./DuckStation-x64.AppImage







