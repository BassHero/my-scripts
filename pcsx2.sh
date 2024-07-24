#!/bin/bash

# PCSX2's AppImage installation for Debian Linux and derivatives.
# If necessary, change the lines version and BIOS_link above to latests versions.

# Steps:
	# Install dependecies if missing
	# Download PCSX2 AppImage	
	# Download PCSX2 icon and move to icons directory
	# Creating a Playstation.desktop file to show up on Docker
	# Download PCSX2 Bios, exctract, and put on PCSX2's Bios directory

VERSION=v2.1.26
BIOS_LINK=https://fantasyanime.com/files0219/emulators/pcsx2_bio._ip

# Dependecy needed to extract files

FILE_ROLLER=/usr/bin/file-roller

if [ -e $FILE_ROLLER ]; then
	
	echo "fille-roller dependency has been previously installed"
	
else
	sudo apt install file-roller
	echo "fille-roller was installed"
		
fi

LIBFUSE=/lib/x86_64-linux-gnu/libfuse.so.2

if [ -e $LIBFUSE ]; then
	
	echo "libfuse2 dependency has been previously installed"
	
else
	sudo apt install libfuse2t64
	echo "libfuse2 was installed"
		
fi

# Downloading PCSX2's AppImage and BIOS

PCSX2=https://github.com/PCSX2/pcsx2/releases/download/$VERSION/pcsx2-$VERSION-linux-appimage-x64-Qt.AppImage
EXEC=pcsx2-$VERSION-linux-appimage-x64-Qt.AppImage

cd ~

if [ -e "$EXEC" ]; then

	echo "The latest PCSX2 emulator has been previously downloaded"

else

	wget $PCSX2
	chmod a+x pcsx2-*-linux-appimage-x64-Qt.AppImage
	
fi

# Downloading PCSX2's icon

ICON_DIR=~/.local/share/icons

if [ -d "$ICON_DIR" ]; then

	echo "The icons directory exists"	
	
else
	
	echo "Creating the icon directory"
	mkdir -p $ICON_DIR
	
fi

ICON=$ICON_DIR/pcsx2.png

if [ -e "$ICON" ]; then

	echo "The PCSX2's icon has been previously downloaded"	
	
else

	echo "Downloading the PCSX2's icon"
	wget https://raw.githubusercontent.com/PCSX2/pcsx2/master/bin/resources/icons/AppIconLarge.png
	mv AppIconLarge.png pcsx2.png
	mv pcsx2.png $ICON_DIR
	
fi

# Setting up PCSX2's desktop entries

PCSX2_APP=`echo "$EXEC"`
PCSX2_DESKTOP=~/.local/share/applications/PlayStation_2.desktop

if [ -e "$PCSX2_DESKTOP" ]; then

	echo "The PCSX2's .desktop file exists, editing"
	sed -i "4s,.*,Exec=./$PCSX2_APP,g" $PCSX2_DESKTOP
	

else
	echo "Creating a PCSX2's .desktop file"

	echo "[Desktop Entry]
Name=PlayStation 2
Comment=PCSX2, Emulator
Exec=./$PCSX2_APP
Icon=pcsx2
Terminal=false
Type=Application
Categories=Game;
" > PlayStation_2.desktop

	chmod a+x PlayStation_2.desktop
	mv PlayStation_2.desktop ~/.local/share/applications/

fi
	
echo "PCSX2's .desktop entry is finished"

# Setting PCSX2's config directory

CONFIG_DIR=~/.config/PCSX2/

if [ -d $CONFIG_DIR ]; then

	echo "PCSX2's config directory exists."
	
else

	timeout -k 5 5 ./$PCSX2_APP
	
fi

# Downloading PCSX2's bios

BIOS_ZIP=pcsx2_bio.zip
# Line 7 has a BIOS_LINK
BIOS_DIR=~/.config/PCSX2/bios/
BIOS=~/.config/PCSX2/bios/$BIOS_ZIP

if [ -e "$BIOS" ]; then

	echo "The PCSX2's BIOS file already are in the bios folder"
	
else

	echo "The PCSX2's BIOS file will be downloaded"	
	
	if [ -e $BIOS_ZIP ]; then
		
		echo "The PCSX2's BIOS file has been downloaded previously"
		mv $BIOS_ZIP $BIOS_DIR
		file-roller --extract-to=$BIOS_DIR $BIOS
		echo "The PCSX2's BIOS files was downloaded and the settings is done"		
	
	else
		echo "Downloading the PCSX2's BIOS file"
		wget $BIOS_LINK
		mv pcsx2_bio._ip $BIOS_ZIP
		mv $BIOS_ZIP $BIOS_DIR
		file-roller --extract-to=$BIOS_DIR $BIOS
		echo "The PCSX2's BIOS files was downloaded and the settings is done"
	
	fi	
	
fi
	
./$PCSX2_APP
