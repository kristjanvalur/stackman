;
; stack switching code for MASM on x64
; Kristjan Valur Jonsson, apr 2011
; Modified for stackman, dec 2019
; Added stackman_call, dec 2020
;

include macamd64.inc

pop_reg MACRO reg
	pop reg
ENDM

load_xmm128 macro Reg, Offset
	movdqa  Reg, Offset[rsp]
endm

.code

;arguments callback, context, are passed in rcx, rdx, respectively
stackman_switch PROC FRAME
	; push_reg, alloc_stack, save_xmm128, are macros that invoke the .prolog macros
	push_reg rbp

	push_reg r15
	push_reg r14
	push_reg r13
	push_reg r12
	push_reg rbx
	push_reg rdi
	push_reg rsi

	sub rsp, 168
	.allocstack 168	;8 bytes align, 10x16 bytes for xmm
	save_xmm128 xmm15, 144
	save_xmm128 xmm14, 128
	save_xmm128 xmm13, 112
	save_xmm128 xmm12, 96
	save_xmm128 xmm11, 80
	save_xmm128 xmm10, 64
	save_xmm128 xmm9,  48
	save_xmm128 xmm8,  32
	save_xmm128 xmm7,  16
	save_xmm128 xmm6,  0
	
	sub rsp, 20h
	.allocstack 20h
	lea rbp, 20h [rsp]
	.setframe rbp, 0
	.endprolog


	;save argments in nonvolatile registers
	mov r12, rcx ;callback
	mov r13, rdx ;context

	; load stack base that we are saving minus the callee argument
	; shadow stack.  We don't want that clobbered
	mov rcx, r13		;arg1, context
	mov rdx, 0			;arg2, opcode STACKMAN_OP_SAVE
	lea r8, [rsp+20h]   ;arg3, stack pointer
	mov rbx, rsp;		; keep old stack pointer
	call r12 ;

	;actual stack switch (and re-allocating the shadow stack):
	lea rsp, [rax-20h]
	;re-adjust base pointer
	sub rbx, rsp;
	sub rbp, rbx;
	
	mov rcx, r13		;arg1, context
	mov rdx, 1			;arg2, opcode STACKMAN_OP_RESTORE
	mov r8, rax 		;arg3, new stack pointer
	call r12
	;return the rax
	
	add rsp, 20h
	
	load_xmm128 xmm15, 144
	load_xmm128 xmm14, 128
	load_xmm128 xmm13, 112
	load_xmm128 xmm12, 96
	load_xmm128 xmm11, 80
	load_xmm128 xmm10, 64
	load_xmm128 xmm9,  48
	load_xmm128 xmm8,  32
	load_xmm128 xmm7,  16
	load_xmm128 xmm6,  0
	add rsp, 168
	pop_reg rsi
	pop_reg rdi
	pop_reg rbx
	
	pop_reg r12
	pop_reg r13
	pop_reg r14
	pop_reg r15
	
	ret
	
stackman_switch ENDP 
	
; based on template from https://docs.microsoft.com/en-us/cpp/build/exception-handling-x64?view=msvc-160
stackman_call PROC FRAME
    push rbp
    .pushreg rbp
	; now our stack is 16 byte aligned.  Need shadow stack for called function
    sub rsp, 020h
    .allocstack 020h
    lea rbp, [rsp+20h]
    .setframe rbp, 00h
    .endprolog

	; suffle arguments into volatile registers
	mov rax, rcx ; callback
	mov rcx, rdx ; context into first arg
	mov r9, r8   ; and stack pointer in volatile registers

	; set up call	
	mov r8, rsp
	mov	edx, 2
	; rcx already set up with context
	
	; modify stack pointer before call
	mov rsp, r9
	sub rsp, 32 ;pre-allocate parameter stack for the callee
	call rax

	; officialepilog
	lea rsp, [rbp+0h]
	pop rbp
	ret	0
stackman_call ENDP

END