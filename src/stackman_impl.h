#pragma once
#ifndef STACKMAN_IMPL_H
#define STACKMAN_IMPL_H

/*
 * Header to define the implementation for stackman_switch()
 * Include this file from a .c file or a .S file.  Preprocessor
 * defines:
 * STACKMAN_SWITCH_IMPL_ASM - define to 1 if file is included from a .S file
 * STACKMAN_SWITCH_STATIC - define to provide static linkage to stackman_switch()
 * 
 * See also stackman.h for main incle api
 */

#define STACKMAN_SWITCH_IMPL
#include "platforms/platform.h"
#endif

#if !STACKMAN_SWITCH_IMPL_ASM
#include "stackman_switch.h"
STACKMAN_SWITCH_STORAGE
void *stackman_switch_noinline(stackman_cb_t callback, void *context)
{
	/* Use a volatile pointer to prevent inlining of stackman_switch().
     * See Stackless issue 183 
     * https://github.com/stackless-dev/stackless/issues/183
     */
#ifndef STACKMAN_EXTERNAL_ASM
    static void *(*volatile stackman_switch_ptr)(stackman_cb_t callback, void *context) = stackman_switch;
    return stackman_switch_ptr(callback, context);
#else
    /*external assembler cannot be inlined */
    return stackman_switch(callback, context);
#endif
}

#endif