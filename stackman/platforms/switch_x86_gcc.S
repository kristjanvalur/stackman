/*
 * this file is provided for where inline assembly is not
 * dependable, such as with clang on linux x86 or if
 * STACKMAN_INLINE_ASM is false. It provides a stable
 * implementation that is independent of subtleties of inline
 * assembly code which may change with compiler versions.
 * The file is generated using
 * "gcc -S -m32 -fcf-protection=none gen_asm.c"
 * and then copying the code from gen_asm.s into this file.
 * 
 */
	.file	"gen_asm.c"
	.text
	.globl	stackman_switch
	.type	stackman_switch, @function
stackman_switch:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
#APP
# 50 "../platforms/switch_x86_gcc.h" 1
	subl $0x1c, %esp
movl %eax, %esi
movl %edx, %edi
leal 0x10(%esp), %ebx
movl %ebx, 8(%esp)
movl $0, 4(%esp)
movl %edi, 0(%esp)
call *%esi
leal -0x10(%eax), %esp
subl %ebx, %eax
addl %eax, %ebp
leal 0x10(%esp), %eax
movl %eax, 8(%esp)
movl $1, 4(%esp)
movl %edi, 0(%esp)
call *%esi
movl %eax, %eax
addl $0x1c, %esp

# 0 "" 2
#NO_APP
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	stackman_switch, .-stackman_switch
	.globl	stackman_call
	.type	stackman_call, @function
stackman_call:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$4, %esp
	.cfi_offset 3, -12
	movl	16(%ebp), %eax
#APP
# 108 "../platforms/switch_x86_gcc.h" 1
	movl %esp, %ebx
# 0 "" 2
# 111 "../platforms/switch_x86_gcc.h" 1
	movl %esp, %edx
# 0 "" 2
#NO_APP
	testl	%eax, %eax
	je	.L4
#APP
# 117 "../platforms/switch_x86_gcc.h" 1
	movl %eax, %esp
# 0 "" 2
#NO_APP
.L4:
	subl	$4, %esp
	pushl	%edx
	pushl	$2
	pushl	12(%ebp)
	call	*8(%ebp)
#APP
# 124 "../platforms/switch_x86_gcc.h" 1
	movl %ebx, %esp
# 0 "" 2
#NO_APP
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	stackman_call, .-stackman_call
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
