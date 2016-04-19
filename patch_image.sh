#!/bin/bash
# Image patcher for SSL DisplayBoard

becho()  { echo -e "\033[1m ** $@\033[0m"; }
bbecho() { echo -e "\033[1m    -> $@\033[0m"; }
cerr()   { if [ ! "$1" = "0" ];then becho "Previous command exited with code $1. Check output for more details."; exit 1; fi; }

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$#" != "1" ];then
	becho "ERROR: Incorrect number of arguments."
	becho "Usage: $0 [image-to-patch]"
	exit 1
fi

if [ ! -f "$1" ];then
	becho "ERROR: File '$1' does not exist!"
	exit 1
fi

if [ ! "`whoami`" = "root" ];then
	becho "You need to be root to use this tool."
	
	sudo_loc=`which sudo`
	if [ "$?" = "0" ];then
		becho "Attempting to log into root with sudo."
		sudo $0 $@
		exit $?
	fi
	
	su_loc=`which su`
	if [ "$?" = "0" ];then
		becho "Attempting to log into root with su."
		su -c "$0 $@"
		exit $?
	fi
	
	becho "ERROR: You must be root to use this tool!"
	exit 1
fi

becho "Setting up environment..."

bbecho "Preparing work directory..."
rm -rf workdir; cerr $?
mkdir -p workdir; cerr $?

bbecho "Entering work directory..."
cd workdir; cerr $?

becho "Extracting image..."
unsquashfs "$SCRIPT_DIR/$1"; cerr $?

becho "Backing up original image..."
mv "$SCRIPT_DIR/$1" "$SCRIPT_DIR/$1.backup"; cerr $?

becho "Entering image directory..."
cd squashfs-root; cerr $?

becho "Patching image..."

## Place any filesystem modifying commands here!
bbecho "Removing systemd version service..."
rm usr/lib/systemd/system/show-version.service; cerr $?
bbecho "Replacing splash screen with SSL one..."
cp "$SCRIPT_DIR/resources/Splash.png" usr/share/kodi/media/Splash.png; cerr $?
cp "$SCRIPT_DIR/resources/Splash.png" usr/share/xbmc/media/Splash.png; cerr $?
## END filesystem modifying commands.

becho "Exiting image directory..."
cd ..; cerr $?

becho "Rebuilding image..."
mksquashfs squashfs-root "$SCRIPT_DIR/$1" -b 1024k -comp lzo; cerr $?

becho "Exiting environment..."
cd ..; cerr $?

becho "Restoring permissions on image file..."
chown --reference="$SCRIPT_DIR/$1.backup" "$SCRIPT_DIR/$1"
chmod --reference="$SCRIPT_DIR/$1.backup" "$SCRIPT_DIR/$1"

becho "Finished patching image '$1'."
becho "Patched directory in workdir/. Delete it if you don't need it."

