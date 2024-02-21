extern io_get_udec, io_print_dec


section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_udec
    
    push eax
    call len_3
    add esp, 4
    
    call io_print_dec
    
    xor eax, eax
    ret


len_3:
    push ebp
    mov ebp, esp
    push ebx
    
    mov eax, [ebp + 8]
    
    test eax, eax
    je .end
    
    mov edx, 0
    mov ecx, 3
    
    div ecx
    mov ebx, edx
    
    
    push eax
    call len_3
    add esp, 4
    
    
    cmp ebx, 1
    je .inc
    jmp .ret
    
.inc:
    inc eax
    jmp .ret


.end:
    mov eax, 0
    jmp .ret
    

.ret:
    pop ebx
    leave 
    ret
