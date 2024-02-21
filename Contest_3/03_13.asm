extern io_get_udec, io_print_udec, io_print_char


section .bss
    a resd 1000000


section .text
global main
main:
    mov ebp, esp; for correct debugging

    call io_get_udec    
    mov esi, eax

    mov ebx, -1
    
.L_read:
    inc ebx
    cmp ebx, esi
    je .process
    
    call io_get_udec
    
    mov [a + 4 * ebx], eax
    jmp .L_read
    
.process:
    call io_get_udec
    mov ecx, eax
    
    mov eax, 0xFFFFFFFF
    shl eax, cl
    not eax
    
    and eax, [a + 4 * esi - 4]
    
    sub ecx, 32
    neg ecx
    shl eax, cl
    neg ecx
    add ecx, 32
    
    mov edi, eax
    
    mov ebx, -1
    
.L_shift:
    inc ebx
    cmp ebx, esi
    je .print
    
    mov eax, 0xFFFFFFFF
    shl eax, cl
    not eax
    
    and eax, [a + 4 * ebx]
    
    sub ecx, 32
    neg ecx
    shl eax, cl
    neg ecx
    add ecx, 32
    
    mov edx, eax
    
    mov eax, [a + 4 * ebx]
    shr eax, cl
    or eax, edi
    mov [a + 4 * ebx], eax
    
    mov edi, edx
    jmp .L_shift
    
    
.print:
    mov ebx, -1
    
.L_print:
    inc ebx
    cmp ebx, esi
    je .end
    
    mov eax, [a + 4 * ebx]
    call io_print_udec
    
    mov eax, ' '
    call io_print_char
    
    jmp .L_print
    
.end:
    xor eax, eax
    ret