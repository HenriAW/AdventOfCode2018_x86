# Day 1 solution overview
## Part 1
This is a nice one to start out with! I need to write some functions that do basic operations that will be used in each challenge, so this is a great since that basically covers everything!
My plan for completing this is to:
1. Read the contents of a file into memory given a filepath
2. Loop through the data, line-by-line
3. Convert the ascii string into an int
4. Keep a running total
5. Convert the total to a string
6. Write the string to STDOUT

### Running part 1
Ok, so this took much longer than I thought it would! Lots of the difficulty comes from the lack of helpful error messages (I guess these need to be built in). Testing is also tricky. I'm using gdb which seems very powerful, but it's very new so at the moment I'm pretty clumsy using it. I also got a bit confused with addressing modes which led to many segmentation faults.
However, after a few hours of testing and tinkering, it works! To run the code:
1. Paste your input into a new file (mine is called input.txt)
2. Create the object files using:
```bash
as --32 main.s -o main.o
as --32 ascii_to_int.s -o ascii_to_int.o
as --32 int_to_ascii.s -o int_to_ascii.o
```
3. Link the files using:
```bash
ld -m elf_i386 main.o ascii_to_int.o int_to_ascii.o -o main
```
4. Run `./main input.txt` 
