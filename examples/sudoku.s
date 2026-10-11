.text 
start:
	li sp 0x10000
	la s0 inputcnt
	lw s0 0(s0)
	la s5 inputs

input_loop:
	add a0 s5 zero
	addi a1 zero 0
	jal solve

	addi s5 s5 16
	addi s0 s0 -1
	bnez s0 input_loop

	la s0 inputcnt
	lw s0 0(s0)
	la s1 inputs
	la s2 answers
loop_answers:
	li s3 16
	addi s4 zero 0

	loop_answer:
		lb t2 0(s1)
		lb t3 0(s2)
		beq t2 t3 skip_different

		addi s4 s4 1

		skip_different:
		addi s1 s1 1
		addi s2 s2 1
		addi s3 s3 -1
		bnez s3 loop_answer

	li t4 0x10000
	sw s4 0(t4)

	addi s0 s0 -1
	bnez s0 loop_answers
	hcf

#########################################
####### Modify this part! #############>>

solve:
	addi sp sp -28
	sw ra 0(sp)
	sw s0 4(sp)
	sw s1 8(sp)
	sw s2 12(sp)
	sw s3 16(sp)
	sw s4 20(sp)
	sw s5 24(sp)

	add s0 a0 zero

pass_loop:
	addi s2 zero 0
	addi s1 zero 0

cell_loop:
	add t0 s0 s1
	lbu t0 0(t0)
	bnez t0 next_cell

	addi s3 zero 1
	addi s4 zero 0
	addi s5 zero 0

digit_loop:
	add a0 s0 zero
	add a1 s1 zero
	add a2 s3 zero
	jal can_place
	beqz a0 skip_digit
	addi s4 s4 1
	add s5 s3 zero

skip_digit:
	addi s3 s3 1
	li t0 5
	blt s3 t0 digit_loop

	li t0 1
	bne s4 t0 next_cell
	add t0 s0 s1
	sb s5 0(t0)
	addi s2 s2 1

next_cell:
	addi s1 s1 1
	li t0 16
	blt s1 t0 cell_loop

	bnez s2 pass_loop

	lw ra 0(sp)
	lw s0 4(sp)
	lw s1 8(sp)
	lw s2 12(sp)
	lw s3 16(sp)
	lw s4 20(sp)
	lw s5 24(sp)
	addi sp sp 28
	ret

can_place:
	srli t0 a1 2        
	andi t1 a1 3          

	# 행 검사
	slli t2 t0 2
	add t3 a0 t2
	lbu t4 0(t3)
	beq t4 a2 cp_fail
	lbu t4 1(t3)
	beq t4 a2 cp_fail
	lbu t4 2(t3)
	beq t4 a2 cp_fail
	lbu t4 3(t3)
	beq t4 a2 cp_fail

	# 열 검사
	add t3 a0 t1
	lbu t4 0(t3)
	beq t4 a2 cp_fail
	lbu t4 4(t3)
	beq t4 a2 cp_fail
	lbu t4 8(t3)
	beq t4 a2 cp_fail
	lbu t4 12(t3)
	beq t4 a2 cp_fail

	# 2x2 박스 검사
	srli t0 t0 1
	slli t0 t0 3
	srli t1 t1 1
	slli t1 t1 1
	add t0 t0 t1
	add t3 a0 t0
	lbu t4 0(t3)
	beq t4 a2 cp_fail
	lbu t4 1(t3)
	beq t4 a2 cp_fail
	lbu t4 4(t3)
	beq t4 a2 cp_fail
	lbu t4 5(t3)
	beq t4 a2 cp_fail

	addi a0 zero 1
	ret

cp_fail:
	addi a0 zero 0
	ret

### Do not modify beyond this point! ##<<
#########################################


.data
inputcnt:
.word 3
inputs: 
.byte 0 4 3 0 0 0 4 2 0 2 0 0 3 0 0 0
.byte 0 0 3 0 0 4 0 2 0 0 2 0 0 2 0 3
.byte 0 3 0 4 0 0 2 0 4 0 3 0 0 0 0 2

answers:
.byte 2 4 3 1 1 3 4 2 4 2 1 3 3 1 2 4 
.byte 2 1 3 4 3 4 1 2 4 3 2 1 1 2 4 3 
.byte 2 3 1 4 1 4 2 3 4 2 3 1 3 1 4 2
