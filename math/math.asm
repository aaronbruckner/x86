;
; Contains different math-based instruction tests.
;

section .data

section .text
    global	_start

_start:
    nop

    ; 2 x 3, no overflow
    mov al, 2       ; al is implicit operand
    mov bl, 3       ; bl is explicit operand
    mul bl          ; al x bl, stored in ax

    ; use dbg command `info reg` to view flag status

    ; 100 X 9, Overflow
    mov al, 100
    mov bl, 9
    mul bl

    nop