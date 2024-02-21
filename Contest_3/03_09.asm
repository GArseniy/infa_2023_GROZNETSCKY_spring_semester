extern io_get_dec, io_print_string


section .rodata
    yes db "YES", 0
    no db "NO", 0


section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_dec
    mov esi, eax
    
    call io_get_dec
    mov edi, eax
    
    
    mov ebx, 3
.L_get_point:
    dec ebx
    
    call io_get_dec
    mov ecx, eax

    push ecx
    call io_get_dec
    pop ecx
    mov edx, eax
    
    cmp esi, ecx
    je .L_get_point
    cmp edi, edx
    je .L_get_point
    

.L_skip_point:
    test ebx, ebx
    je .get_insert_point
    
    dec ebx
    
    push edx
    push ecx
    call io_get_dec
    call io_get_dec
    pop ecx
    pop edx
    
    jmp .L_skip_point

.get_insert_point:
    push edx
    push ecx
    
    call io_get_dec
    mov ebx, eax
    
    call io_get_dec
    xchg eax, ebx
    
    pop ecx
    pop edx
    
    sub ecx, eax
    sub esi, eax
    imul esi, ecx
    
    sub edx, ebx
    sub edi, ebx
    imul edi, edx
    
    cmp esi, 0
    jnl .no
    cmp edi, 0
    jnl .no
    
    
.yes:    
    mov eax, yes
    call io_print_string
    jmp .end

.no:
    mov eax, no
    call io_print_string
    jmp .end
    
.end:
    xor eax, eax
    ret