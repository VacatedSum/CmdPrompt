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
help_str:	.asciiz		"help"
		.word		0
echo_str:	.asciiz		"echo"
		.word		0
exit_str:	.asciiz		"exit"
		.word		0
midi_str:	.asciiz		"midi"
		.word		0
clear_str:	.asciiz		"clear"
		.word		0
cls_str:	.asciiz		"cls"
		.word		0
prompt:		.asciiz		">>>"
		.word		0
newLine:	.asciiz		"\n"
		.word		0
unrec_out:	.asciiz		"Unrecognized Command!\n"
		.word		0
keyBuffer:	.space		1024
		.word		0
.globl		main
.text
main:
	la $t0, enable_rxint		# Enable interrupts
	jalr $t0
writePrompt:
	la $a0, prompt			# Write the prompt.
	la $t0, writeStr
	jalr $t0
loop:
	j loop				# This keeps the programming running until exit command is used.
	

.kdata


.ktext 0x80000180
interrupt:
	addi $sp, $sp, -4		# Save all registers
	sw $at, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $v0, 0($sp)
	
	
key_handler:	
	lui $t0, 0xffff			# Load MMIO address space
	lb $a0, 4($t0) 			# Extract Character
	la $t0, keyBuffer		# Load keybuffer Address Space
find_end:
	lb $t1, 0($t0)			# Load next byte of key buffer
	beq $t1, 0, found_end		# Found the next empty spot in the buffer
	addi $t0, $t0, 1		# If not, increment and try again
	j find_end
found_end:
	sb $a0, 0($t0)			# Add character to buffer
	
	la $t0, putChar			# put key on monitor
	jalr $t0
	
	beq $a0, 0x0a, proc_cmd		# If enter key, process command
	j done				# Otherwise, just exit handler to await next key press.

proc_cmd:
	la $a0, keyBuffer
	la $t0, parseTokens
	jalr $t0			# Return: $v0 = token, $v1 = arguments
	move $a0, $v1			# Move arguments into $a0
	
	lw $t0, echo_str		# If command is echo, goto echo procedure.
	lw $t1, 0($v0)
	beq $t1, $t0, j_echo
	
	lw $t0, exit_str		# If command is exit, goto exit procedure.
	beq $t1, $t0, j_exit
	
	lw $t0, help_str		# If command is help, goto help procedure.
	beq $t1, $t0, j_help
	
	lw $t0, midi_str		# If command is midi, goto midi procedure.
	beq $t1, $t0, j_midi
	
	lw $t0, clear_str		# If command is cls or clear, goto clear procedure.
	beq $t1, $t0, j_clear
	
	lw $t0, cls_str
	beq $t1, $t0, j_clear
	
	lb $t0, 0($v0)			# If enter pressed at empty prompt,
	beq $t0, 0xa, cmd_done		# Just cleanup the buffers and return.
	
	la $a0, unrec_out		# Otherwise, print that command is unrecognized.
	la $t0, writeStr
	jalr $t0
	
	j cmd_done			# Jump to cleanup procedures.
	
j_echo:
	la $t0, echo			# Goto echo procedure
	jalr $t0
	j cmd_done
	
j_help:
	la $t0, help			# Goto help procedure
	jalr $t0
	j cmd_done
	
j_exit:
	la $t0, exit			# Goto exit procedure
	jalr $t0
	j cmd_done

j_midi:					# Goto midi procedure
	la $t0, midi
	jalr $t0
	j cmd_done
	
j_clear:				# Goto clear procedure
	la $t0, clear
	jalr $t0
	j cmd_done
	
cmd_done:
	la $t0, keyBuffer		# We need to clear the buffer.
	
	la $t1, ($v1)			# Clear the arguments register
	
clear_args_loop:			# Loop to clear arguments
	lw $t2, 0($t1)
	beq $t2, 0, zero_out_buffer
	sw $zero, 0($t1)
	addi $t1, $t1, 4
	j clear_args_loop
	
zero_out_buffer:			# Loop to clear buffer
	lb $t1, 0($t0)
	beq $t1, $zero, zero_buffer_done
	sb $zero, 0($t0)
	addi $t0, $t0, 1
	j zero_out_buffer
	
zero_buffer_done:
	la $a0, newLine
	la $t0, writeStr
	jalr $t0
	
	la $a0, prompt			#Write new prompt
	la $t0, writeStr
	jalr $t0

done:
	lw $v0, 0($sp)			# Restore all registers
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $at, 0($sp)
	addi $sp, $sp, 4
	mtc0 $zero, $13			# Set Co$13 to $zero (clear the cause)
	eret				# Exception Return call

enable_rxint:	
	mfc0	$t0, $12		# Get Status register
	andi	$t0, $t0, 0xFFFE	# clear interrupt enable flag
	mtc0    $t0, $12		# turn interrupts off.	
	
	
	lui     $t0, 0xffff		# load control word base address 
	lw	$t1, 0($t0)	        # read rcv ctrl
	
	ori	$t1, $t1, 0x0002	# set the *input* interupt enable
	sw	$t1, 0($t0)	        # update rcv ctrl
	mfc0	$t0, $12		# get interrupt state into work register
	ori	$t0, $t0, 0x0001	# set int enable flag
	mtc0    $t0, $12		# Turn interrupts back on
	jr	$ra
