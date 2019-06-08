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

export distro_name="Pegasus Linux"
export distro_version="0.1"
export source_distro_url="http://mirrors.163.com/tinycorelinux/9.x/x86/release/Core-current.iso"
export source_distro_iso_file="Core-current.iso"

init() {
        export folder=$(pwd)
        if [ ! -d "$folder/bin" ] ; then 
            mkdir "$folder/bin" 
        fi
}

update_source_iso() {
    if [ ! -f "$folder/bin/$source_distro_iso_file" ] ; then 
        #file exists
        #todo: compare checksum and deside whether to update the iso
        curl "$source_distro_url" --output "$folder/bin/$source_distro_iso_file"
    fi
}

extract_iso(){
    export extracted_folder="$folder/bin/extractedIso"
    if [ ! -f "$folder/bin/$source_distro_iso_file" ] ; then 
        echo "Didn't find the target iso file: $folder/bin/$source_distro_iso_file"
        echo "That may be because there were errors in downloading. Check your internet connection and try again"
    fi
    if [ ! -d "$extracted_folder" ] ; then
        mkdir "$extracted_folder"
    fi
    echo "Extract $folder/bin/$source_distro_iso_file"
    7z x -y -o"$folder/bin/extractedIso"  "$folder/bin/$source_distro_iso_file"
}

create_iso(){
    export new_iso_folder="$folder/bin/newIso"    

    if [ ! -d "$new_iso_folder" ] ; then
        mkdir "$new_iso_folder"
    fi

    mkisofs -r -V "$distro_name" -cache-inodes -J -l -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o $new_iso_folder/pegasus.iso $extracted_folder
}

help() {
        echo "Usage of $distro_name creator:"
        echo "  -h or --help      Print Help (this message) and exit"
        echo "  -v or --version   Print version information and exit"
}

check_environment() {
        if  ! [ -x "$(command -v curl)" ] ;  then query="$query curl " ; fi
        if  ! [ -x "$(command -v 7z)" ] ;  then query="$query p7zip-full " ; fi
        if  ! [ -x "$(command -v mkisofs)" ] ;  then query="$query genisoimage " ; fi

        if [ ! -z "$query" ]; then
		echo -en "Error: missing dependencies: ${query}\n > Install missing dependencies now? [y/N]: "
		read -r input

		case $input in
			y|Y)	sudo apt install -y $query ;;
			*)	echo "Error: missing depends, exiting." ; exit 1 ;;
		esac
        fi
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
    -b | --build )
        init
        check_environment
        update_source_iso
        extract_iso
        create_iso
        exit 0
        ;;
    *) 
        invalid_options
        exit 0
        ;;
 
    esac
    shift
done