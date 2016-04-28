#!/bin/bash
# Patched image installer for SSL DisplayBoard

becho()  { echo -e "\033[1m -- $@\033[0m"; }
bbecho() { echo -e "\033[1m    -> $@\033[0m"; }
cerr()   { if [ ! "$1" = "0" ];then becho "Previous command exited with code $1. Check output for more details."; exit 1; fi; }

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$#" != "1" ];then
	becho "ERROR: Incorrect number of arguments."
	becho "Usage: $0 [path-to-kodi-system-partition]"
	exit 1
fi

if [ ! -d "$1" ];then
	becho "ERROR: Path '$1' does not exist (or isn't a directory)!"
	exit 1
fi

if [ ! -f "$1/SYSTEM" ];then
	becho "ERROR: Path '$1' does not seem to be the system partition!"
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

becho "Cleaning up any old files..."
rm -f SYSTEM SYSTEM.backup; cerr $?

becho "Copying original system image..."
cp "$1/SYSTEM" .; cerr $?

becho "Patching image..."
"$SCRIPT_DIR/patch_image.sh" SYSTEM; cerr $?

becho "Installing patched image..."
cp "SYSTEM" "$1/SYSTEM"; cerr $?

becho "Finished installing patched system image for SSL."
