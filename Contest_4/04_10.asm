extern io_get_dec, io_print_dec, io_print_char


section .bss
    n resd 1
    num resd 1
    den resd 1
    new_num resd 1
    new_den resd 1


section .text
global main
main:
    mov ebp, esp; for correct debugging

    call io_get_dec
    mov [n], eax
    
    call io_get_dec
    mov [num], eax
    
    call io_get_dec
    mov [den], eax
    
    
    mov esi, [n]
    
.L_sum:
    cmp esi, 1
    je .end
    dec esi

    call io_get_dec
    mov [new_num], eax

    call io_get_dec
    mov [new_den], eax

    mov eax, [num]
    imul eax, [new_den]
    mov [num], eax
    
    mov ebx, [new_num]
    imul ebx, [den]
    
    add [num], ebx
    
    mov eax, [den]
    imul eax, [new_den]
    mov [den], eax
    
    push dword[den]
    push dword[num]
    
    call gcd
    
    add esp, 2 * 4
    
    mov edi, eax
    
    mov eax, [num]
    cdq
    idiv edi
    mov [num], eax
    
    mov eax, [den]
    cdq
    idiv edi
    mov [den], eax
    
    jmp .L_sum
    
    
.end:
    mov eax, [num]
    call io_print_dec
    
    mov eax, ' '
    call io_print_char
    
    mov eax, [den]
    call io_print_dec

    xor eax, eax
    ret
    
    
gcd:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 12]
    
    test ebx, ebx
    jne .recursive
    
    mov eax, [ebp + 8]
    
    
    mov esp, ebp
    pop ebp
    ret
    
.recursive:
    mov eax, [ebp + 8]
    cdq
    div dword[ebp + 12]
    
    
    push edx
    push dword[ebp + 12]
    
    call gcd
    
    add esp, 2*4
    
    mov esp, ebp
    pop ebp
    ret
