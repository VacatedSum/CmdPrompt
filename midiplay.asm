.data
#############################################
### Computer Architecture and Organization ##
#############################################
#### Final Project - Command Processor ######
#############################################
######################### Steve Cina ########
#############################################
#############################################
############## November, 2020 ###############
#############################################
i:	.word	0 #a2
k:	.word	128

.globl midi


.text
	la $t0, main			# Goto correct entry point
	jalr $t0
	
midi:
	addi $sp, $sp, -4		# Save $ra to stack
	sw $ra, 0($sp)
	
	la $t0, i			# Initialize iterator
	lw $t1, 0($t0)
	
	la $t0, k			# Initialize stop position
	lw $t2, 0($t0)


		
midiloop:
	beq $t1,$t2,Exit		# Quit when done with loop
	add $a2, $t1, $zero		# Set $a2 to current value of iterator
	addi $t1,$t1,1			# Increment iterator
	jal midiplay			# Play the sound
	j midiloop			# Do it again until all instruments have played.
		
		

midiplay:
	li $a1, 128			# Get random integer.
	li $v0,42
	syscall 			# Result = Random integer 0-127 in $a0 (pitch)
		
		
	la $a1, 750			# Set duration
	la $a3,45			# Set volume
	li $v0, 31			# Midi syscall
	syscall	
	jr $ra				# Go back to midiloop
		
Exit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
