/*
 *  Startup Code for Hornet 1.0 CPLD workaround
 *
 *  Copyright (c) 2010	Ryan Hsu <rhsu@atheros.com>
 */

#include <config.h>
#include <version.h>
#include <asm/regdef.h>
#include <asm/mipsregs.h>

	.globl hornet_cpld_war
	.text
	.align 4

/*
 * This file is mainly for the workaround for enabling CPLD function
 */


#define store_data(_val)    \
    li   t8, _val;           \
    sw   t8, 0(t7);          \
    addi t7, 4;

hornet_cpld_war:

#if CONFIG_HORNET_1_0_WAR

    /* if (0xb8050024 == 0x19)
          then do CPLD 
       else
          keep going
     */
/* normal path */
#if !defined(CONFIG_HORNET_ETH)
    li  t7, 0xb8050024
    lw  t8, 0(t7)            // t8 : value of 0xb8050024
    li  t9, 0x10          
    sw  t9, 0(t7);

    li  t7, 0xb806001c
    lw  t8, 0(t7)            // t8 : value of 0xb806001c
    li  t9, 0xffffbfff
    and t8, t8, t9           // t8:  deassert bit 14        
    sw  t8, 0(t7)
#endif

    li  t7, 0xb8050024
    lw  t8, 0(t7)            // t8 : value of 0xb8050024
    li  t9, 0x10          
    bne t8, t9, do_cpld      // if 0xb8050024 == 0x19 , go to do_cpld
    nop
    b normal_path

do_cpld:
    li  t9, 0x10;            // set 0xb8050024 to 0x10
    sw  t9, 0(t7);

    li  t7, 0xb8050000       // config cpu_pll pllpwd to 0x0
    lw  t8, 0(t7)            
    li  t9, 0xbfffffff       
    and  t8, t8, t9          // t8:  clear bit 30      
    sw  t8, 0(t7)

/* 
 * Start copying data to SRAM 
 */

li t7, 0xbd000000

store_data(0x3c0fb804)
store_data(0x8df80000)
store_data(0x3c190004)
store_data(0x0319c025)
store_data(0xadf80000)
store_data(0x3c0fb804)
store_data(0x35ef0008)
store_data(0x8df80000)
store_data(0x3c190004)
store_data(0x0319c025)
store_data(0xadf80000)
store_data(0x3c0fb804)
store_data(0x35ef0028)
store_data(0x8df80000)
store_data(0x34198000)
store_data(0x0319c025)
store_data(0xadf80000)
store_data(0x00000000)
store_data(0x00000000)
store_data(0x240e0000)
store_data(0x3c0d0006)
store_data(0x35ad1a80)
store_data(0x25ce0001)
store_data(0x01cd082a)
store_data(0x1420fffd)
store_data(0x00000000)
store_data(0x00000000)
store_data(0x03e00008)
store_data(0x00000000)
store_data(0x00000000)

li t7, 0xbd000000
jalr t7
    nop
    nop


normal_path:
    /* Push 0 through GPIO 18 */

    li  t7, 0xb8040008
    lw  t8, 0(t7)
    li  t9, 0x3
    or t8, t8, t9
    sw  t8, 0(t7)

#endif /* CONFIG_HORNET_1_0_WAR */

	nop
	jr 	ra
	nop
	nop
	
/*
 * Below are the code we're compiled separatly for triggering the CPLD to run
 *
 * a. configure the GPIO18 to ouput
 * b. configure GPIO18 to 1
 * c. configure GPIO_FUN bit15 to disable S26 Ethernet switch UART port
 * d. delay for 1 second, let CPLD to reset the CPU and start over again
 *
 * Description:
 *   Since the CPLD code can't run in flash or ddr, we're compiling it separately
 *   and copy it from flash to SRAM and jump to SRAM to trigger the CPLD
 *
 */
#if 0

    li  $t7, 0xb8040000       // Enable this GPIO
    lw  $t8, 0($t7)           // t8 : value of 0xb8040000
    li  $t9, 0x40000 
    or  $t8, $t8, $t9         // t8:  set bit 18       
    sw  $t8, 0($t7)

    li  $t7, 0xb8040008       // Set output value to 1 (push 1)
    lw  $t8, 0($t7)           // t8 : value of 0xb8040008
    li  $t9, 0x40000 
    or  $t8, $t8, $t9         // t8:  set bit 18       
    sw  $t8, 0($t7)

    li  $t7, 0xb8040028
    lw  $t8, 0($t7)           // t8 : value of 0xb8040028
    li  $t9, 0x8000 
    or  $t8, $t8, $t9         // t8:  set bit 15,  Disables S26 Ethernet switch UART port on the uart pins.
                              // set bit 12,  Enables observation of GE1 125 MHz clock on GPIO_17 pin.
    sw  $t8, 0($t7)
    nop
    nop

    /* delay */
    li  $t6, 0
    li  $t5, 0x61a80

delay_loop:
    addiu $t6, $t6, 1
    blt $t6, $t5, delay_loop  // delay for 1 seconds  
    nop
    nop
    
    jr $ra
    nop
    nop

#endif
