	.set noreorder
	.globl main
.text
main:
	la $v0, limit 
	lw $v0, 0($v0)
	add $v0, $v0, $v0
	add $v0, $v0, $v0
	sub $s1, $sp, $v0 # stack limit
	move $s0, $sp     # stack start

read:	li $v0, 5
	syscall
	blt $v0, $0, print
	 nop
	addiu $sp, $sp, -4
	sw $v0, 0($sp)
	ble $sp, $s1, stackflow
	  nop
	b read
	
print:
	move $t0, $s0
L2:	addiu $s0, $s0, -4
	blt $s0, $sp, done
	nop
	lw $a0, 0($s0)
	li $v0, 1
	syscall

	li $v0, 4
	la $a0, comma
	syscall
	
	b L2
	 nop
	

done:
	li $v0, 4
	la $a0, CR
	syscall

	li $v0, 10
	syscall # exit
	add $sp, $sp, $t0
	jr $ra
	 nop
	
stackflow:
	li $v0, 4
	la $a0, SF
	syscall
	li $v0, 10
	syscall # exit
	
	
.data
limit: .word 5
comma: .asciiz ","
CR: .asciiz "\n"
SF: .asciiz "Oh, Stack limit!\n"

