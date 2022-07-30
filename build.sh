#!/usr/bin/env bash

# Display help
help() {
    echo
    echo "See https://wiki.osdev.org/GCC_Cross-Compiler for details on what prefix and target are."
    echo
    echo "Usage:  build.sh <prefix> <target>"
    echo
} 

# Check for help option
if [[ $1 == "-h" || $1 == "--help" ]]; then
    help
    exit
fi

# Set target, path, and prefix.
if [[ $# != 2 ]]; then
    help
    exit
else
    prefix=$1
    target=$2
fi

# Add prefix/bin to path
export PATH="$prefix/bin:$PATH"

# get source code
mkdir $HOME/cross-compiler-src
cd $HOME/cross-compiler-src
wget "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz"
tar xvf "binutils-2.38.tar.gz"
wget "https://ftp.gnu.org/gnu/gcc/gcc-10.4.0/gcc-10.4.0.tar.gz"
tar xvf "gcc-10.4.0.tar.gz"

# ensure gcc is build without redzone
echo "MULTILIB_OPTIONS += mno-red-zone" >> "gcc-10.4.0/gcc/config/i386/t-x86_64-elf"
echo "MULTILIB_DIRNAMES += no-red-zone" >> "gcc-10.4.0/gcc/config/i386/t-x86_64-elf"
# TODO: https://roscopeco.com/2018/11/25/using-gcc-as-cross-compiler-with-x86_64-target/

# binutils build
mkdir build-binutils
cd build-binutils
../binutils-2.38/configure --target=$target --prefix=$prefix --with-sysroot --diable-nls --disable-werror
make
make install

# gcc build
cd $HOME/cross-compiler-src
mkdir build-gcc
cd build-gcc
../gcc-10.4.0-/configure --target=$target --prefix=$prefix --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc




