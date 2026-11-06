#!/bin/bash

# CTR - Crash Team Racing Recomp

GAMEDIR="$HOME/Games/CTR - Crash Team Racing" # Installation's directory

APPIMAGE_ID=$(curl -fsSL https://ctr.cmzi.uk/ |
    grep -oE '"key"[[:space:]]*:[[:space:]]*"appimage"[^}]*"downloadUrl"[[:space:]]*:[[:space:]]*"[^"]+' |
    grep -oE '[0-9]+$')

CTR="CTR - Crash Team Racing (USA) (1999) (Kart Racing) (ISO) (Playstation)"

dir_creation() {

	mkdir -p $HOME/.local/share/icons/
	mkdir -p "$GAMEDIR"
	cd $HOME/.local/share
	ln -s "$GAMEDIR" ctr-turbocharged
	cd "$GAMEDIR"	
}

download_appimage() {

	wget -nc --content-disposition \
	"https://ctr.cmzi.uk/api/download/$APPIMAGE_ID" \
	"https://i.postimg.cc/nMfhW14c/ctr-turbocharged.png" \
	"https://i.postimg.cc/Pr1b2XYT/SCUS-94426.png" \
	"https://dl.dafont.com/dl/?f=crash_a_like"

	chmod a+x *.AppImage
	
	if [ ! -e crash-a-like.ttf ]; then unzip -n crash_a_like.zip; fi
}

download_rom() {

	wget -nc --content-disposition \
	"https://archive.org/download/ctr-crash-team-racing-eu-jp-us-1999-kart-racing-chd-iso-playstation/$CTR.zip"
	
	if [ ! -e /usr/bin/7z ]; then sudo apt install p7zip-full -y; fi
	
	if [ ! -e "$CTR.BIN" ]; then 
		7z e -aos "$CTR.zip" "$CTR/$CTR.iso"		
		mv "$CTR.iso" "$CTR.BIN"
	fi
}

game_config() {

	cp -u ctr-turbocharged.png SCUS-94426.png $HOME/.local/share/icons/
	
	cd $HOME

	# To alternate icon, switch ctr-turbocharged Icon to SCUS-94426	
	cat << EOF > ctr-turbocharged.desktop
[Desktop Entry]
Name=CTR Turbocharged
Comment=Crash Team Racing
Exec=./ctr-turbocharged.sh
Icon=ctr-turbocharged
Terminal=false
Type=Application
Categories=Game;
EOF

	cat << EOF > ctr-turbocharged.sh
#!/bin/bash
cd "$GAMEDIR"
./ctr-turbocharged-turbocharged-*-linux-x86.AppImage
EOF

	chmod a+x ctr-turbocharged.desktop ctr-turbocharged.sh
	mv ctr-turbocharged.desktop $HOME/.local/share/applications	
}

uninstall() {

	rm $HOME/.local/share/applications/ctr-turbocharged.desktop	
	rm $HOME/.local/share/icons/ctr-turbocharged.png
	rm $HOME/.local/share/icons/SCUS-94426.png
	rm $HOME/ctr-turbocharged.sh
	rm $HOME/.local/share/ctr-turbocharged	
}

unecessary_files() {

	cd "$GAMEDIR"
	rm *.BIN *.png *.ttf *.zip
}

unistall_full(){

	cd "$GAMEDIR"
	cd ..
	rm -R CTR
}

main_menu() {

echo "
=================================================
| CTR - Crash Team Racing Turbocharger PC Port  |
=================================================
|						|
| Install Options:				|
|						|
| [1] - Download Rom, AppImage, and Install	|
| [2] - Download AppImage, and Install		|
| [3] - Remove unnecessary files pos install	|
| [4] - Start CTR				|
| [5] - Uninstall				|
| [6] - Uninstall and delete files		|
| [7] - Exit					|
|_______________________________________________|
"
read -p  " Select an option: " OPTION
}

start() {

	cd $HOME
	./ctr-turbocharged.sh
}

while true; do

	main_menu

	case  "$OPTION" in
		1)	
			dir_creation
			download_appimage
			download_rom
			game_config
			;;
		2)	
			dir_creation
			download_appimage
			game_config					
			;;
		3)		
			unecessary_files		
			;;		
		4)		
			start		
			;;		
		5)	
			uninstall		
			;;		
		6)	
			uninstall		
			unistall_full		
			;;		
		7)	
			exit 0
			;;		
		*)
			echo "Invalid option!"
			;;	
	esac
done
