# Solution file for assembly question Q12B
# 
# - Assume that $a0 and $a1 contain two positive integers. 
# - Set $v0 to the least common multiple for $a0 and $a1 
#   (the smallest positive integer evenly divisible by $a0 and $a1)
# - Again, do not perform this operation recursively.
# - Make sure to comment your code and use meaningful label names.
# - Do not use jr $ra or syscall commend to terminate your program.
#

.data

.text

main:
	addi $a0, $zero, 8	# we will change this value in testing.
	addi $a1, $zero, 6	# we will also change this value in testing.
#######################################
# ONLY ALTER THE CODE BELOW THIS LINE #
#######################################
       	blt $a0, $a1, modify	#find the maximum one between a0 and a1, set it to v0
       	add $v0, $a0, $zero
       	j loop
modify:
       add $v0, $a1, $zero 
loop:
       div $v0, $a0		#divide v0 by a0, reminder to HI
       mfhi $t1 
       div $v0, $a1		#divide v0 by a1, reminder to HI
       mfhi $t2
       add $t3,	$t1, $t2	#add those two reminders together to t3
       beq $t3, $zero, exit	#if the sum of reminders equal 0, then vo is the least common muktiple of a0 and a1
       addi $v0, $v0, 1 	#if not, increase v0 by 1
       j loop
exit: