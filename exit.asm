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
.globl	exit

.text
	j main				# Goto correct entry point
exit:
	li $v0, 10
	syscall				# Simply exit.
