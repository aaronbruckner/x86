;
; Examines stdin and dumps the hex values for raw bytes out to stdout.
;

section .data
    byteToHexTable db "0123456789ABCDEF"
    hexOutputStr db "__ __ __ __ __ __ __ __ __ __ __ __ __ __ __ __", 10
    HEX_OUTPUT_LEN equ $-hexOutputStr
    CLEAR_CHAR equ 32       ; ASCII space character

section .bss
    BUFF_LEN equ 16
    buffer resb BUFF_LEN

section .text
    global	_start

;-------------------------------------------------------------------------
; loadStdIn: Loads data from Standard In.
; IN: 		Nothing
; RETURNS:	Number of bytes read (eax).
; MODIFIES: 	eax, buffer
; CALLS:	sys_read
; DESCRIPTION:	Loads the next 16 bytes from Standard In (file descriptor 0) into "buffer". After return, eax will contain
;               the total bytes read into "buffer".
loadStdIn:
    ; Preserve registers
    push ebx
    push ecx
    push edx

    ; Execute sys_read
    mov eax, 3          ; System call: sys_read
    mov ebx, 0          ; File: StdIn
    mov ecx, buffer     ; Fill buffer with data
    mov edx, BUFF_LEN   ; Set max number of bytes to read.
    int 80h             ; Execute

    ; Restore registers
    pop edx
    pop ecx
    pop ebx

    ret   ; Return to caller

;-------------------------------------------------------------------------
; byteToHex: Converts 1 byte to two ASCII Hex characters.
; IN: 		Byte to convert (al)
; RETURNS:	Two hex characters in ASCII (ax).
; MODIFIES: 	ax
; CALLS:	Nothing
; DESCRIPTION:	Takes a single unsigned byte as input via register al. This byte is then converted into its hex representation.
;               The two hex digits are stored in ax in ASCII format.
byteToHex:
    ; Preserve Registers
    push ebx

    ; Translate high nybble
    mov ebx, 0                      ; clear out register ebx
    mov bl, al                      ; Store a copy of the byte to convert in ebx
    shr ebx, 4                      ; Grab upper 4 bit nybble
    mov ah, [byteToHexTable + ebx]  ; Translate upper nybble

    ; Translate low nybble
    mov bl, al                      ; Store a copy of the byte to convert in ebx
    and bl, 0Fh                     ; Grab the lower 4 bit nybble
    mov al, [byteToHexTable + ebx]  ; Translate lower nybble

    ; Restore Registers
    pop ebx

    ret     ; Return to caller

exitSuccess:
    mov eax, 1
    mov ebx, 0
    int 80h

exitFailure:
    mov eax, 1
    mov ebx, 1
    int 80h

_start:
    ; Clears the output buffer of any previous bytes.
    mov al, CLEAR_CHAR            ; Set the character used to clear the buffer
    mov ecx, HEX_OUTPUT_LEN - 1   ; Clear all but the last character in the buffer
    mov edi, hexOutputStr         ; Specify which buffer to clear
    rep stosb                     ; Overwrite buffer with char in al

    ; Read 16 bytes from stdin
    call loadStdIn

    ; Check how many bytes were read, exit if 0 or less (negative return indicates failure)
    cmp eax, 0
    je exitSuccess      ; Zero bytes read, exit successfully
    jl exitFailure      ; Negative response, exit with error.

    ; Set up loop to process each byte read in via stdin
    mov ecx, eax;

.processByte:
    ; For each byte:
    ; Convert byte into two hex characters. Add to Hex string buffer.
    mov al, [buffer + ecx - 1]    ; Store current byte to translate into al
    call byteToHex                ; Invoke convert function, ax will contain the two hex ASCII bytes

    ; Store ASCII hex digits into hex string. ebx contains address of where the next two hex characters will be inserted
    lea ebx, [hexOutputStr + ecx * 3 - 3]   ; Each index is 3 bytes long. ecx contains count. Subtract 3 as ecx is total count, not index.
    mov [ebx], ah                           ; Write high character first
    mov [ebx + 1], al                       ; Write low character last

    ; For each byte:
    ; Convert byte into printable character. All non-printable characters should be translated to periods. Add to ASCII string.

    ; Continue to next byte if more remain
    loop .processByte

    ; Execute sys_write
    mov eax, 4                ; System call: sys_write
    mov ebx, 1                ; File: StdOut
    mov ecx, hexOutputStr     ; Fill buffer with data
    mov edx, HEX_OUTPUT_LEN   ; Set max number of bytes to read.
    int 80h                   ; Execute

    ; Repeat until stdin is depleted.
    jmp _start          ; Process more bytes