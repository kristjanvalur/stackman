/* gcc implementationfor X86 (32 bit), inline assembly */

/* clang cannot perform inline assembly using specific __attr__
 * instructions, and so it may use a base pointer and other
 * things.  We must force it to use the pre-build assembler
 */
#if !defined(STACKMAN_EXTERNAL_ASM)
#if defined (__clang__) || STACKMAN_PREFER_ASM
#define STACKMAN_EXTERNAL_ASM "platforms/switch_x86_gcc.S"
#endif
#endif

#define STACKMAN_HAVE_CALL 1
#define STACKMAN_STACK_ALIGN 16

#if defined(STACKMAN_SWITCH_IMPL )
#if !__ASSEMBLER__ && !defined(STACKMAN_EXTERNAL_ASM)

/* Follow System V i386 abi, including 16 byte stack alignment 
 * https://wiki.osdev.org/System_V_ABI#i386
 * eax, ecx, edx are scratch regs, 
 * ebp, ebx, esi, edi are callee-preserved
 * We have compiler construct a frame and push ebp
 * an then we fix an aligned stack pointer and just store
 * the arguments in proper places.
 * The function calls need to be assembler coded because a compiler
 * generated call will adjust stack pointer, but the restore
 * opcode will be placed _after_ we ourselves then modify esp,
 * ruining everything.
 * So, we use C to set up frame, pass arguments in and out,
 * and preserve registers. But we ourselves assemble the 
 * calls and stack pointer changes
 *
 * This file can be excercised on 64 bit linux by adding -m32 to
 * the gcc command line.
 */
#include "../stackman_switch.h"

# define PRESERVED "ebx", "esi", "edi"

__attribute__((optimize("O1", "no-omit-frame-pointer")))
STACKMAN_LINKAGE_SWITCH
void *stackman_switch(stackman_cb_t callback, void *context)
{
void *result;
  /* push registers, set up stack pointer on boundary */
    __asm__("" ::: PRESERVED);
    __asm__(

      /* adjust stack pointer to be 16 byte (4 quad) aligned with 
       * room for call args
       * since the call instruction, 5 quads have
       * been pushed (ip, bp, bx, si, di), need extra 3 quads
       * for alignment, which fits our three quad call args.
       */
    "subl $12, %%esp\n"
    "movl %[cb], %%esi\n"  /* save 'callback' for later */
    "movl %[ctx], %%edi\n" /* save 'context' for later         */

    /* first call */     
    "movl %%esp, 8(%%esp)\n"  /* arg 2 sp */
    "movl $0, 4(%%esp)\n"     /* arg 1 opcode STACKMAN_OP_SAVE */
    "movl %%edi, 0(%%esp)\n"  /* arg 0 context */
    "call *%%esi\n"

    /* restore esp */
    "movl %%eax, %%esp\n"
     
    /* second call */
    "movl %%eax, 8(%%esp)\n"  /* arg 2 sp */
    "movl $1, 4(%%esp)\n"     /* arg 1 opcode STACKMAN_OP_RESTORE */
    "movl %%edi, 0(%%esp)\n"  /* arg 0 context */
    "call *%%esi\n"

    "movl %%eax, %[result]\n"

    "addl $12, %%esp\n"
    : [result] "=r" (result)              /* output variables */
    : [cb] "r" (callback),       /* input variables  */
      [ctx] "r" (context)
    );
    return result;
}

/* 
 * Similar, but we want the base pointer so that a debugger
 * can follow the stack
 */
__attribute__((optimize("O1", "no-omit-frame-pointer")))
STACKMAN_LINKAGE_SWITCH
void *stackman_call(stackman_cb_t callback, void *context, void *stack_pointer)
{
  void *old_sp, *result;
  
  /* sp = store stack pointer in ebx */
  __asm__ ("movl %%esp, %%ebx" : : : "ebx");
  __asm__ ("movl %%esp, %[sp]" : [sp] "=r" (old_sp));
  
  /* set stack pointer from provided using assembly */
  __asm__ ("movl %[sp], %%esp" :: [sp] "r" (stack_pointer));

  result = callback(context, STACKMAN_OP_CALL, old_sp);
  /* restore stack pointer */
  __asm__ ("movl %%ebx, %%esp" :::);
  
  return result;
}

#endif

#if __ASSEMBLER__ && defined(STACKMAN_EXTERNAL_ASM)
/* pre-generated assembly code */
#include STACKMAN_EXTERNAL_ASM
#endif

#endif /* STACKMAN_SWITCH_IMPL */
