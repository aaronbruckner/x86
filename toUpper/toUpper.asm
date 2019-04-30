;
; Takes stdin, upper-cases all ascii characters, and prints then to stdout.
;

section .data
    bufferLength equ 100        ; Set max buffer length to 100

section .bss
    buffer: resb bufferLength   ; Reserve 100 byte buffer to load characters into.

section .text
    global	_start

_start:

    ; Read characters into buffer from stdin.
    mov eax, 3              ; System Call - Read
    mov ebx, 0              ; Use File: Stdin
    mov ecx, buffer         ; Set buffer to load data into
    mov edx, bufferLength   ; Set max buffer size
    int 80h                 ; Execute Read

    ; Check how many bytes were read. If zero bytes were read, terminate program.
    ; If less than zero, exit with failure.
    cmp eax, 0
    je exit                 ; If return is zero, successfully exit.
    jl failure              ; If return negative, exit with error.

    ; At this point, we have bytes to process (eax was greater than zero)
    mov ebx, 0            ; Set initial offset to 0, use reg b to iterate through buffer.

processCharacterStart:
    ; Iterate over each character in buffer.
    ; If individual character is between 97 (a) and 122 (z), subtract 32 from it (converting it to upper case).
    cmp byte[buffer + ebx], 97          ; ebx contains current offset into buffer.
    jl processCharacterLoopCheck    ; Continue if current byte is less than 97
    cmp byte [buffer + ebx], 122
    jg processCharacterLoopCheck    ; Continue if current byte is greater than 122

    ; At this point, the character is a-z. Convert to upper case by subtracting 32.
    sub byte[buffer + ebx], 32

processCharacterLoopCheck:
    inc ebx
    cmp ebx, eax
    jl processCharacterStart

    ; Push buffer to stdout.
    mov edx, eax          ; Push a to d, a contains the total bytes read into the buffer.
    mov eax, 4            ; System Call - Write
    mov ebx, 1            ; Use file - Stdout
    mov ecx, buffer       ; Use buffer that we've read bytes into and modified if required.
    int 80h               ; Execute Write

    ; If return is less than 0, error occurred
    cmp eax, 0
    jl failure

    ; Read more characters from stdin if available and repeat.
    jmp _start

; Invoked when the program finishes successfully.
exit:
    mov eax, 1        ; System Call - Exit
    mov ebx, 0        ; Return 0 - Success
    int 80h           ; Execute Exit

; Invoked if the program reaches a negative state.
failure:
    mov eax, 1        ; System Call - Exit
    mov ebx, 1        ; Return 1 - Failure
    int 80h           ; Execute Exit