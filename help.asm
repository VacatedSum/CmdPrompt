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
avail_cmds_str:	.asciiz		"\nAvailable Commands:\n	help\n	echo\n	exit\n	midi\n	clear (cls)\n"
		.word		0
help_more_str:	.asciiz		"Type help [command] for more info on that command.\n"
		.word 		0
echo_help_str:	.asciiz		"Output given arguments.\nExample input: \"echo hello\"\nExample output: \"hello\"\n"
		.word		0
help_help_str:	.asciiz		"Get list of commands or help on specific command.\nExample: \"help echo\"\n"
		.word		0
exit_help_str:	.asciiz		"Exits this command processor immediately.\n"
		.word		0
midi_help_str:	.asciiz		"Enter this command to discover the true meaning of life.\n"
		.word		0
cls_help_str:	.asciiz		"Can be entered as 'clear' or 'cls'.\nClears the screen of text.\nText can still be viewed by scrolling up.\n"
		.word		0
help_str:	.asciiz		"help"
		.word 		0
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
newLine:	.asciiz		"\n"
		.word		0
		
.globl	help

.text
	j main				# Goto correct entry point
help:
	addi $sp, $sp, -4		# Since this is a non-leaf procedure, save $ra to stack
	sw $ra, 0($sp)
	
	lw $t0, ($a0)			# Check if requesting echo help
	lw $t1, echo_str
	beq $t0, $t1, echo_help
	
	lw $t1, exit_str		# Check if requesting exit help
	beq $t0, $t1, exit_help
	
	lw $t1, help_str		# Check if requesting help help
	beq $t0, $t1, help_help
	
	lw $t1, midi_str		# Check if requesting midi help
	beq $t0, $t1, midi_help
	
	lw $t1, cls_str			# Check if requesting cls help
	beq $t0, $t1, clear_help
	
	lw $t1, clear_str		# Check if requesting clear help
	beq $t0, $t1, clear_help
	
general_help:				# Otherwise, just give list of available commands
	la $a0, avail_cmds_str
	la $t0, writeStr
	jalr $t0
	
	la $a0, help_more_str		# Give basic instruction on help command
	la $t0, writeStr
	jalr $t0
	j done
echo_help:
	la $a0, echo_help_str		# Print Echo help
	la $t0, writeStr
	jalr $t0
	j done
exit_help:				# Print exit help
	la $a0, exit_help_str
	la $t0, writeStr
	jalr $t0
	j done
help_help:				# Print help help
	la $a0, help_help_str
	la $t0, writeStr
	jalr $t0
	j done
midi_help:				# Print midi help
	la $a0, midi_help_str
	la $t0, writeStr
	jalr $t0
	j done
clear_help:				# Print cls help
	la $a0, cls_help_str
	la $t0, writeStr
	jalr $t0
	j done
done:
	lw $ra, 0($sp)			# Restore $ra from stack
	addi $sp, $sp, 4
	
	jr $ra				# Return to whence we came
