.include "linux.s"

# This function will write 'Hello, world' to STDOUT

.section .data

# Constanct
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

# Data
hello_world:
 .ascii "Hello, world!\n\0"

.section .text

# Stack Positions
.equ ST_SIZE_RESERVE, 4 # Number of bytes to reserve on the
			# stack for local variables
.equ ST_FD_OUT, -4
.equ ST_ARGC, 0		# Number of args
 
.global _start
_start:
 # Prepare the stack
 subl $ST_SIZE_RESERVE, %esp

#open_fd_out:
 # Open stdout - linux system call
# movl $SYS_OPEN, %eax
# movl $STDOUT, %ebx
# movl $O_CREAT_WRONLY_TRUNC, %ecx
# movl $0666, %edx
# int $LINUX_SYSCALL
# movl %eax, ST_FD_OUT(%ebp)	# Store file descriptor

write_fd_out:
 movl $SYS_WRITE, %eax
 movl $STDOUT, %ebx
 movl $hello_world, %ecx
 movl $14, %edx
 int $LINUX_SYSCALL

end:
 movl $SYS_EXIT, %eax
 movl $0, %ebx
 int $LINUX_SYSCALL
