/*
 * Implement the slp_switch function, as used in
 * stackless python and greenlet, using the the
 * gevent library.
 *
 * Include this file in a compilation unit to define
 * the slp_switch() function.
 * The calling code must then either link with the
 * stackman library, or include stackman_impl.h
 * see the README file for usage details.
 *
 * This is a useful tool to transition from using
 * slp_switch to stackman_switch without modifying code.
 *
 */


#define SLP_STACK_REFPLUS 1


#ifdef SLP_EVAL

#include "../stackman_switch.h"

#define SLP_STACK_MAGIC 0

/* need a special function arount SLP_SAVE_STATE() because
 * the macro has a built-in return of 0 or -1.  Must catch
 * that.
 */
static int slp_stackman_cb_save(void *sp, intptr_t *pdiff)
{
    intptr_t diff;
    SLP_SAVE_STATE(sp, diff);
    *pdiff = diff;
    return 1;
}

static void *slp_stackman_cb(void *_ctxt, int opcode, void *sp)
{
    int *error = (int*)_ctxt;
    intptr_t stsizediff;
    if (opcode == STACKMAN_OP_SAVE)
    {
        int ret = slp_stackman_cb_save(sp, &stsizediff);
        if (ret == 1) {
            /* regular switch */
            return (void*)((char*)sp + stsizediff);
        } 
        if (ret == -1)
        {
            *error = -1;
        }
        /* error or save only, no change in sp */
        return sp;
    }
    else
    {
        if (*error != -1)
            SLP_RESTORE_STATE();
        return sp;
    }
}

static int
slp_switch(void)
{
    /* this can be on the stack, because if there isn't a switch
     * then it is intact. (error or save only) */
    int error = 0;
    stackman_switch(&slp_stackman_cb, &error);
    return error;
}

#include "stackman/src/stackman_impl.h"
#endif
