section .data
    map: db "abc"
section .text
    global	_start

_start:
	  nop

    ; Sandbox code start
    mov eax, 0xFFFFFFFF
    mov eax, byte [map]
    ; Sandbox code stop

    nop