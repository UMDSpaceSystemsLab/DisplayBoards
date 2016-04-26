#!/bin/bash
# Configuration installer for SSL DisplayBoard

becho()  { echo -e "\033[1m ** $@\033[0m"; }
bbecho() { echo -e "\033[1m    -> $@\033[0m"; }
cerr()   { if [ ! "$1" = "0" ];then becho "Previous command exited with code $1. Check output for more details."; exit 1; fi; }

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ARC="resources/kodi-config-enc.tar.7z"
VER="0.1.1"
DL_ARC="https://github.com/UMDSpaceSystemsLab/DisplayBoards/releases/download/v$VER/kodi-config-enc.tar.7z"

if [ "$#" != "1" ];then
	becho "ERROR: Incorrect number of arguments."
	becho "Usage: $0 [path-to-kodi-data-partition]"
	exit 1
fi

if [ ! -d "$1" ];then
	becho "ERROR: Path '$1' does not exist (or isn't a directory)!"
	exit 1
fi

if [ ! -f "$ARC" ];then
    becho "ERROR: Archive $ARC does not exist! Press ENTER to download it."
    becho "(Otherwise, press CTRL-C to exit.)"
    read
    wget --content-disposition -O "$ARC" "$DL_ARC"
fi

if [ -z "$SSL_DISPLAYBOARD_ARC_PASS" ];then
	becho "ERROR: Variable SSL_DISPLAYBOARD_ARC_PASS not set! This is required to lock the archive!"
	exit 1
fi

if [ ! "`whoami`" = "root" ];then
	becho "You need to be root to use this tool."
	
	sudo_loc=`which sudo`
	if [ "$?" = "0" ];then
		becho "Attempting to log into root with sudo."
		sudo -E $0 $@
		exit $?
	fi
	
	su_loc=`which su`
	if [ "$?" = "0" ];then
		becho "Attempting to log into root with su."
		su -p -c "$0 $@"
		exit $?
	fi
	
	becho "ERROR: You must be root to use this tool!"
	exit 1
fi

becho "Installing configuration archive..."

bbecho "Entering Kodi data partition directory..."
cd "$1"

bbecho "Extracting \033[32mencrypted\033[0m\033[1m configuration archive..."
sleep 3s
7z x -so "$SCRIPT_DIR/$ARC" -p"$SSL_DISPLAYBOARD_ARC_PASS" | tar -xv --overwrite -f -

bbecho "Returning to script directory..."
cd "$SCRIPT_DIR"

becho "Finished installing Kodi configuration archive $ARC."
