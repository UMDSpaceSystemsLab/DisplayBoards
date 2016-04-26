#!/bin/bash
# Configuration archive creator for SSL DisplayBoard

becho()  { echo -e "\033[1m ** $@\033[0m"; }
bbecho() { echo -e "\033[1m    -> $@\033[0m"; }
cerr()   { if [ ! "$1" = "0" ];then becho "Previous command exited with code $1. Check output for more details."; exit 1; fi; }

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ARC="resources/kodi-config-enc.tar.7z"

if [ "$#" != "1" ];then
	becho "ERROR: Incorrect number of arguments."
	becho "Usage: $0 [path-to-kodi-data-partition]"
	exit 1
fi

if [ ! -d "$1" ];then
	becho "ERROR: Path '$1' does not exist (or isn't a directory)!"
	exit 1
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

becho "Creating configuration archive..."

bbecho "Removing any old archives..."
[ -f "$ARC" ] && mv "$ARC" "$ARC".old && bbecho "Created backup: kodi-config-enc.tar.7z.old"

bbecho "Entering Kodi data partition directory..."
cd "$1"

bbecho "Creating \033[32mencrypted\033[0m\033[1m configuration archive..."
sleep 3s
tar cf - ".kodi" ".cache" | 7z a -si "$SCRIPT_DIR/$ARC" -mhe -p"$SSL_DISPLAYBOARD_ARC_PASS"

becho "Restoring permissions on configuration archive..."
chown --reference="$0" "$SCRIPT_DIR/$ARC"
chmod --reference="$0" "$SCRIPT_DIR/$ARC"

bbecho "Returning to script directory..."
cd "$SCRIPT_DIR"

becho "Finished creating Kodi configuration archive $ARC."
