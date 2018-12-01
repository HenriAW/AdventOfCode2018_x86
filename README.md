# AdventOfCode2018_x86
This is a repository containing solutions to [Advent of Code 2018](https://adventofcode.com/2018) written in x86 assembly language. I'll be learning as I go, so this may take some time!

## Running the code
### Requirements to run code
This code is written to run on a Linux operating system (I'm using Ubuntu 16.04) which I'm running on [Google Cloud Compute](https://cloud.google.com/).
To run the code you'll need to `sudo apt-get install gcc`.

### Compiling the code
Some instructions may not be recognised when using a 64-bit processor, so you may need to add:
- `--32` when creating the object file. i.e. `as --32 file.s -o file.o`
- `-m elf_i386` when linking the object files. i.e. `ld -m elf_i386 file.o -o file`

## Resources
The main book I'm using to learn x86 assembly code is [Programming from the Ground Up](http://programminggroundup.blogspot.com/). As I start this project I've just finished chapter 5.
