extern io_get_udec, io_print_udec


section .bss
    a resd 1000
    

section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_udec
    mov esi, eax
    mov ebx, -1
    
    
.L_read:
    inc ebx
    cmp esi, ebx
    je .process
    
    call io_get_udec
    mov [a + 4 * ebx], eax
    
    jmp .L_read
    

.process:
    call io_get_udec
    mov edi, eax
    mov ecx, -1
    mov ebx, 0
    
.L_counter:
    inc ecx
    cmp esi, ecx
    je .end
    
    
    push ecx
    push dword[a + 4 * ecx]
    call f_count
    add esp, 4
    pop ecx
    
    
    mov edx, 0
    cmp eax, edi
    sete dl
    
    add ebx, edx
    jmp .L_counter
    

.end:
    mov eax, ebx
    call io_print_udec
    
    xor eax, eax
    ret


f_count:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]
    mov ecx, 32
    mov edx, 0

.for:
    test ecx, ecx
    je .ret
    dec ecx
    
    shl eax, 1
    jnc .for
    
    test edx, edx
    je .one
    
    dec edx
    
    jmp .for
    
.one:
    mov edx, ecx
    jmp .for
    
    
.ret:
    mov eax, edx
    
    leave
    ret
