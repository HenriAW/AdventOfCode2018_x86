.include "linux.s"

# This function will write a file to STDOUT

.section .data

# Constanct
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

# Data
newline:
 .ascii "\n"
 .equ END_OF_FILE, 0
 .equ NUMBER_ARGUMENTS, 1

.section .bss

# The buffer used to read from the text file
 .equ BUFFER_SIZE, 500
 .lcomm BUFFER_DATA, BUFFER_SIZE

 .equ MAX_LINE_LENGTH, 100
 .lcomm CURRENT_LINE, MAX_LINE_LENGTH


.section .text

# Stack Positions
.equ ST_SIZE_RESERVE, 12 # Number of bytes to reserve on the
			# stack for local variables
.equ RUNNING_TOTAL, -12
.equ READ_SIZE, -8
.equ INPUT_FILE, -4
.equ ST_ARGC, 0		# Number of args
.equ ST_ARGV_0, 4	# Name of program
.equ ST_ARGV_1, 8	# Name of input file 

.global _start
_start:
 # Prepare the stack
 movl %esp, %ebp
 subl $ST_SIZE_RESERVE, %esp

open_fd_in:
# Open input file - linux system call
 movl $SYS_OPEN, %eax
 movl ST_ARGV_1(%ebp), %ebx
 movl $O_RDONLY, %ecx
 movl $0666, %edx
 int $LINUX_SYSCALL
 movl %eax, INPUT_FILE(%ebp)	# Store file descriptor

# Set destination index to 0
 movl $0, %edi

# Begin main loop
read_to_buffer:
 movl $0, %esi 		# Set source index to 0
 movl $SYS_READ, %eax
 movl INPUT_FILE(%ebp), %ebx
 movl $BUFFER_DATA, %ecx
 movl $BUFFER_SIZE, %edx
# Size of buffer is returned in %eax
 int $LINUX_SYSCALL

# Check if end of file reached 
 cmpl $END_OF_FILE, %eax
 jle end_loop

 movl %eax, READ_SIZE(%ebp)	# Store the size of read

read_next_char:
 # Check if end of buffer reached
 movl READ_SIZE(%ebp), %edx
 cmp %esi, %edx  # Continue unless we've reached the end
 je read_to_buffer

 movl $BUFFER_DATA, %eax
 movl $CURRENT_LINE, %ebx
# Move current char to %cl
 movb (%eax, %esi, 1), %cl
 incl %esi
 cmpb newline, %cl
 je process_line

 # Store value in CURRENT_LINE buffer
 movb %cl, (%ebx, %edi, 1)
 incl %edi
 movl READ_SIZE(%ebp), %edx
 jmp read_next_char  # Continue to read

process_line:
 pushl CURRENT_LINE
 pushl %edi
 call ascii_to_int
 movl RUNNING_TOTAL(%ebp), %ebx
 addl %ebx, %eax
 movl %eax, RUNNING_TOTAL(%ebp)
 movl $0, %edi
 jmp read_next_char

end_loop:
 movl $SYS_CLOSE, %eax
 movl INPUT_FILE(%ebp), %ebx
 int $LINUX_SYSCALL
# Write total to output
 movl $SYS_WRITE, %eax
 movl $STDOUT, %ebx
 movl RUNNING_TOTAL(%ebp), %edx
 movl $CURRENT_LINE, %ecx
 movl $0, %edi
 movl %edx, (%ecx, %edi, 4)
 movl $4, %edx
 int $LINUX_SYSCALL

write_newline:
 movl $SYS_WRITE, %eax
 movl $STDOUT, %ebx
 movl $newline, %ecx
 movl $1, %edx
 int $LINUX_SYSCALL
 
end:
 movl $SYS_EXIT, %eax
 movl $0, %ebx
 int $LINUX_SYSCALL
