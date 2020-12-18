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
.globl	echo

.text
	j main				# Goto correct entry point
echo:
	addi $sp, $sp, -4		# Save $ra since this is non-leaf procedure.
	sw $ra, 0($sp)
	
	la $t0, writeStr		# $a0 already contains the correct arguments
	jalr $t0			# Just jump on over to writeStr to output
	
	lw $ra, 0($sp)			# Restore the return address.
	addi $sp, $sp, 4
	
	jr $ra				# Return to whence we came.
