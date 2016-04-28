#!/bin/bash
# Custom commands for SSL DisplayBoard
# -------------------------------------
# You can put custom commands for your own local setup here!
# 
# $1 will have the system partition directory, and $2 will have the
# data partition directory.
# 
# You can add your commands in the custom section below.
# 
# If you need to request root (especially if you're writing into the
# data partition), set the option accordingly within the config
# section.

## START: Config section

# REQUIRE_ROOT - whether we need root to run this script or not.
# If 1, elevate permissions. If not, don't do anything.
REQUIRE_ROOT=1

## END: Config section

## START: Bootstrap section
## DO NOT CHANGE ANYTHING IN THIS SECTION
becho()  { echo -e "\033[1m ++ $@\033[0m"; }
bbecho() { echo -e "\033[1m    -> $@\033[0m"; }
cerr()   { if [ ! "$1" = "0" ];then becho "Previous command exited with code $1. Check output for more details."; exit 1; fi; }

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$#" != "2" ];then
	becho "ERROR: Incorrect number of arguments."
	becho "Usage: $0 [path-to-kodi-system-partition] [path-to-kodi-data-partition]"
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

if [ "$REQUIRE_ROOT" = "1" ];then
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
fi

## END: Bootstrap section

## START: Custom section
## Add your own scripts here!

## END: Custom section
## Add your own scripts here!
