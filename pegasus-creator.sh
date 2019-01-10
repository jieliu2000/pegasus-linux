#!/bin/bash
###############################################################
### Pegasus Linux creator Script
### pegasus-creator.sh
###
### Copyright (C) 2018 Jie Liu
###
### By: Jie Liu (jieliu2000)
### Email: jieliu2000@live.com
###
###
### License: Apache License v2.0
###############################################################

export distro_name="Pegasus"
export distro_version="0.1"


init() {
        export folder = $(pwd)
        export mint_type
}

help() {
        echo "Usage of $distro_name creator:"
        echo "  -h or --help      Print Help (this message) and exit"
        echo "  -v or --version   Print version information and exit"
}

check_environment() {
        if  ! [ -x "$(command -v wget)" ] ;  then query="$query wget " ; fi
        if  ! [ -x "$(command -v 7z)" ] ;  then query="$query p7zip-full " ; fi

        if [ ! -z "$query" ]; then
		echo -en "Error: missing dependencies: ${query}\n > Install missing dependencies now? [y/N]: "
		read -r input

		case $input in
			y|Y)	sudo apt install -y $query ;;
			*)	echo "Error: missing depends, exiting." ; exit 1 ;;
		esac
        fi
}

download_linuxmint(){

}

show_version() {
        echo "$distro_version"
}

invalid_options() {
        echo "Missing or invalid options!"
        echo "(run $0 -h for help)"
        echo ""
}

if [ $# -eq 0 ]
then
        invalid_options
        exit 0        
fi

while [ -n "$1" ]; do # while loop starts
 
    case "$1" in
 
    -h | --help) 
        help
        exit 0
        ;;
 
    -c) 
        check_environment
        exit 0
        ;;
 
    -v | --version ) 
        show_version
        exit 0
        ;;
 
    *) 
        invalid_options
        exit 0
        ;;
 
    esac
    shift
done