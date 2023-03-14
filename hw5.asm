.text:
.globl create_term
create_term:
  beq $a0, $zero, coeferror
  blt $a1, $zero, experror
  addi $sp, $sp, -8
  sw $s0, 0($sp)
  sw $s1, 4($sp)
  move $s0, $a0
  move $s1, $a1
  li $a0, 12
  li $v0, 9
  syscall
  sw $s0, 0($v0)
  sw $s1, 4($v0)
  sw $zero, 8($v0)
  j endcreateterm
  
  coeferror:
  	li $v0, -1
  	jr $ra

  experror:
  	li $v0, -1
  	jr $ra
 
 endcreateterm:
 lw $s0, 0($sp)
 lw $s1, 4($sp)
 addi $sp, $sp, 8
 jr $ra
 
 calculate_bytes_for_buffer:
 move $t3, $a0
 li $t0, 0
 li $t2, -1
 
 counttheints: 
 	addi $t0, $t0, 2
 	lw $t1, 0($t3)
 	beq $t1, $zero, endcounttheintspotential
 	lw $t1, 4($t3)
 	ble $t1, $t2, subtractpair
 
 	backtocountints:
 		addi $t3, $t3, 8
 		j counttheints	
 	
 endcounttheintspotential:
 	lw $t4, 4($t3)
 	bne $t4, $t2, backtocountints
 	j endcounttheints
 
 subtractpair:
 	addi $t0, $t0, -2
 	j backtocountints
 	
 endcounttheints:
 sll $t0, $t0, 2
 move $v0, $t0
 jr $ra

sort_max_exp:
 move $t6, $a2
 li $t1, -1
 li $t7, 0
 li $t8, -2

setup:
 li $t2, -1
 move $t4, $a0
 	
 find_max:
 	lw $t0, 0($t4)
 	beq $t0, $zero, checknextforminusone
 	lw $t0, 4($t4)

	backtocheckmax:
 	ble $t0, $t2, skipnewmax
 	
 	replacewithnewmax:
 		move $t2, $t0
 		move $t5, $t4
 	
 	skipnewmax:
 		addi $t4, $t4, 8
 		j find_max		 
 	
 	checknextforminusone:
 		lw $t0, 4($t4)
 		beq $t0, $t1, endfind_max
 		j backtocheckmax
 	
  endfind_max:
  beq $t2, $t1, endaddingelements
  lw $t0, 0($t5)
  sw $t0, 0($t6)
  sw $t2, 4($t6)
  addi $t7, $t7, 1
  sw $t8, 4($t5)
  addi $t6, $t6, 8
  beq $t7, $a1, endaddingelements
  j setup
  
  endaddingelements:
  sw $zero, 0($t6)
  sw $t1, 4($t6)
  move $v0, $a2
  jr $ra

sort_max_exp_pluscoef:
 move $t6, $a2
 li $t1, -1
 li $t7, 0
 li $t8, -2

setupc:
 li $t2, -1
 move $t4, $a0
 	
 find_maxc:
 	lw $t0, 0($t4)
 	beq $t0, $zero, checknextforminusonec
 	lw $t0, 4($t4)

        backtocheckmaxc:
 	blt $t0, $t2, skipnewmaxc
	beq $t0, $t2, checkforcoefless
 	
 	replacewithnewmaxc:
 		move $t2, $t0
 		move $t5, $t4
 	
 	skipnewmaxc:
 		addi $t4, $t4, 8
 		j find_maxc

	checkforcoefless:
		lw $t3, 0($t4)
		lw $t9, 0($t5)
		bgt $t3, $t9, skipnewmaxc
		j replacewithnewmaxc 		 
 	
 	checknextforminusonec:
 		lw $t0, 4($t4)
 		beq $t0, $t1, endfind_maxc
		j backtocheckmaxc
 	
  endfind_maxc:
  beq $t2, $t1, endaddingelementsc
  lw $t0, 0($t5)
  sw $t0, 0($t6)
  sw $t2, 4($t6)
  addi $t7, $t7, 1
  sw $t8, 4($t5)
  addi $t6, $t6, 8
  beq $t7, $a1, endaddingelementsc
  j setupc
  
  endaddingelementsc:
  sw $zero, 0($t6)
  sw $t1, 4($t6)
  move $v0, $a2
  jr $ra

.globl create_polynomial
create_polynomial:
 li $t1, -1
 lw $t2, 0($a0)
 lw $t0, 4($a0)
 bne $t2, $zero, skipendfunc
 beq $t0, $t1, endfunction1
 
 skipendfunc:
 move $t9, $ra
 jal calculate_bytes_for_buffer
 move $ra, $t9
 li $t2, 8
 beq $v0, $t2, endfunction1
 move $t0, $v0
 move $t1, $t0
 sll $t0, $t0, 1
 addi $t0, $t0, 20
 sub $sp, $sp, $t0
 sw $s0, 0($sp)
 sw $s1, 4($sp)
 sw $s2, 8($sp)
 sw $s3, 12($sp)
 sw $ra, 16($sp)
 addi $t6, $sp, 20
 add $s3, $t6, $t1
 move $s2, $t0
 move $a2, $t6
 jal sort_max_exp
 move $a0, $v0
 li $a1, -1
 move $a2, $s3
 jal sort_max_exp_pluscoef
 move $s0, $v0
 li $a0, 8
 li $v0, 9
 syscall
 li $t9, 0
 move $t1, $v0
 li $s1, -1
  
  	addfirstterm:
  		lw $t3, 4($s0)
  		beq $t3, $s1, endcreate
  		lw $t3, 0($s0)	
  			
  		backtotermiteration:
  			lw $t0, 4($s0)
  			lw $t2, 12($s0)
  			beq $t0, $t2, addcoef
  			beq $t3, $zero, gotothenextfirstterm
  			addi $t9, $t9, 1
  			move $a0, $t3
  			move $a1, $t0
  			jal create_term
  			move $t5, $v0
  			sw $t5, 0($t1)
  			
  		skipinc:
  			addi $s0, $s0, 8
  			j endaddfirstterm	
  
  	addcoef:
  		lw $t6, 0($s0)
  		lw $t4, 8($s0)
  		beq $t6, $t4, skipaddingfirst
  		add $t3, $t3, $t4
  		
  		skipaddingfirst:
  			addi $s0, $s0, 8
  			j backtotermiteration
  	
  	gotothenextfirstterm:
  		addi $s0, $s0, 8
  		j addfirstterm
  		  
  endaddfirstterm:
  lw $t0, 0($t1)
  li $t8, -1
  
  addremainingterms:
  	lw $t2, 0($s0)
  	lw $t3, 4($s0)
  	beq $t3, $t8, endcreate
  	beq $t2, $zero, gotothenextterm
  	
  	backtoremtermiteration:
  		lw $t3, 4($s0)
  		lw $t4, 12($s0)
  		beq $t3, $t4, addcoefforrem
  		beq $t2, $zero, skipincforrem
  		addi $t9, $t9, 1
  		move $a0, $t2
  		move $a1, $t3
  		jal create_term
  		sw $v0, 8($t0)
  		lw $t0, 8($t0)
  		
  	skipincforrem:
  		addi $s0, $s0, 8
  		j addremainingterms
  
  addcoefforrem:
   	lw $t6, 0($s0)
  	lw $t5, 8($s0)
  	beq $t5, $t6, skipaddingrem
  	add $t2, $t2, $t5
  	
  	skipaddingrem:
  		addi $s0, $s0, 8
  		j backtoremtermiteration
  	
  gotothenextterm:
  	addi $s0, $s0, 8
  	j addremainingterms
  
  returnnull:
  	li $v0, 0
  	j endcreatepoly
  	
  endfunction1:
  	li $v0, 0
  	jr $ra
  
  endcreate:
  beq $t9, $zero, returnnull
  sw $t9, 4($t1)
  move $v0, $t1
  
  endcreatepoly:
  move $t0, $s2
  lw $s0, 0($sp)
  lw $s1, 4($sp)
  lw $s2, 8($sp)
  lw $s3, 12($sp)
  lw $ra, 16($sp)
  add $sp, $sp, $t0
  jr $ra

create_polynomial_2:
 li $t1, -1
 lw $t2, 0($a0)
 lw $t0, 4($a0)
 bne $t2, $zero, skipendfunc2
 beq $t0, $t1, endfunction2
 
 skipendfunc2:
 move $t9, $ra
 jal calculate_bytes_for_buffer
 move $ra, $t9
 li $t2, 8
 beq $v0, $t2, endfunction2
 li $t1, -1
 move $t0, $v0
 addi $t0, $t0, 16
 sub $sp, $sp, $t0
 sw $s0, 0($sp)
 sw $s1, 4($sp)
 sw $s2, 8($sp)
 sw $ra, 12($sp)
 addi $t6, $sp, 16
 move $s2, $t0
 move $a2, $t6
 jal sort_max_exp
 move $s0, $v0 
 li $a0, 8
 li $v0, 9
 syscall
 li $t9, 0
 move $t1, $v0
 li $s1, -1
  
  	addfirstterm2:
  		lw $t3, 4($s0)
  		beq $t3, $s1, endcreate2
  		lw $t3, 0($s0)	
  			
  		backtotermiteration2:
  			lw $t0, 4($s0)
  			lw $t2, 12($s0)
  			beq $t0, $t2, addcoef2
  			beq $t3, $zero, gotothenextfirstterm2
  			addi $t9, $t9, 1
  			move $a0, $t3
  			move $a1, $t0
  			jal create_term
  			move $t5, $v0
  			sw $t5, 0($t1)
  			
  		skipinc2:
  			addi $s0, $s0, 8
  			j endaddfirstterm2	
  
  	addcoef2:
  		lw $t4, 8($s0)
  		add $t3, $t3, $t4
  		addi $s0, $s0, 8
  		j backtotermiteration2
  	
  	gotothenextfirstterm2:
  		addi $s0, $s0, 8
  		j addfirstterm2
  		  
  endaddfirstterm2:
  lw $t0, 0($t1)
  li $t8, -1
  
  addremainingterms2:
  	lw $t2, 0($s0)
  	lw $t3, 4($s0)
  	beq $t3, $t8, endcreate2
  	beq $t2, $zero, gotothenextterm2
  	
  	backtoremtermiteration2:
  		lw $t3, 4($s0)
  		lw $t4, 12($s0)
  		beq $t3, $t4, addcoefforrem2
  		beq $t2, $zero, skipincforrem2
  		addi $t9, $t9, 1
  		move $a0, $t2
  		move $a1, $t3
  		jal create_term
  		sw $v0, 8($t0)
  		lw $t0, 8($t0)
  		
  	skipincforrem2:
  		addi $s0, $s0, 8
  		j addremainingterms2
  
  addcoefforrem2:
  	lw $t5, 8($s0)
  	add $t2, $t2, $t5
  	addi $s0, $s0, 8
  	j backtoremtermiteration2
  	
  gotothenextterm2:
  	addi $s0, $s0, 8
  	j addremainingterms2
  
  returnnull2:
  	li $v0, 0
  	j endcreatepoly2
  	
  endfunction2:
  	li $v0, 0
  	jr $ra
  
  endcreate2:
  beq $t9, $zero, returnnull2
  sw $t9, 4($t1)
  move $v0, $t1
  
  endcreatepoly2:
  move $t0, $s2
  lw $s0, 0($sp)
  lw $s1, 4($sp)
  lw $s2, 8($sp)
  lw $ra, 12($sp)
  add $sp, $sp, $t0
  jr $ra

