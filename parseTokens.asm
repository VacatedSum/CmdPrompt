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
first_token:	.space		80
		.word		0
arguments:	.space		1024
		.word		0
newLine:	.asciiz		"\n"
		.word		0
.globl parseTokens
					# $a0 contains string to parse
					# 
					# Return:
					# $v0 = the command (first token)
					# $v1 = the arguments
.text
	j main				# Goto correct entry point
parseTokens:
	la $t2, first_token		# Load addresses for parsed data
	la $t3, arguments
first_token_loop:
	lb $t0, 0($a0)
	beq $t0, 0, done		# If null, we're just done.
	beq $t0, 0x20, args		# On space, move on to arguments
	beq $t0, 0xa, done		# On enter we're done also - no arguments
	sb $t0, 0($t2)			# Store next character
	addi $a0, $a0, 1		# Increment argument pointer
	addi $t2, $t2, 1		# Increment first_token pointer
	j first_token_loop		# Keep going until space or null
args:	
	addi $a0, $a0, 1		# Skip over the space character
args_loop:
	lb $t0, 0($a0)			# Load next character
	beq $t0, 0, done		# If it's null, we're done.
	beq $t0, 0xa, done		# If newline, we're done.
	sb $t0, 0($t3)			# Otherwise, store in arguments buffer
	addi $a0, $a0, 1		# Increment argument pointer
	addi $t3, $t3, 1		# Increment arguments pointer
	j args_loop			# Keep going until null

done:
	add $t0, $zero, $zero
	sb $t0, 0($t2)			# Stick a null byte at the end. Helps with variable length commands
	
	la $v0, first_token		# Prepare out return values
	la $v1, arguments
	jr $ra				# Return to whence we came
