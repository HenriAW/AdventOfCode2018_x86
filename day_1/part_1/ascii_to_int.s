.include "linux.s"

# This function will take an ascii string
# and return the integer value of that string
#
# Registers:
#   %ebx - base multiplier (i.e. for base 10: 1, 10, 100...
#   %cl - +/-
#   %edi - String index
#   %eax - total count
#   %ch - Current char
#   %edx - temporary storage for $test_value and multiplied sum

.section .data

.equ MINUS, '-'
.equ PLUS, '+'
.equ INT_CONVERSION, 48     # 0 is ascii number 48, so an 
                            # int char - 48 is it's true value

.section .text

# Stack positions
.equ ST_SIZE_RESERVE, 0
.equ ST_OLD_EBP, 0		# Number of args
.equ ST_RETURN_ADDRESS, 4
.equ ST_ARGV_1, 8		# String pointer
.equ ST_ARGV_2, 12		# String length

.global ascii_to_int
.type ascii_to_int, @function
ascii_to_int:
 # Stack stuff
 pushl %ebp
 movl %esp, %ebp
 # subl $ST_SIZE_RESERVE, %esp - not needed since this is 0

 # Setup vars
 movl $1, %ebx
 movl $0, %eax
 movl ST_ARGV_2(%ebp), %edi	# Starts with the last digit

 # Get +/- from start of string
 movl ST_ARGV_1(%ebp), %edx
 movb (%edx), %cl
# movb ST_ARGV_1(%ebp), %cl
 decl %edi

convert_loop:
 # Check if we've finished 
 cmpl $0, %edi
 je end_function

 # Get next char
 movl ST_ARGV_1(%ebp), %edx
 movb (%edx,%edi,1), %ch
 decl %edi

 # Get int-char value
 subb $INT_CONVERSION, %ch
 
 # Move int to %edx and multiply with base multiplier
 movl $0, %edx
 movb %ch, %dl
 imull %ebx, %edx

 # Increase multiplier
 imull $10, %ebx

 # +/- the result to %eax
 cmpb $MINUS, %cl
 je minus
 addl %edx, %eax
 jmp convert_loop
minus:
 subl %edx, %eax
 jmp convert_loop

end_function:
 movl %ebp, %esp
 pop %ebp
 ret			# %eax is returned
