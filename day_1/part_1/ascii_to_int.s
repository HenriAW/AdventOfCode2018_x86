.include "linux.s"

# This function will take an ascii string
# and return the integer value of that string

# Here I will use:
# %ebx - base multiplier (i.e. for base 10: 1, 10, 100...
# %cl - +/-
# %edi - String index
# %eax - total count
# %ch - Current char
# %edx - temporary storage for $test_value and multiplied sum
.section .data

.equ MINUS, '-'
.equ INT_CONVERSION, 48 # ASCII - 48 is real value

.section .text

# Stack positions
.equ ST_SIZE_RESERVE, 0
.equ ST_ARGC, 0		# Number of args
.equ ST_ARGV_1, 4	# String pointer
.equ ST_ARGV_2, 8	# String length

.global ascii_to_int
.type ascii_to_int, @function
ascii_to_int:
 # Stack stuff
 pushl %ebp
 movl %esp, %ebp
 subl $ST_SIZE_RESERVE, %esp

# Setup vars
 movl $0, %edi
 movl $1, %ebx
 movl $0, %eax

# Get +/-
 movl ST_ARGV_1(%ebp), %edx
 movb (%edx,%edi,1), %cl
 incl %edi
 
convert_loop:
 movb $0, %ch
 movl ST_ARGV_1(%ebp), %edx
 movb (%edx,%edi,1), %ch
 cmpl ST_ARGV_2(%ebp), %edi
 je end_function
# %edx is now used to store the result of the multiplier
 movl $0, %edx
 movb %ch, %dl
 subb $INT_CONVERSION, %ch
 imull %ebx, %edx 	# Result should be stored in %edx
 cmpb $MINUS, %cl
 je minus
 addl %edx, %eax
 jmp increase_counts
minus:
 subl %edx, %eax

increase_counts:
 incl %edi
 imull $10, %ebx
 jmp convert_loop

end_function:
 movl %ebp, %esp
 pop %ebp
 ret			# %eax is returned
 
