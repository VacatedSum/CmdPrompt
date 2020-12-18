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
.globl	clear
clear_block:	.asciiz		"\n\n\n\n\n\n\n\n\n\n\n\n"
		.word		0	
.text
	j main				# Goto correct entry point

clear:
	addi $sp, $sp, -4		# Save $ra on stack
	sw $ra, 0($sp)
	
	la $a0, clear_block		# Write a bunch of new lines
	la $t0, writeStr
	jalr $t0
	
	lw $ra, 0($sp)			# Restore $ra from stack
	addi $sp, $sp, 4
	
	jr $ra				# Return to whence we came