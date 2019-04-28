;
; Contains different memory manipulation tests.
;

section .data

section .text
    global	_start

_start:
    nop

    ; The following tests how little endian constants are interpreted.
    mov eax, 04030201h  ; least significant byte is 1, most significant byte is 4.
    mov bl, al          ; move least significant byte into b (which should be 1).
    mov cl, ah          ; move second least significant byte into c (which should be 2).
    mov dx, ax          ; move the two lest significant bytes into d.

    mov eax, 'WXYZ'     ; Character stream. W is least significant while Z is most significant.
    mov bl, al          ; Move W into b.
    mov cl, ah          ; Move X into c.

    nop