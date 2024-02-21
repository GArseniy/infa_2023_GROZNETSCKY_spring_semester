extern io_get_dec, io_print_dec


section .text
global main
main:
    mov ebp, esp; for correct debugging

    call io_get_dec
    push eax
    call io_get_dec
    push eax
    
    call gcd
    add esp, 2*4

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