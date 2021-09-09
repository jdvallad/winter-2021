##########################################################################
# Created by: Valladares, Joshua
# jdvallad
# 23 February 2021
#
# Assignment: Lab 4: Syntax Checker
# CSE 012, Computer Systems and Assembly Language
# UC Santa Cruz, Winter 2021
#
# Description: This program takes a user inputted String as a fileName and checks if the contents of the file
# have proper bracket syntax.
#
#
# Notes: This program is intended to be run from the MARS IDE.
##########################################################################
##########################################################################
# PSUEDOCODE
#
# fileName = userInput
# printInputString
# if(fileName > 20)
#    printInvalidInput
#    exit
# if(fileName.charAt(0) != letter)
#    printInvalidInput
#    exit
# for(char c in fileName)
#    if(c != validCharacter)
#       printInvalidInput
#       exit
# file = openFile(fileName)
# index = -1
# pairCount = 0
# while(file.hasMoreCharacters)
#    index++
#    c = file.nextChar
# if(c == '(' or c == '{' or c == '[')
#    stack.add(c)
#    continue
#    if(c == ')' or c == '}' or c == ']')
#       t = stack.pop
#       if(c == ')' and t == '(' or c == '}' and t == '{' or c == '[' and t == ']')
#          pairCount++
#          continue
#       else
#          printBraceMismatchError
#          exit
# if(stack.size != 0)
#    printStackNotEmptyError
#    exit
# printSuccess
# exit
##########################################################################
##########################################################################
# REGISTER USAGE
# $t0 holds the fileName data (not the address)
# $t1 holds the fileData character currently being looked at
# $t2 holds the bracket pair count
# $t3 holds the char index count
# $t4 holds the file description
##########################################################################
.data
temp: .space 4
entered: .asciiz "You entered the file:\n"
success1: .asciiz "SUCCESS: There are "
success2: .asciiz " pairs of braces.\n"
error: .asciiz "ERROR: Invalid program argument.\n"
fail1: .asciiz "ERROR - There is a brace mismatch: "
fail2: .asciiz " at index "
stackfail: .asciiz "ERROR - Brace(s) still on stack: "
nl: .asciiz "\n"
.text
# main method that runs on execution
main: nop
	move $t0, $a1 
	la $a0, entered
	jal printString
	nop
	lw $a0, ($t0)
	jal printString
	nop
	jal printNewLine
	nop
	jal printNewLine
	nop
	lw $a0, ($t0)
	jal stringLength
	nop
	bgt $v0, 20, invalidInput
	nop
	li $t5, 0
	lw $a1, ($t0)
	lbu $a0, ($a1)
	li $a1, 64
	li $a2, 91
	jal inBetween
	nop
	add $t5, $v0, $t5
	lw $a1, ($t0)
	lbu $a0, ($a1)
	li $a1, 96
	li $a2, 123
	jal inBetween
	nop
	add $t5, $v0, $t5
	beqz $t5, invalidInput
	nop
	jal checkValidString
	nop
	jal openFile
	nop
	addi $t2, $0, 0
	addi $t3, $0, -1
# main loop of program that handles logic
mainLoop: nop
	addi $t3, $t3, 1
	jal readFile
	nop
	beqz $v0, exitmainLoop
	nop
	beq $t1, 40, push
	nop
	beq $t1, 91, push
	nop
	beq $t1, 123, push
	nop
	beq $t1, 41, compare
	 nop
	beq $t1, 93, compare
	nop
	beq $t1, 125, compare
	nop
	j mainLoop
	nop
# run when main loop in exited
exitmainLoop:
	nop
	jal stackSize
	nop
	beqz $v0, correct
	nop
	la $a0, stackfail
	jal printString
	nop
	jal printStack
	nop
	jal printNewLine
	 nop
	j endProgram
	nop
# checks to see if $a0 is in between $a1 and $a2
inBetween: nop
	sgtu $t9, $a0, $a1
	sltu $t8, $a0, $a2
	add $t9, $t9, $t8
	seq $v0, $t9, 2
	jr $ra
	nop
# checks to see if $a0 is a character from a-z, A-Z, 0-9, . , or _.
isProperCharacter:
	nop
	move $ra, $s3
	li $t5, 0
	li $a1, 64
	li $a2, 91
	jal inBetween
	nop
	add $t5, $t5, $v0
	li $a1, 96
	li $a2, 123
	jal inBetween
	nop
	add $t5, $t5, $v0
	li $a1, 47
	li $a2, 58
	jal inBetween
	nop
	add $t5, $t5, $v0
	li $a1, 94
	li $a2, 96
	jal inBetween
	nop
	add $t5, $t5, $v0
	li $a1, 45
	li $a2, 47
	jal inBetween
	nop
	add $t5, $t5, $v0
	beqz $t5, invalidInput
	nop
	move $s3, $ra
	j vsLoop
	nop
