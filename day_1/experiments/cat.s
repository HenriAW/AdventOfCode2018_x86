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

 .equ BUFFER_SIZE, 502
 .lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

# Stack Positions
.equ ST_SIZE_RESERVE, 4 # Number of bytes to reserve on the
			# stack for local variables
.equ ST_FD_IN, -4
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
 movl %eax, ST_FD_IN(%ebp)	# Store file descriptor

# Begin main loop
read_loop_begin:
 movl $SYS_READ, %eax
 movl ST_FD_IN(%ebp), %ebx
 movl $BUFFER_DATA, %ecx
 movl $BUFFER_SIZE, %edx
# Size of buffer is returned in %eax
 int $LINUX_SYSCALL

# Check if end of file reached
 cmpl $END_OF_FILE, %eax
 jle end_loop

continue_read_loop:
# Write to STDOUT
 movl %eax, %edx
 movl $SYS_WRITE, %eax
 movl $STDOUT, %ebx
 movl $BUFFER_DATA, %ecx
 int $LINUX_SYSCALL
# Continue loop
 jmp read_loop_begin

end_loop:
 movl $SYS_CLOSE, %eax
 movl ST_FD_IN(%ebp), %ebx
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
