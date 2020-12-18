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
.globl putChar
					
.text

	j main				# Goto correct entry point
putChar:				# Character to print in $a0
	addi $sp, $sp, -4		# Save $t0 to stack
	sw $t0, 0($sp)
	
	lui $t0, 0xffff			# Load MMIO address space
	add $t1, $a0, $zero		# Move argument (character to Print) into $t1
	
waitForReady:
	lb $t2, 8($t0)			# Load ready byte into $t2
	andi $t2, $t2, 0x0001		# Extract ready bit
	beq $t2, $0, waitForReady	# If not ready, continue polling.
	
	sb $t1, 12($t0)			# If ready, place $t1 data into the MMIO output byte.
waitForDone:
	lw $t2, 8($t0)			# Load ready bit into $t2
	andi $t2, $t2, 0x0001		# Extract ready bit
	beq $t2, $0, waitForDone	# If not ready, continue polling.
exit:
	lw $t0, 0($sp)			# Restore $to from stack
	addi $sp, $sp, 4
	jr $ra				# return to whence we came
