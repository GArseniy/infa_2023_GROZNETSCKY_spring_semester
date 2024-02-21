extern io_get_dec, io_print_dec, io_print_char, io_newline


section .data
    max dd 1

    
section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_dec
    mov esi, eax
    
    call io_get_dec
    
    mov edi, 1
    
    mov ebx, 0
    
.L_read:
    inc ebx
    
    cmp ebx, esi
    je .end
    
    push eax
    call io_get_dec
    
    cmp eax, [esp]
    jg .high
    
    cmp [max], edi
    jge .more
    
    mov [max], edi
    
.more:
    mov edi, 1
    add esp, 4
    
    jmp .L_read
    
.high:
    add esp, 4
    
    inc edi
    jmp .L_read


.end:
    cmp [max], edi
    jl .swap
    
    mov eax, [max]
    call io_print_dec        

    xor eax, eax
    ret



.swap:
    mov [max], edi
    jmp .end
