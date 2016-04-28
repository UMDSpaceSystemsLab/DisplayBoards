#!/bin/bash
# Super installer for SSL DisplayBoard

becho()  { echo -e "\033[1m == $@\033[0m"; }
bbecho() { echo -e "\033[1m    -> $@\033[0m"; }
cerr()   { if [ ! "$1" = "0" ];then becho "Previous command exited with code $1. Check output for more details."; exit 1; fi; }

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$#" != "2" ] && [ "$#" != "3" ];then
	becho "ERROR: Incorrect number of arguments."
	becho "Usage: $0 [path-to-kodi-system-partition] [path-to-kodi-data-partition] [-c|-w]"
    becho "    -c | --composite       Force composite video output for RPi."
    becho "                           You may also set ENABLE_COMPOSITE=1 to enable"
    becho "                           this option."
    becho "    -w | --composite169    Force 16:9 composite video output for RPi."
    becho "                           You may also set ENABLE_COMPOSITE=2 to enable"
    becho "                           this option."
	exit 1
fi

if [ ! -d "$1" ];then
	becho "ERROR: Path '$1' does not exist (or isn't a directory)!"
	exit 1
fi

if [ ! -d "$2" ];then
	becho "ERROR: Path '$2' does not exist (or isn't a directory)!"
	exit 1
fi

if [ ! -f "$1/SYSTEM" ];then
	becho "ERROR: Path '$1' does not seem to be the system partition!"
	exit 1
fi

if [ -z ${ENABLE_COMPOSITE+x} ]; then
    if [ "$#" = "3" ]; then
        if [ "$3" = "-c" ];then
            becho "Enabling composite for RPi."
            ENABLE_COMPOSITE=1
        elif [ "$3" = "-w" ];then
            becho "Enabling 16:9 composite for RPi."
            ENABLE_COMPOSITE=2
        else
            becho "Not enabling composite for RPi."
            ENABLE_COMPOSITE=0
        fi
    fi
else
    becho "Using environment ENABLE_COMPOSITE = $ENABLE_COMPOSITE."
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

becho "Step 1: Configuration archive"
"$SCRIPT_DIR/install_config_archive.sh" "$2"; cerr $?

becho "Step 2: Patch system image"
"$SCRIPT_DIR/install_patched_image.sh" "$1"; cerr $?

becho "Step 3: Install boot splash"
"$SCRIPT_DIR/install_oemsplash.sh" "$1"; cerr $?

if [ "$ENABLE_COMPOSITE" = "1" ] || [ "$ENABLE_COMPOSITE" = "2" ]; then
    becho "Step 4: Enable composite video output"
    "$SCRIPT_DIR/install_display_config_rpi1.sh" "$1"; cerr $?
    
    if [ "$ENABLE_COMPOSITE" = "2" ]; then
        becho "Step 5: Enable 16:9 aspect ratio for composite video output"
        "$SCRIPT_DIR/install_display_config_rpi1_ratio169.sh" "$1"; cerr $?
    fi
fi

if [ -f "$SCRIPT_DIR/post_install.sh" ]; then
    "$SCRIPT_DIR/post_install.sh" "$1" "$2"; cerr $?
fi

becho "Unmounting system partition..."
umount "$1"

becho "Unmounting data partition..."
umount "$2"

becho "All done! You can safely remove your SD card and boot it!"
