
	.set noreorder
	.globl main
.text
main:
# Clear QtSpim args.
	move $5, $0
	move $6, $0

# main function.
	li $v0, 4
	la $a0, hello
	syscall

# 设置数组，数的个数
	la $a0, Length
	lw $a0, 0 ($a0)
	la $a1, Array

# 打印出未排序的数组
	jal print_Array
	  nop
# 调用【插入排序】子程序
	jal insert_sort
	  nop

# 打印排序完的数组
#	jal	print_Array
	  nop

# 说声再见
	li $v0, 4
	la $a0, goodbye
	syscall

# 完了，停机
done:	b done
	  nop

# static void print_Array(int a0, int *a1)
# print the 整个 Array
# a0: Array size
# a1: Array base

print_Array:
# back up a0, v0. don't use stack this time.
	move $t6, $v0 
	move $t5, $a0

# print a newline.
	li $v0, 4
	la $a0, CR
	syscall

# t2 做循环变量
# for t2 = 0 ... (n-1)
	li $t2, 0

# t7 = arr[t2]
loop:	move $t7, $t2
	add $t7, $t7, $t7 # t7 = t7 + t7
	add $t7, $t7, $t7 # t7 = t7 + t7 (t7 = t7*4)
	add $t7, $t7, $a1
	lw $t7, 0 ($t7)   # t7 = t7[t7]

# print one member of the Array.
# arr[t2]
	li $v0, 1
	move $a0, $t7
	syscall

# print a space, comma, or other 间隔符
	la $a0, dontknow
	li $v0, 4
	syscall

# if(t2<Lenght) goto loop
	addiu $t2, $t2, 1
	blt $t2, $t5, loop # t5, Array size
	  nop

# pop
	move $a0, $t5
	move $v0, $t6
	jr $ra
	  nop
# end of print Array

	.globl	insert_sort
# void insert_sort(int n, int *arr)
insert_sort:
	addiu $t0, $a1, 4
	move $t1, $a0
	add $t1, $t1, $t1
	add $t1, $t1, $t1
	addiu $t1, $t1, -4
	add $t1, $a1, $t1

#  insert a[1]...a[n-1] to the sorted array a[0]
insert:
# new member want to join the sorted array.
	lw $v0, 0 ($t0)
# default, assume tmp is the greatest member.
	move $v1, $t0 
#
#  find a right position, save to $v1.
	move $t2, $a1
find:
	bge $t2, $t0, do_move
	  nop
	lw $t7, 0 ($t2)
	bgt $t7, $v0, got
	  nop
	addiu $t2, $t2, 4
	b find
	  nop
# 找到新的数(v0)该存放的位置(v1) 相当于C语言里的tmp
got:
	move $v1, $t2

# 看后腾挪出一个位置
do_move:
	move $t2, $t0
loopj:
	ble $t2, $v1, store
	lw $t7, -4 ($t2)
	sw $t7, 0 ($t2)
	addiu $t2, $t2, -4
	b loopj
	  nop

# 把【新数】放到找到的位置
store:
swap: # this is a just label not used.
	sw $v0, 0 ($v1)

# 打印整个数组
	move $t4, $ra # push $ra
	jal print_Array
	  nop
	move $ra, $t4 # pop $ra


#
# 插入下一个数，（为什么加的是4，不是1，刚才解释过，因为整数是4字节，t0是地址所以加4）
	addiu $t0, $t0, 4
	ble $t0, $t1, insert
	  nop

# 排序完毕，返回
	move $v0, $0
	move $v1, $0
	jr $ra
	  nop
# end of sort.
	.word 0x88888888

.data
Length:
.word 7 # 要排序多少个数字
.word 0x88888888
#	.align 4
Array: # 把要排序的数字写在下面：
.word	10, 9, 8, 7, 6, 5, 4, 3, 2, 1
.word	10, 9, 8, 7, 6, 5, 4, 3, 2, 1
.word	10, 9, 8, 7, 6, 5, 4, 3, 2, 1
.word	10, 9, 8, 7, 6, 5, 4, 3, 2, 1
.word	10, 9, 8, 7, 6, 5, 4, 3, 2, 1
.word	10, 9, 8, 7, 6, 5, 4, 3, 2, 1
.word	0x88888888
# 提示输出的内容
CR: .asciiz "\n"
goodbye: .asciiz "\nGood Bye\n"
hello: .asciiz "\nHello\n"
dontknow: .asciiz ","

# 程序私有的栈，等老师要求用栈再用
myStack:
.word	0, 0, 0, 0, 0, 0, 0
.word	0, 0, 0, 0, 0, 0, 0
.word	0, 0, 0, 0, 0, 0, 0
.word	0, 0, 0, 0, 0, 0, 0
.word	0, 0, 0, 0, 0, 0, 0
