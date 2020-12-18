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
.globl writeStr

					# $a0 to contain address of null-terminated string to write
.text
	j main				# Goto correct entry point
writeStr:
	addi $sp, $sp, -4		# Store $ra on stack since this is a non-leaf procedure
	sw $ra, 0($sp)
	
	la $t0, 0($a0)			# Store contents of $a0, since $a0 will be used in other procedure calls.
	
writeLoop:
	lb $a0, 0($t0)			# Load next character to print
	beq $a0, 0, done		# If it's null, we're done
	la $t1, putChar			# Otherwise, print the character.
	jalr $t1
	addi $t0, $t0, 1		# Increment to next character
	j writeLoop			# Do it again until null is reached.
	
done:
	lw $ra, 0($sp)			# Restore $ra from stack
	addi $sp, $sp, 4
	jr $ra				# Return to whence we came
