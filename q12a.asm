#
# Solution file for assembly question Q12A
# 
# - Assume that $a0 contains a 32-bit binary value.
# - Set $v0 to the number of 1 digits in the binary value of $a0. 
# - For example, if $a0 has the value 0x00FFFFFF, 
#          $v0 would be set to decimal value 24. 
# - Do NOT perform this operation recursively!
# - Make sure to comment your code and use meaningful label names.
# - Do not use jr $ra or syscall commend to terminate your program.
#

.data

.text

main:
	addi $a0, $zero, 0x00ffffff	# we will change this value in testing.
#######################################
# ONLY ALTER THE CODE BELOW THIS LINE #	
#######################################
	add $v0, $zero, $zero	#initialize v0
	add $t1, $a0, $zero	#store the value of a0 to t1
loop:	beq $t1, $zero, exit	#exit if t1 is 0
	addi $t0, $t1, -1	#store the content t1 - 1 to t0
	and $t1, $t1, $t0	#bitwise t1 and t1 - 1, which will drease 1 of the number of 1 digits in t1, and get a new t1
	addi $v0, $v0, 1	#increase the counting by 1
	j loop			#continue looping

exit: