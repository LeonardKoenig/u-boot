
.globl tap_cal_16b
.ent   tap_cal_16b

tap_cal_16b:

	li	$t1,0x80600000 
	li	$t0,0xffffffff 
	 
	sw	$t0,0x0($t1) 
	sw	$t0,0x4($t1) 
	sw	$t0,0x8($t1) 
	sw	$t0,0xc($t1) 
	 
	nop 
	nop

ddr_pat_init:
	li 	$t8, 0xa0002000
	li	$t0, 0x00
	li	$t1, 0x100	
write_loop_start:
	andi    $t2, $t0, 0x03
pat_000:
	li	$t3, 0x00
	bne	$t2, $t3,pat_001
	li 	$t9, 0x00000000
	sw	$t9, 0x0 ($t8)
	b	pat_004

pat_001:
	li	$t3, 0x01
	bne	$t2, $t3,pat_002
	li 	$t9, 0x0000ffff
	sw	$t9, 0x0 ($t8)
	b	pat_004

pat_002:
	li	$t3, 0x02
	bne	$t2, $t3,pat_003
	li 	$t9, 0xffff0000
	sw	$t9, 0x0 ($t8)
	b	pat_004

pat_003:
	li	$t3, 0x03
	bne	$t2, $t3,pat_004
	li 	$t9, 0xffffffff
	sw	$t9, 0x0 ($t8)

pat_004:
	andi    $t2, $t0, 0x0c
	li	$t3, 0x00
	bne	$t2, $t3,pat_005
	li 	$t9, 0x00000000
	sw	$t9, 0x4 ($t8)
	b	pat_008

pat_005:
	li	$t3, 0x04
	bne	$t2, $t3,pat_006
	li 	$t9, 0x0000ffff
	sw	$t9, 0x4 ($t8)
	b	pat_008

pat_006:
	li	$t3, 0x08
	bne	$t2, $t3,pat_007
	li 	$t9, 0xffff0000
	sw	$t9, 0x4 ($t8)
	b	pat_008

pat_007:
	li	$t3, 0x0c
	bne	$t2, $t3,pat_008
	li 	$t9, 0xffffffff
	sw	$t9, 0x4 ($t8)

pat_008:
	andi    $t2, $t0, 0x30
	li	$t3, 0x00
	bne	$t2, $t3,pat_009
	li 	$t9, 0x00000000
	sw	$t9, 0x8 ($t8)
	b	pat_00c

pat_009:
	li	$t3, 0x10
	bne	$t2, $t3,pat_00a
	li 	$t9, 0x0000ffff
	sw	$t9, 0x8 ($t8)
	b	pat_00c

pat_00a:
	li	$t3, 0x20
	bne	$t2, $t3,pat_00b
	li 	$t9, 0xffff0000
	sw	$t9, 0x8 ($t8)
	b	pat_00c

pat_00b:
	li	$t3, 0x30
	bne	$t2, $t3,pat_00c
	li 	$t9, 0xffffffff
	sw	$t9, 0x8 ($t8)

pat_00c:
	andi    $t2, $t0, 0xc0
	li	$t3, 0x00
	bne	$t2, $t3,pat_00d
	li 	$t9, 0x00000000
	sw	$t9, 0xc ($t8)
	b	pat_done

pat_00d:
	li	$t3, 0x40
	bne	$t2, $t3,pat_00e
	li 	$t9, 0x0000ffff
	sw	$t9, 0xc ($t8)
	b	pat_done

pat_00e:
	li	$t3, 0x80
	bne	$t2, $t3,pat_00f
	li 	$t9, 0xffff0000
	sw	$t9, 0xc ($t8)
	b	pat_done

pat_00f:
	li	$t3, 0xc0
	bne	$t2, $t3,pat_done
	li 	$t9, 0xffffffff
	sw	$t9, 0xc ($t8)

pat_done:

	addiu	$t0, $t0, 0x1
	addiu	$t8, $t8, 0x10
	bne	$t0, $t1, write_loop_start
	



###### ddr init over #########

	li	$a0, 0xa0002000
	li	$a1, 0x80002000	     ### Start address of the pattern   200
	li	$a2, 0x80003000	     ### End Address of the pattern     220
	li	$t0, 0xb800001c	     ## Tap settings addr
	lw	$a3, 0x0($t0)	     ## loading default tap value
	nop
	ori	$t0, $a3, 0x0
	nop
	li	$t1, 0x1	     ## $t1=1 indicates increasing tap value, 0 = decreasing

load_tap:

	li	$t7, 0x2#li	$t7, 0x200	## No. of times read has to happen for 1 tap setting
	li	$t8, 0xb8000000	#### Loading Tap Setting
	sw	$t0, 0x1c($t8)
	nop
	sw	$t0, 0x20($t8)
	nop
#if DDR2_32BIT_SUPPORT /* Hornet doesn't have DQS2, DQS3*/
	sw	$t0, 0x24($t8)
	nop
	sw	$t0, 0x28($t8)
	nop
#endif	

###### t0 stores current tap setting under test
###### t1 indicates increment or decrement of tap 

pat_read:
	ori	$t2, $a0, 0x0	
	nop
	ori	$t3, $a1, 0x0
	nop
	ori	$t4, $a2, 0x0
	nop

tap_addr_loop:
	lw	$t5, 0x0($t2)
	nop
	lw	$t6, 0x0($t3)
	nop
	nop
	
	bne	$t5, $t6, tap_fail  # jump to fail if not equal
	nop
	nop
	nop

	addiu	$t2, $t2, 0x4  #incrementing addr
	addiu	$t3, $t3, 0x4
	nop
	nop
	
	bne	$t3, $t4, tap_addr_loop # compare new addr if end addr not reached
	nop	
	
	addiu	$t7, $t7, -1     # read passed for all locations once hence decrement t7
	nop
	bnez	$t7, pat_read    # t7 = 0 represents passing of all locations for given tap
	nop
	nop
	
	bnez	$t1, tap_incr     # increment tap if t1 = 1
	nop
	nop
	
	bnez	$t0, tap_decr	  ## $t0=0 implies tap=0 works
	nop		          ## so low limit=0, else decrement tap value
	nop
	li	$t8, 0x80600000   ## assigning lower limit = 0
	sw	$t0, 0x0($t8)
	add	$t9, $t9, $t0     ##adding lower limit to upper limit (used to calc mid value)
	nop
	nop
	
	b tap_calc
	nop
	nop

tap_decr: 			# decrement t0 by 1 and move to loading this new tap
	addiu	$t0, $t0 , -1
	nop
	b load_tap
	nop
	nop

tap_incr:
	addiu	$t0, $t0 , 0x1
	nop
	xori	$v1, $t0, 0x20	# limiting upper limit to 0x20
	nop
	bnez	$v1, load_tap
	nop
	nop
	b up_limit
	nop
	nop

tap_fail:
	bnez	$t1, up_limit 	# t1=0 means lower limit detected @ fail else upper limit
	nop
	nop
	nop
	addiu	$t0, $t0, 0x1
	nop
	li	$t8, 0x80600000	# storing lower limit
	nop
	sw	$t0, 0x0($t8)
	add	$t9, $t9, $t0	# storing lower limit# adding lower limit and upper limit
	nop
	nop
	nop
	
	b tap_calc
	nop
	nop

up_limit:
	addiu	$t0, $t0, -1 
	li	$t1, 0x0	 ## changing to decreasing tap mode	
	li	$t8, 0x80600000 ## storing upper limit
	sw	$t0, 0x4($t8)	
	ori	$t9, $t0, 0x0	
	nop
	nop
	nop
	
	ori	$t0, $a3, 0x0 	# loading default tap value 
	nop
	b load_tap
	nop
	nop

tap_calc:  ## calculating mid value of the tap, storing DQS0, DQS1 in 0x80500008, 0x8050000c resp.
	li	$t7, 0x2
	nop
	div	$t9, $t7
	nop
	mfhi	$t6
	mflo	$t5
	nop
	nop
	add	$t6, $t6, $t5
	li	$t8, 0x80600000
	nop
	sw	$t5, 0x8($t8)
	nop
	sw	$t6, 0xc($t8)
	nop
	nop
	li      $t8, 0xb8000000  #### Loading Tap Setting
	nop
	sw      $t5, 0x1c($t8)
	nop
	sw      $t6, 0x20($t8)
	nop
#if DDR2_32BIT_SUPPORT  /* Hornet doesn't have DQS2, DQS3*/	
	sw      $t5, 0x24($t8)
	nop
	sw      $t6, 0x28($t8)
	nop
#endif	
	nop
	nop

	j  $ra
.end  tap_cal_16b

