# AdventOfCode2018_x86
Repository containing solutions to Advent of Code 2018 written in x86 assembly language. I'll be learning as I go, so this may yake some time!

# Requirements to run code
This code is written to run on Linux (I'm using Ubuntu 2016).
To run the code you'll need to `sudo apt-get install gcc`.

# Compiling the code
Some instructions may not be recognised when using a 64-bit processor, therefore, you may need to add:
- `--32` when creating the object file. i.e. `as --32 file.s -o file.o`
- `-m elf_i386` when linking the object files. i.e. `ld -m elf_i386 file.o -o file`
