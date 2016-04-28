#!/bin/bash
# Composite display 16:9 ratio configuration installer for SSL DisplayBoard

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

if [ ! -f "$1/config.txt" ];then
    becho "ERROR: Configuration file config.txt not found in system partition!"
    becho "       Are you sure you specified the correct directory?"
    exit 1
fi

grep "^sdtv_aspect\=" "$1/config.txt" 2>/dev/null >/dev/null

if [ "$?" = "0" ];then
    becho "ERROR: Configuration file config.txt already has configuration for composite ratio!"
    exit 1
fi

becho "Installing composite display 16:9 ratio configuration for RPi1..."

echo "sdtv_aspect=3" >> "$1/config.txt"

becho "Finished installing composite display 16:9 ratio configuration for RPi1."
