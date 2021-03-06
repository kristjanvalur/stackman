/*
 * this file is provided for where inline assembly is not
 * dependable, such as with clang on linux x86_64 or if
 * STACKMAN_INLINE_ASM is false
 * The file is generated using
 * "arm-linux-gnueabi-gcc -S gen_asm.c" and then copying the code
 * from gen_asm.s into this file.
 * 
 */
	.arch armv5t
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"gen_asm.c"
	.text
	.align	2
	.global	stackman_switch
	.syntax unified
	.arm
	.fpu softvfp
	.type	stackman_switch, %function
stackman_switch:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r3, r4, r5, r6, r7, r8, r9, r10, fp, lr}
	mov	r3, r0
	mov	r0, r1
	.syntax divided
@ 84 "../platforms/switch_arm_gcc.h" 1
	mov r2, sp
@ 0 "" 2
	.arm
	.syntax unified
	mov	r1, #0
	mov	r5, r0
	mov	r4, r3
	blx	r3
	mov	r2, r0
	.syntax divided
@ 88 "../platforms/switch_arm_gcc.h" 1
	mov sp, r0
@ 0 "" 2
	.arm
	.syntax unified
	mov	r1, #1
	mov	r0, r5
	blx	r4
	pop	{r3, r4, r5, r6, r7, r8, r9, r10, fp, pc}
	.size	stackman_switch, .-stackman_switch
	.align	2
	.global	stackman_call
	.syntax unified
	.arm
	.fpu softvfp
	.type	stackman_call, %function
stackman_call:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, fp, lr}
	add	fp, sp, #12
	mov	r5, r0
	mov	r0, r1
	mov	r3, r2
	.syntax divided
@ 104 "../platforms/switch_arm_gcc.h" 1
	mov r4, sp
@ 0 "" 2
@ 105 "../platforms/switch_arm_gcc.h" 1
	mov r2, sp
@ 0 "" 2
	.arm
	.syntax unified
	cmp	r3, #0
	beq	.L4
	.syntax divided
@ 109 "../platforms/switch_arm_gcc.h" 1
	mov sp, r3
@ 0 "" 2
	.arm
	.syntax unified
.L4:
	mov	r1, #2
	blx	r5
	.syntax divided
@ 113 "../platforms/switch_arm_gcc.h" 1
	mov sp, r4
@ 0 "" 2
	.arm
	.syntax unified
	pop	{r4, r5, fp, pc}
	.size	stackman_call, .-stackman_call
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",%progbits
