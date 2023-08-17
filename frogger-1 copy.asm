#CSC258H5S Winter 2022 Assembly Final Project
# University of Toronto, St. George
#
# Student: Chutong Li, 1007148258
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 5 (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Have objects in different rows move at different speeds. - easy
# 2. Add paulse -easy
# 3. After final player death, display gameover/retry screen. Restart the game if the "retry" option is chosen. - easy
# 4。Add a third row in each of the water and road sections - easy
# 5。Dispay the number of lives remaining - easy
# 6。Add extra lives to scene - hard
# 
#
# Any additional information that the TA needs to know:
# - (write here, if any)


.data
displayAddress: .word 0x10008000
frog_r:         .word 29
frog_c:         .word 64
final_row:	.space 128
log_row1: 	.space 128
log_row2:	.space 128
log_row3:	.space 128
car_row1:	.space 128
car_row2:	.space 128
car_row3:	.space 128
safelinec:	.word 0xffff00
startandendc:	.word 0x00ff00
riverc:		.word 0x0000ff
roadc:		.word 0x000000
frogc1:		.word 0xff0000
frogc2:		.word 0xa020f0
logc:		.word 0x5e2612
carc:		.word 0xfaebd7
holec:		.word 0xffc0cb
die:		.word 0
reach:		.word 0
finalrows:	.word 640
riverrow1s:	.word 1024
riverrow2s:	.word 1408
riverrow3s:	.word 1792
saferows:	.word 2176
carrow1s:	.word 2560
carrow2s:	.word 2944
carrow3s:	.word 3328
startrow:	.word 3712
numberoflifes:	.word 3 #can be extended, up to 5 
numberofholes:	.word 5
win: .asciiz "You win! Retry or not?"
fail: .asciiz "You fail! Retry or not?"



.text

main:

#set/resetpart
jal background
jal setobjects
jal drawobjects
li $v0, 32
li $a0, 1000
syscall

loop:
jal background
jal update
jal drawobjects
jal displaylives
jal frog
li $v0, 32
li $a0, 1000
syscall
checkdeath:
la $t0, die		
lw $t1, 0($t0)
beq $t1, 1, reset
checkhole:
la $t0, reach		
lw $t1, 0($t0)
beq $t1, $zero, loop
add $t1, $zero, $zero
sw $t1, 0($t0)
la $t0, numberofholes		
lw $t1, 0($t0)
beq $t1, $zero, winandretry

reset:
la $t0, numberoflifes		
lw $t1, 0($t0)
beq $t1, $zero, failandretry
la $t5, frog_r		
lw $t6, 0($t5)
addi $t6, $zero, 29
sw $t6, 0($t5)	
la $t5, frog_c		
lw $t8, 0($t5)
addi $t8, $zero, 64
sw $t8, 0($t5)
la $t0, die		
lw $t1, 0($t0)
add $t1, $zero, $zero
sw $t1, 0($t0)

j loop

winandretry:
li $v0, 50
la $a0, win
syscall
bne $a0, $zero, Exit
la $t0, die		
lw $t1, 0($t0)
add $t1, $zero, $zero
sw $t1, 0($t0)
la $t0, numberoflifes		
lw $t1, 0($t0)
addi $t1, $zero, 3
sw $t1, 0($t0)
la $t0, numberofholes		
lw $t1, 0($t0)
addi $t1, $zero, 5
sw $t1, 0($t0)
la $t5, frog_r		
lw $t6, 0($t5)
addi $t6, $zero, 29
sw $t6, 0($t5)	
la $t5, frog_c		
lw $t8, 0($t5)
addi $t8, $zero, 64
sw $t8, 0($t5)
j main

failandretry:
li $v0, 50
la $a0, fail
syscall
bne $a0, $zero, Exit
la $t0, die		
lw $t1, 0($t0)
add $t1, $zero, $zero
sw $t1, 0($t0)
la $t0, numberoflifes		
lw $t1, 0($t0)
addi $t1, $zero, 3
sw $t1, 0($t0)
la $t0, numberofholes		
lw $t1, 0($t0)
addi $t1, $zero, 5
sw $t1, 0($t0)
la $t5, frog_r		
lw $t6, 0($t5)
addi $t6, $zero, 29
sw $t6, 0($t5)	
la $t5, frog_c		
lw $t8, 0($t5)
addi $t8, $zero, 64
sw $t8, 0($t5)	
j main



j Exit


background:
lw $t0, displayAddress
lw $t1, startandendc
lw $t2, riverc
lw $t3, safelinec
lw $t4, roadc
addi $t5, $zero, 0
addi $t6, $zero, 256
paint0:
beq $t5, $t6, paint1	
sw $t1, 0($t0) 		
addi $t0, $t0, 4   	
addi $t5, $t5, 1	
j paint0			
paint1:
addi $t6, $zero, 544
beq $t5, $t6, paint2	
sw $t2, 0($t0) 		
addi $t0, $t0, 4   	
addi $t5, $t5, 1	
j paint1			
paint2:
addi $t6, $zero, 640
beq $t5, $t6, paint3	
sw $t3, 0($t0) 		
addi $t0, $t0, 4   	
addi $t5, $t5, 1	
j paint2			
paint3:
addi $t6, $zero, 928
beq $t5, $t6, paint4
sw $t4, 0($t0) 		
addi $t0, $t0, 4  
addi $t5, $t5, 1	
j paint3	
paint4:
addi $t6, $zero, 1024
beq $t5, $t6, end_back	
sw $t1, 0($t0) 		
addi $t0, $t0, 4 
addi $t5, $t5, 1	
j paint4			
end_back:
jr $ra 
##############

displaylives:#just like the holes, but they represent lives, note that the ojects that directly draw on the screen will draw the last
lw $t0, displayAddress
addi $a0, $t0, 128
add $t1, $zero, $zero 
la $t4, frogc1
lw $t3, 0($t4)
la $t7, numberoflifes
lw $t6, 0($t7)
displaylivesloop:
beq $t1, $t6, displaylivesend
sw $t3, 0($a0)
addi $t1, $t1, 1		
addi $a0, $a0, 8	
j displaylivesloop
displaylivesend:
jr $ra


frog:
#draw the frog by the position of frog, the frog is 4 * 3, note that the middle of the frog is frog_c + 8
lw $t0, displayAddress
lw $t7, frogc1
la $t5, frog_r		
lw $t6, 0($t5)
sll $t6, $t6, 7		
la $t5, frog_c		
lw $t8, 0($t5)	
add $t5, $t0, $t6
add $t5, $t8, $t5
sw $t7, 0($t5)
addi $t5, $t5, 12
sw $t7, 0($t5)
addi $t5, $t5, 128
sw $t7, 0($t5)
addi $t5, $t5, -4
sw $t7, 0($t5)
addi $t5, $t5, -4
sw $t7, 0($t5)
addi $t5, $t5, -4
sw $t7, 0($t5)
addi $t5, $t5, 132
sw $t7, 0($t5)
addi $t5, $t5, 4
sw $t7, 0($t5)
jr $ra 



setobjects: #given the position of the objects
addi $sp, $sp, -4
sw $ra, 0($sp)	

setholes:
la $a0, final_row
jal addholes

setlogsandcars:
la $a0, log_row1
addi $a1, $zero, 0 
addi $a2, $zero, 64
jal filllogcar

la $a0, log_row2
addi $a1, $zero, 12 
addi $a2, $zero, 76
jal filllogcar

la $a0, log_row3
addi $a1, $zero, 64 
addi $a2, $zero, 0
jal filllogcar

la $a0, car_row1
addi $a1, $zero, 20 
addi $a2, $zero, 84
jal filllogcar

la $a0, car_row2
addi $a1, $zero, 0 
addi $a2, $zero, 64
jal filllogcar

la $a0, car_row3
addi $a1, $zero, 84 
addi $a2, $zero, 20
jal filllogcar

lw $ra, 0($sp)				# Pop $ra off the stack
addi $sp, $sp, 4
jr $ra


drawobjects:#draw the objects by what we store
addi $sp, $sp, -4
sw $ra, 0($sp)	



drawholes:
la $a0, final_row
la $s1, finalrows
lw $a1, 0($s1)
lw $a2 holec
jal displayobject

drawlogsandcars:
la $a0, log_row1
la $s1, riverrow1s
lw $a1, 0($s1)
lw $a2 logc
jal displayobject

la $a0, log_row2
la $s1, riverrow2s
lw $a1, 0($s1)
lw $a2 logc
jal displayobject

la $a0, log_row3
la $s1, riverrow3s
lw $a1, 0($s1)
lw $a2 logc
jal displayobject

la $a0, car_row1
la $s1, carrow1s
lw $a1, 0($s1)
lw $a2 carc
jal displayobject

la $a0, car_row2
la $s1, carrow2s
lw $a1, 0($s1)
lw $a2 carc
jal displayobject

la $a0, car_row3
la $s1, carrow3s
lw $a1, 0($s1)
lw $a2 carc
jal displayobject

jal frog
jal displaylives
lw $ra, 0($sp)				# Pop $ra off the stack
addi $sp, $sp, 4
jr $ra

##############################

##########



addholes: 
addi $t4, $zero, 1 #represent the hole
add $t3, $zero, 4 #width and gap of the holes is equal to 4 and 2
add $t7, $zero, 5 #number of holes
addi $t6, $zero, -1
add $t1, $a0, $zero #a0 is the address of the row of holes
addholesloop:
addi $t6, $t6, 1
beq $t6, $t7, endofholesloop
add $t5, $zero, $zero
addi $t1, $t1, 8
addonehole:
beq $t5, $t3, addholesloop
sw $t4, 0($t1)
addi $t1, $t1, 4
addi $t5, $t5, 1
j addonehole
endofholesloop:
jr $ra


updateholes:
addi $t1, $zero, 16
add $t2, $zero, 5 #number of holes
add $t3, $zero, 4 #width and gap of the holes is equal to 4 and 2
add $t6, $zero, $zero
add $t5, $zero, $zero
addi $t7, $a0, 8 #the start of the hole
findthehole:
addi $t6, $t6, 1
beq $a1, $t1, fillthehole
beq $t6, $t2, endofupdatehole
addi $t7, $t7, 24
addi $t1, $t1, 24
j findthehole
fillthehole:
beq $t5, $t3, endofupdatehole
sw $zero, 0($t7)
addi $t7, $t7, 4
addi $t5, $t5, 1
j fillthehole
endofupdatehole:
jr $ra

filllogcar: # fill the allocated space with pixels for the log/car row, a0 address, a1firstcar, a2 secondcar
add $t7, $zero, $zero			
addi $t5, $zero, 128		
addi $t4, $zero, 32
addi $t3, $zero, 1
filllogcarloop:
add $t6, $zero, $zero
beq $t7, $t5, filllogcarend
beq $t7, $a1, fillthecar
beq $t7, $a2, fillthecar
sw $zero 0($a0)
addi $a0, $a0, 4	
addi $t7, $t7, 4		
j filllogcarloop
fillthecar:
beq $t6, $t4, filllogcarloop
sw $t3 0($a0)
addi $a0, $a0, 4		
addi $t6, $t6, 4
addi $t7, $t7, 4
j fillthecar
filllogcarend:
jr $ra


movelogcarleft:
add $t1, $zero, $zero 		
lw $t0, 0($a0) #since it mover to left, then the old last pixel is replaced by the old first pixel, we need to first store it and use later			
addi $t2, $zero, 124
movelogcarleftloop:
beq $t1, $t2, linkl
lw $t3, 4($a0)			
sw $t3, 0($a0)			
add $t1, $t1, 4			
add $a0, $a0, 4			
j movelogcarleftloop
linkl:
sw $t0, 0($a0)
jr $ra

movelogcarright:
add $t1, $zero, $zero 		
add $t0, $a0, $zero #since it mover to right, then the old first pixel is replaced by the last one, and we need to first restore it then update it
addi $t2, $zero, 128
lw $t3, 0($a0)
addi $a0, $a0, 4
movelogcarrightloop:
beq $t1, $t2, linkr
lw $t4, 0($a0)			
sw $t3, 0($a0)			
add $t3, $t4, $zero			
add $a0, $a0, 4
add $t1, $t1, 4					
j movelogcarrightloop
linkr:
sw $t3, 0($t0)
jr $ra



displayobject: #draw the log/car row to the display
lw $t0, displayAddress		
add $t0, $t0, $a1	#move to the assigned place
addi $t7, $zero, 1      #indicator	
add $t1, $zero, $zero 	#width counter
add $t2, $zero, $zero	#height counter
addi $t3, $zero, 128		
addi $t4, $zero, 12		
displayobjectloop:
beq $t2, $t4, displayobjectend
beq $t1, $t3, nextline
lw $t5, 0($a0)
addi $a0, $a0, 4		
addi $t1, $t1, 4			
beq $t5, $t7, drawthecar	
addi $t0, $t0, 4
j displayobjectloop
drawthecar:
sw $a2, 0($t0)
addi $t0, $t0, 4
j displayobjectloop
nextline:
addi $t2, $t2, 4	
add $t1, $zero, $zero 		
addi $a0, $a0, -128		
j displayobjectloop
displayobjectend:
jr $ra




update:
addi $sp, $sp, -4
sw $ra, 0($sp)
	
checkinput:
lw $t8, 0xffff0000			
bne $t8, $zero, updatefrog
updateothers:
la $t5, frog_r		
lw $t6, 0($t5)
beq $t6, 8, froglogrow1
beq $t6, 11, froglogrow2
beq $t6, 14, froglogrow3
j updatethem

froglogrow1:
la $t5, frog_c		
lw $t6, 0($t5)
addi $t6, $t6, 8 #middle of frog
la $a0 log_row1
add $a0, $a0, $t6
lw $t7, 0($a0)				
beq $t7, $zero, updatedeath	
addi $t6, $t6, -12 #move back -8 and then move -4
sw $t6, 0($t5)
j updatethem

updatedeath:
la $t0, die		
lw $t1, 0($t0)
addi $t1, $zero, 1
sw $t1, 0($t0)

la $t0, numberoflifes		
lw $t1, 0($t0)
addi $t1, $t1, -1
sw $t1, 0($t0)
j updatethem

froglogrow2:
la $t5, frog_c		
lw $t6, 0($t5)
addi $t6, $t6, 8 #middle of frog
la $a0 log_row2
add $a0, $a0, $t6
lw $t7, 0($a0)				
beq $t7, $zero, updatedeath	
addi $t6, $t6, -12 #move back -8 and then move -4
sw $t6, 0($t5)
j updatethem
froglogrow3:
la $t5, frog_c		
lw $t6, 0($t5)
addi $t6, $t6, 8 #middle of frog
la $a0 log_row1
add $a0, $a0, $t6
lw $t7, 0($a0)				
beq $t7, $zero, updatedeath	
addi $t6, $t6, -12 #move back -8 and then move -4
sw $t6, 0($t5)
j updatethem

updatethem:
la $a0, log_row1
jal movelogcarleft
la $a0, log_row2
jal movelogcarright
la $a0, log_row3
jal movelogcarleft 
la $a0, car_row1
jal movelogcarleft
la $a0, car_row2
jal movelogcarright
la $a0, car_row3
jal movelogcarleft 

checkspecialcase:
la $t5, frog_r		
lw $t6, 0($t5)
beq $t6, 5, checkholerow
beq $t6, 20, checkcarrow1
beq $t6, 23, checkcarrow2
beq $t6, 26, checkcarrow3
j endofupdate

checkholerow:
la $t5, frog_c		
lw $t6, 0($t5)
la $a0 final_row
addi $t6, $t6, 8
add $a0, $a0, $t6
lw $t7, 0($a0)				
beq $t7, $zero, updatedeath2
addi $t0, $zero, 1				
sw $t0, reach
la $t0, numberofholes
lw $t1, 0($t0)
addi $t1, $t1, -1			
sw $t1, 0($t0)	
		
la $a0, final_row
add $a1, $zero, $t6	
jal updateholes

j endofupdate
	
checkcarrow1:
la $t5, frog_c		
lw $t6, 0($t5)
la $a0 car_row1
add $a0, $a0, $t6
lw $t7, 0($a0)				
bne $t7, $zero, updatedeath2
addi $a0, $a0, 16
lw $t7, 0($a0)				
bne $t7, $zero, updatedeath2
j endofupdate
checkcarrow2:
la $t5, frog_c		
lw $t6, 0($t5)
la $a0 car_row2
add $a0, $a0, $t6
lw $t7, 0($a0)				
bne $t7, $zero, updatedeath2
addi $a0, $a0, 16
lw $t7, 0($a0)				
bne $t7, $zero, updatedeath2
j endofupdate
checkcarrow3:
la $t5, frog_c		
lw $t6, 0($t5)
la $a0 car_row3
add $a0, $a0, $t6
lw $t7, 0($a0)				
bne $t7, $zero, updatedeath2
addi $a0, $a0, 16
lw $t7, 0($a0)				
bne $t7, $zero, updatedeath2
j endofupdate

updatedeath2:
la $t0, die		
lw $t1, 0($t0)
addi $t1, $zero, 1
sw $t1, 0($t0)

la $t0, numberoflifes		
lw $t1, 0($t0)
addi $t1, $t1, -1
sw $t1, 0($t0)
j endofupdate


endofupdate:

lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra


updatefrog:
lw $t2, 0xffff0004	
beq $t2, 0x77, w		
beq $t2, 0x61, a
beq $t2, 0x73, s	
beq $t2, 0x64, d	
j updateothers

w:
la $t5, frog_r		
lw $t6, 0($t5)
addi $t6, $t6, -3
sw $t6, 0($t5)
j updateothers

s:
la $t5, frog_r		
lw $t6, 0($t5)
beq $t6, 29, updateothers
addi $t6, $t6, 3
sw $t6, 0($t5)
j updateothers

a:
la $t5, frog_c		
lw $t6, 0($t5)
beq $t6, 0, updateothers
addi $t6, $t6, -16
sw $t6, 0($t5)
j updateothers

d:
la $t5, frog_c		
lw $t6, 0($t5)
beq $t6, 112, updateothers
addi $t6, $t6, 16
sw $t6, 0($t5)
j updateothers



Exit:
li $v0, 10 # terminate the program gracefully
syscall

