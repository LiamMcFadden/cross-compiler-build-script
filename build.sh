#!/usr/bin/env bash

# Display help
help() {
    echo
    echo "See https://wiki.osdev.org/GCC_Cross-Compiler for details on what prefix, path, and target are."
    echo
    echo "Usage:  build.sh <prefix> <path> <target>"
    echo
} 

# Check for help option
if [[ $1 == "-h" || $1 == "--help" ]]; then
    help
    exit
fi

# Set target, path, and prefix.
if [[ $# != 3 ]]; then
    help
else
    prefix=$1
    path=$2
    target=$3
fi
