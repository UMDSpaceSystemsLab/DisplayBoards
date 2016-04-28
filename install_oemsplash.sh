#!/bin/bash
# Configuration installer for SSL DisplayBoard

becho()  { echo -e "\033[1m ** $@\033[0m"; }
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

becho "Installing OEM splash screen for SSL..."

cp resources/oemsplash.png "$1"; cerr $?
cp resources/SSL.png "$1"; cerr $?

becho "Finished installing OEM splash screen for SSL."
