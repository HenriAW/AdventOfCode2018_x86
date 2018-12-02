.include "linux.s"

# This program will:
#   - Read the contents of the file supplied as an argument
#   - Read this file line-by-line
#   - For each line, calculate the "value" by calling ascii_to_int
#   - Add this value to a total
#   - Print out the total
#
# Method:
#   1. The file descriptor for the input file will be found
# read_next_section:
#   2. A section of the input file will be read into the INPUT_SECTION buffer
#   3. If we've reached the end of the file, we'll jump to output_results
# read_next_char:
#   4. Read a char from INPUT_SECTION and copy to CURRENT_LINE buffer
#   5. If we get to the end of the INPUT_SECTION buffer, jump to read_next_section
#   6. If a newline is found whilst doing the step, jump to process_line
# process_line:
#   7. Call the ascii_to_int function on the current line
#   8. Add the result to the total
#   9. Reset pointer for CURRENT_LINE
#   10. Jump to read_next_char
# output_results:
#   11. Close the input file
#   12. Call print_int to output total
#   13. Call print_newline
#   14. End the function
#
# Use of registers:
#   %edi - track position in CURRENT_LINE
#   %esi - track position in INPUT_SECTION
#   %cl  - current char being processed

.section .data

# Constants
.equ NEWLINE, '\n'
.equ O_RDONLY, 0
.equ END_OF_FILE, 0

.section .bss
.equ INPUT_SECTION_SZ, 20
.lcomm INPUT_SECTION, INPUT_SECTION_SZ

.equ MAX_LINE_LENGTH, 100
.lcomm CURRENT_LINE, MAX_LINE_LENGTH

.section .text

# Stack positions
.equ ST_SIZE_RESERVE, 16    # Number of bytes to reserver for local vars
.equ SECTION_IDX, -16
.equ RUNNING_TOTAL, -12
.equ READ_SIZE, -8          # The number of characters read from input file
.equ INPUT_FILE, -4         # The file descriptior for the input file
.equ ST_ARGC, 0             # The number of args
.equ ST_ARGV_0, 4           # The name of the programme
.equ ST_ARGV_1, 8           # The name of the input file

.global _start
_start:
 # Prepare the Stack
 movl %esp, %ebp
 subl $ST_SIZE_RESERVE, %esp

open_input_file:
 movl $SYS_OPEN, %eax
 movl ST_ARGV_1(%ebp), %ebx
 movl $O_RDONLY, %ecx
 movl $0666, %edx
 int $LINUX_SYSCALL
 movl %eax, INPUT_FILE(%ebp)    # Store the file descriptor

# Setup variables
 movl $0, %edi
 movl $0, RUNNING_TOTAL(%ebx)

read_next_section:
 # Setup loop variables
 movl $0, %esi

 # Read section from input file
 movl $SYS_READ, %eax
 movl INPUT_FILE(%ebp), %ebx
 movl $INPUT_SECTION, %ecx
 movl $INPUT_SECTION_SZ, %edx
 int $LINUX_SYSCALL             # Result stored in %eax

 cmpl $END_OF_FILE, %eax
 jle output_results             # End if read all of input file
 movl %eax, READ_SIZE(%ebp)     # Store the size of the read

read_next_char:
 # Check if end of section reached
 cmpl READ_SIZE(%ebp), %esi
 je read_next_section

 # Get next char
 movb INPUT_SECTION(,%esi, 1), %cl
 incl %esi
 cmpb $NEWLINE, %cl
 je process_line

 # Copy the char to the CURRENT_LINE buffer
 movb %cl, CURRENT_LINE(,%edi, 1)
 incl %edi
 jmp read_next_char

process_line:
 movl %esi, SECTION_IDX(%ebp)    # Store current value of %esi
 # Call ascii_to_int
 # Push function parameters in reverse order
 pushl %edi
 pushl $CURRENT_LINE            # Pointer to CURRENT_LINE
 call ascii_to_int
 addl $8, %esp                  # Move the stack pointer back

 # Add result to RUNNING_TOTAL
 movl RUNNING_TOTAL(%ebp), %ebx
 addl %ebx, %eax
 movl %eax, RUNNING_TOTAL(%ebp)

 # Reset variables
 movl $0, %edi
 jmp read_next_char

output_results:
 # Call print_int function
 # Call print_newline function

end:
 movl $SYS_EXIT, %eax
 movl RUNNING_TOTAL(%ebp), %ebx
 int $LINUX_SYSCALL
