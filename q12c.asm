# Solution file for assembly question Q12C
# 
# - Assume that $a0 stores a pixel value from your bitmap display. 
# - Set $v0 to the grayscale version of this pixel in $a0. 
# - This involves setting the red, green and blue values of $v0 to #   the average of the red, green and blue values of $a0. 
# - Example: if $a0 = 0x002174, $v0 will be set to 0x313131.
# - Make sure to comment your code and use meaningful label names.
# - Do not use jr $ra or syscall commend to terminate your program.
#

.data

.text

main:
	addi $a0, $zero, 0x002174   # we will change this value in testing.
#######################################
# ONLY ALTER THE CODE BELOW THIS LINE #
#######################################
	srl $t0, $a0, 16	#save the red components in t0
	andi $t1, $a0, 65535	#remove the red components and set the rest to t1
	srl $t1, $t1, 8		#save the green color in t1
	andi $t2, $a0, 255	#save the blue color in t2
	add $t3, $t0, $t1	#add them together
	add $t3, $t3, $t2
	addi $t4, $zero, 3	#set the divider
	div $t3, $t4
	mflo $t5		#get the average
	sll $v0, $t5, 16	#get the new red
	sll $v1, $t5, 8		#get the new green
	add $v0, $v0, $v1	#add red and green
	add $v0, $v0, $t5	#add red and green and blue