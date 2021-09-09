##########################################################################
# Created by: Valladares, Joshua
# jdvallad
# 04 February 2021
#
# Assignment: Lab 3:  ASCII-risks (Asterisks)
# CSE 012, Computer Systems and Assembly Language
# UC Santa Cruz, Winter 2021
#
# Description: This program takes a user inputted int (greater than 0) and prints a pattern according to the input.
#
#
# Notes: This program is intended to be run from the MARS IDE.
##########################################################################

##########################################################################
# PSUEDOCODE
#
# count = 1
# height = 0
#
# while(height <= 0)
#     print("Enter the height of the pattern (must be greater than 0):\t")
#     height = userInput
#     if (height <= 0)
#         print "Invalid Entry!\n"
#
# while (counter <= height)
#		for(i = 0, i < count, i++)
#           print("*/t")
#       print(counter)
#		for(i = 0, i < count, i++)
#           print("\t*")
#       print("\n")
#       counter++
#
# endProgram
##########################################################################

##########################################################################
# REGISTER USAGE
# I did not use any registers to hold persistent data throughtout the program.
##########################################################################

.data
	ask: .asciiz "Enter the height of the pattern (must be greater than 0):\t"
	ans: .asciiz "Invalid Entry!\n"
	height: .word 0
	counter: .word 1
	astTab: .asciiz "*\t"
	tabAst: .asciiz "\t*"
	nl: .asciiz "\n"
.text
##########################################################################
# This is the main section.
# Here a call is made to inputLoop in order to fill the label height with the correct
# user inputted height.
##########################################################################
main: nop
	jal inputLoop
	j printLoop
##########################################################################
# This section takes a user inputted int.
# If this int isn't greater than 0, the invalid label is jumped to.
##########################################################################
inputLoop: nop
	li $v0, 4
	la $a0, ask 
	syscall
	li $v0, 5 
	syscall
	blez $v0, invalid
	nop
	sw $v0, height
	jr $ra
##########################################################################
#  This section prints an invalid input string.
# Then this section will jump to inputLoop.
##########################################################################
invalid: nop
	li $v0, 4 
	la $a0, ans 
	syscall
	j inputLoop
##########################################################################
# This section is the bulk of the program.
# A counter var starts at 1.
# If this counter is greater than user inputted height, the program ends.
# Otherwise the appopriate length row is printed according to counter.
# Counter is then incremented.
# Finally, this method is called once again.
##########################################################################
printLoop: nop
	lw $a0, counter
	lw $t1, height
	bgt  $a0, $t1, endProgram
	nop
	jal printAstTabPairs
	lw $a0, counter
	jal printNum
	lw $a0, counter
	jal printTabAstPairs
	la $a0, nl
	jal printString
	lw $t1, counter
	addi $t1, $t1, 1
	sw $t1, counter
	j printLoop
##########################################################################
# This is a helper method that prints a number passed through $a0 to the screen.
##########################################################################
printNum: nop 
	li $v0, 1
	syscall
	jr	$ra
##########################################################################
# This is a helper method that prints a string passed by reference through $a0 to the screen.
##########################################################################
printString: nop
	li $v0, 4
	syscall
	jr $ra
##########################################################################
# This method takes an int n as input from $a0.
# The string stored in astTab is then printed n times.
##########################################################################
printAstTabPairs: nop
	ble  $a0 ,1, backToRA
	nop
	move $t1 , $a0
	li $v0, 4
	la $a0, astTab
	syscall
	move $a0, $t1
	subi $a0,$a0, 1
	j printAstTabPairs	
##########################################################################
# This method takes an int n as input from $a0.
# The string stored in tabAst is then printed n times.
##########################################################################
printTabAstPairs: nop
	ble $a0 ,1, backToRA
	nop
	move $t1 , $a0
	li $v0, 4
	la $a0, tabAst
	syscall
	move $a0, $t1
	subi $a0,$a0, 1
	j printTabAstPairs
##########################################################################
# This is a helper method that returns to the point of program stored in $ra.
##########################################################################
backToRA: nop
	jr $ra	
##########################################################################
# This is a helper method that ends the program.
##########################################################################
endProgram: nop
	li $v0, 10
	syscall
		
