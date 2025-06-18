#!/bin/bash

# set -e  # Sai ao primeiro erro. Descomente o comando caso queria usar este recurso.
# set -u  # Erro se usar variável não definida. Descomente o comando caso queria usar este recurso.

# ========================
# CONFIGURAÇÕES GERAIS
# ========================

VERSION="v2.5"
FLYCAST_APPIMAGE_URL="https://github.com/flyinghead/flycast/releases/download/$VERSION/flycast-x86_64.AppImage"
FLYCAST_WIN_URL="https://github.com/flyinghead/flycast/releases/download/$VERSION/flycast-win64-2.5.zip"

APPIMAGE_DIR="$HOME/AppImage"
BACKUP_FILE="$HOME/AppImage/flycast_backup.tar.gz"
FLYCAST_DIR="$APPIMAGE_DIR/flycast"
FLYCAST_FILE="flycast-x86_64.AppImage"
FLYCAST_SAVE_DIR="$HOME/.local/share/flycast"
ICON_DIR="$HOME/.local/share/icons"

# ========================
# FUNÇÕES
# ========================

create_desktop_entry() {
    cat <<EOF > "$FLYCAST_DIR/flycast.desktop"
[Desktop Entry]
Name=Flycast
Comment=Flycast Dreamcast Emulator
Exec=$FLYCAST_DIR/$FLYCAST_FILE
Icon=flycast150
Terminal=false
Type=Application
Categories=Game;
EOF

    chmod +x "$FLYCAST_DIR/flycast.desktop"
    mv "$FLYCAST_DIR/flycast.desktop" "$HOME/.local/share/applications/"
    echo "Atalho de desktop criado com sucesso."
}

install_flycast() {
    FLYCAST_URL=https://raw.githubusercontent.com/flyinghead/flycast/refs/heads/master/shell/uwp
    BIOS_URL=https://raw.githubusercontent.com/BatoceraPLUS/Batocera.PLUS-bios/refs/heads/main
    AIR=airlbios.zip
    AW=awbios.zip
    BOOT=dc_boot.bin
    FLASH=dc_flash.bin
    F355=f355bios.zip
    F355DLX=f355dlx.zip
    HOD2=hod2bios.zip
    NAOMI=naomi.zip
    NAOMI2=naomi2.zip
    NAOMIGD=naomigd.zip
    
    mkdir -p "$FLYCAST_DIR"
    cd "$FLYCAST_DIR"

    echo "Baixando Flycast..."
    curl -L -o "$FLYCAST_FILE" "$FLYCAST_APPIMAGE_URL"
    chmod +x "$FLYCAST_FILE"

    create_desktop_entry
    
    mkdir -p "$HOME/.local/share/flycast" && cd "$HOME/.local/share/flycast"
    wget $BIOS_URL/$AIR $BIOS_URL/$AW $BIOS_URL/$BOOT $BIOS_URL/$FLASH $BIOS_URL/$F355 $BIOS_URL/$F355DLX $BIOS_URL/$HOD2 $BIOS_URL/$NAOMI $BIOS_URL/$NAOMI2 $BIOS_URL/$NAOMIGD
    ln -s $BOOT boot.bin && ln -s $FLASH flash.bin    
    mkdir -p "$HOME/.local/share/icons"
    cd "$HOME/.local/share/icons" && wget $FLYCAST_URL/flycast150.png

    echo "Flycast instalado em $FLYCAST_DIR"
}

remove_flycast() {
    echo "Removendo Flycast..."    
    rm -r "$HOME/.config/flycast"
    rm -f "$HOME/.local/share/applications/flycast.desktop"
    rm -r "$HOME/.local/share/flycast"
    rm -f "$HOME/.local/share/icons/flycast150.png"
    rm -f "$HOME/flycast"
    rm -rf "$FLYCAST_DIR"
    
    echo "Flycast removido com sucesso."
}

backup_saves() {    
    cd "$HOME/AppImage/flycast" && mkdir -p .local/share/icons .config
    mv "$HOME/.config/flycast" .config
    mv "$HOME/.local/share/flycast" .local/share
    mv "$HOME/.local/share/icons/flycast150.png" .local/share/icons
    tar -czf "$BACKUP_FILE" -C "$HOME/AppImage" flycast
    echo "Backup criado em $BACKUP_FILE"
}

restore_backup() {    
    if [ ! -f "$BACKUP_FILE" ]; then
        echo "Arquivo de backup não encontrado: $BACKUP_FILE"
        return 1
    fi

    tar -xzf "$BACKUP_FILE" -C "$HOME/AppImage"
    create_desktop_entry
    mkdir -p "$HOME/.config/flycast/"
    cd "$FLYCAST_DIR" && mv .local/share/flycast "$HOME/.local/share" && mv .config/flycast/emu.cfg "$HOME/.config/flycast/emu.cfg" && mv .local/share/icons/flycast150.png "$HOME/.local/share/icons/flycast150.png" && rm -r .config .local    
    
    echo "Backup restaurado com sucesso."
}

show_menu() {
    echo "========== Flycast =========="
    echo "1) Instalar"
    echo "2) Remover"
    echo "3) Fazer backup"
    echo "4) Restaurar backup"
    echo "0) Sair"
    echo "============================="
    read -rp "Escolha uma opção: " opt

    case "$opt" in
        1) install_flycast ;;
        2) remove_flycast ;;
        3) backup_saves ;;
        4) restore_backup ;;
        0) echo "Saindo..."; exit 0 ;;
        *) echo "Opção inválida." ;;
    esac
}

# ========================
# EXECUÇÃO
# ========================
show_menu