# checks to see if fileName is made up of proper characters
checkValidString:
	nop
	move  $s2, $ra
	lw $s1, ($t0)
# loop to check for character validity
vsLoop: nop
	lbu $a0, ($s1)
	beqz $a0, exitVSLoop
	nop
	addi $s1, $s1, 1
	j isProperCharacter
	nop
# code run when loop is exited
exitVSLoop: nop
	move $ra, $s2
	jr $ra
	nop 
# code run when bracket syntax is correct
correct: nop
	la $a0, success1
	jal printString
	nop
	move $a0, $t2
	jal printNum
	nop
	la $a0, success2
	jal printString
	nop
	j endProgram
	nop
# checks if next char matches char from the stack
compare: nop
	jal pop
	nop
	move $a0, $v0
	move $a2, $t1
	li $a1, 40
	li $a3, 41
	jal checkBothEqual
	nop
	beq $v0, 1, match
	nop
	li $a1, 91
	li $a3, 93
	jal checkBothEqual
	nop
	beq $v0, 1, match
	nop
	li $a1, 123
	li $a3, 125
	jal checkBothEqual
	nop
	beq $v0, 1, match
	nop
	la $a0, fail1
	jal printString
	nop 
	move $a0, $t1
	jal printChar
	nop
	la $a0, fail2
	jal printString
	nop
	move $a0, $t3
	jal printNum
	nop
	jal printNewLine
	nop
	j endProgram
	nop
# code run when match is found between current char and the stack
match: nop
	addi $t2, $t2, 1
	j mainLoop
	nop
# checks if $a0 = $a1 and $a2 = $a3
checkBothEqual: nop
	seq $t9 , $a0, $a1
	seq $t8, $a2, $a3
	add $t9, $t9, $t8
	seq $v0, $t9, 2
	jr $ra
	nop
# prints the stack to the console without modifying it
printStack: nop
	move $t9, $ra
	move $t8, $0
	move $t7, $sp
# loops over the stack
stackLoop: nop
	lb $v0, ($t7)
	beq $v0, 1, endPrintStack
	nop
	move $a0, $v0
	jal printChar
	nop
	addi $t8, $t8, 1
	addi $t7, $t7, 4
	j stackLoop
	nop
# code run when stack has been looped over. Stack size is returned
endPrintStack: nop
	move $ra, $t9
	move $v0, $t8
	jr $ra
	nop
# returns the size of the stack
stackSize: nop
	move $t8, $0
	move $t7, $sp
# loops over the stack and checks for empty element
stackSizeLoop: nop
	lb $v0, ($t7)
	beq $v0, 1, endStackSizeLoop
	nop
	addi $t8, $t8, 1
	addi $t7, $t7, 4
	j stackSizeLoop
	nop
# code run when stackloop is over
endStackSizeLoop: nop
	move $v0, $t8
	jr $ra
	nop
# pushes input to the stack
push: nop
	addi $sp, $sp, -4
	sb $t1, ($sp)
	j mainLoop
	nop
# pops the top element from the stack
pop: nop
	lb $v0, ($sp)
	addi $sp, $sp, 4
	jr $ra
	nop
# returns the top element from the stack without modifying the stack
peek: nop
	lb $v0, ($sp)
	jr $ra
	nop
# code run when the fileName in invalid
invalidInput: nop
	la $a0, error
	jal printString
	nop
	j endProgram
	nop
# returns the length of the string stored in $a0
stringLength: nop
	move $t9, $0
# loops over the string until empty character found
stringLoop: nop
	lb $t8, ($a0)
	beqz $t8, exitStringLoop
	nop
	addi $a0, $a0, 1
	addi $t9, $t9, 1
	j stringLoop
	nop
# code run when string in done being looped over
exitStringLoop: nop
	move $v0, $t9
	jr $ra
	nop
# subroutine to branch to when you want to return to $ra
backToRA: nop
	jr $ra
	 nop
# prints a string to the screen
printString: nop
	li $v0, 4
	syscall
	jr $ra
	 nop
# prints a new Line
printNewLine: nop
	la $a0, nl
	j printString
	nop
# prints a num to the screen
printNum: nop
	li $v0, 1
	syscall
	jr $ra
	nop
# prints a char to the screen
printChar: nop
	li $v0, 11
	syscall
	jr $ra
	nop
# ends the program
endProgram: nop
	li $v0, 10
	syscall
# opens the file with name stored in $t0
openFile: nop
	li $v0, 13
	lw $a0, ($t0)
	li   $a1, 0
	li   $a2, 0
	syscall
	move $t4, $v0
	jr $ra
	nop
# reads the next char from the file to $t1
readFile: nop
	li   $v0, 14
	move $a0, $t4
	la   $a1, temp
	li   $a2, 1
	syscall
	lb $t1, temp
	jr $ra
	nop
# closes the file currently opened
closeFile: nop
	li   $v0, 16
	move $a0, $t4
	syscall
	jr $ra
	nop