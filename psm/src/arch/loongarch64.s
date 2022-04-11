#include "psm.h"

.text
.globl rust_psm_stack_direction
.p2align 2
.type rust_psm_stack_direction,@function
rust_psm_stack_direction:
/* extern "C" fn() -> u8 */
.cfi_startproc
    li.d $a0, STACK_DIRECTION_DESCENDING
    jr $ra
.rust_psm_stack_direction_end:
.size       rust_psm_stack_direction,.rust_psm_stack_direction_end-rust_psm_stack_direction
.cfi_endproc


.globl rust_psm_stack_pointer
.p2align 2
.type rust_psm_stack_pointer,@function
rust_psm_stack_pointer:
/* extern "C" fn() -> *mut u8 */
.cfi_startproc
    move $a0, $sp
    jr $ra
.rust_psm_stack_pointer_end:
.size       rust_psm_stack_pointer,.rust_psm_stack_pointer_end-rust_psm_stack_pointer
.cfi_endproc


.globl rust_psm_replace_stack
.p2align 2
.type rust_psm_replace_stack,@function
rust_psm_replace_stack:
/* extern "C" fn(a0: usize, a1: extern "C" fn(usize), a2: *mut u8) */
.cfi_startproc
    move $s7, $a1
    move $sp, $a2
    jr $a1
.rust_psm_replace_stack_end:
.size       rust_psm_replace_stack,.rust_psm_replace_stack_end-rust_psm_replace_stack
.cfi_endproc


.globl rust_psm_on_stack
.p2align 2
.type rust_psm_on_stack,@function
rust_psm_on_stack:
/* extern "C" fn(a0: usize, a1: usize, a2: extern "C" fn(usize), a3: *mut u8) */
.cfi_startproc
    st.d $sp, $a3, -8
    st.d $ra, $a3, -16
    .cfi_def_cfa 7, 0
    .cfi_offset 1, -16
    .cfi_offset 3, -8
    move $s7, $a2
    addi.d $sp, $a3, -16
    jirl $ra, $a2, 0
    .cfi_def_cfa 3, 16
    ld.d $ra, $sp, 0
    .cfi_restore 1
    ld.d $sp, $sp, 8
    .cfi_restore 3
    jr $ra
.rust_psm_on_stack_end:
.size       rust_psm_on_stack,.rust_psm_on_stack_end-rust_psm_on_stack
.cfi_endproc