.globl add_polynomial
add_polynomial:
beq $a0, $zero, returnsecondpoly
beq $a1, $zero, returnfirstpoly
lw $t0, 4($a0)
lw $t1, 4($a1)
add $t0, $t0, $t1
sll $t0, $t0, 3
addi $t0, $t0, 20
sub $sp, $sp, $t0
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
addi $t9, $sp, 12
move $s0, $t9
move $s1, $t0
move $t0, $a0
move $t1, $a1
lw $t2, 0($t0)
lw $t3, 0($t1)

	insertvaluesinbuffer1:
		lw $t4, 0($t2)
		lw $t5, 4($t2)
		sw $t4, 0($t9)
		sw $t5, 4($t9)
		lw $t4, 8($t2)
		beq $t4, $zero, moveontonextinsert
		move $t2, $t4
		addi $t9, $t9, 8
		j insertvaluesinbuffer1

moveontonextinsert:
addi $t9, $t9, 8
	
	insertvaluesinbuffer2:
		lw $t4, 0($t3)
		lw $t5, 4($t3)
		sw $t4, 0($t9)
		sw $t5, 4($t9)
		lw $t4, 8($t3)
		beq $t4, $zero, endinsertingvalues
		move $t3, $t4
		addi $t9, $t9, 8
		j insertvaluesinbuffer2

endinsertingvalues:
addi $t9, $t9, 8
sw $zero, 0($t9)
li $t0, -1
sw $t0, 4($t9)
move $a0, $s0
li $a1, -1
jal create_polynomial_2
j endaddpoly

returnsecondpoly:
	beq $a1, $zero, returnnullforaddpoly
	move $v0, $a1
	jr $ra

returnfirstpoly:
	move $v0, $a0
	jr $ra
	
returnnullforaddpoly:
	li $v0, 0
	jr $ra

endaddpoly:
  move $t0, $s1
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  add $sp, $sp, $t0
  jr $ra

.globl mult_polynomial
mult_polynomial:
beq $a0, $zero, returnnullformult
beq $a1, $zero, returnnullformult
lw $t2, 4($a0)
lw $t3, 4($a1)
mul $t2, $t2, $t3
sll $t2, $t2, 3
addi $t2, $t2, 20
sub $sp, $sp, $t2
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
move $s1, $t2
addi $t9, $sp, 12
move $s0, $t9
move $t0, $a0
move $t1, $a1
lw $t2, 0($t0)
lw $t3, 0($t1)

	multvalues:
		lw $t4, 0($t2)
		lw $t5, 0($t3)
		mul $t4, $t4, $t5
		sw $t4, 0($t9)
		lw $t4, 4($t2)
		lw $t5, 4($t3)
		add $t4, $t4, $t5
		sw $t4, 4($t9)
		lw $t4, 8($t3)
		beq $t4, $zero, shiftfirstop
		move $t3, $t4
		
		getbacktomultvalues:
			addi $t9, $t9, 8
			j multvalues
		
	shiftfirstop:
		lw $t4, 8($t2)
		beq $t4, $zero, endmultvalues
		move $t2, $t4
		lw $t3, 0($t1)
		j getbacktomultvalues	

returnnullformult:
	li $v0, 0
	jr $ra
	
endmultvalues:
addi $t9, $t9, 8
sw $zero, 0($t9)
li $t0, -1
sw $t0, 4($t9)
move $a0, $s0
li $a1, -1
jal create_polynomial_2

endmultpoly:
  move $t0, $s1
  lw $ra, 0($sp)
  lw $s0, 4($sp)
  lw $s1, 8($sp)
  add $sp, $sp, $t0
  jr $ra
