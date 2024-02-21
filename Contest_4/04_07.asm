extern io_get_dec, io_print_dec


MOD equ 2011


section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_dec
    mov esi, eax

    call io_get_dec
    mov ebx, eax

    call io_get_dec

    mov edi, MOD
    mov edx, 0
    div edi
    
    mov eax, edx

.L_y:
    test ebx, ebx
    je .end
    dec ebx
    
    imul eax, eax
    
    push esi
    push eax
    call reverse
    add esp, 2 * 4
    
    mov edx, 0
    div edi
    mov eax, edx
    
    jmp .L_y 
    
    
.end:
    call io_print_dec
    
    xor eax, eax
    ret
    
 
reverse:
    push ebp
    mov ebp, esp
    push ebx
 
    
    mov eax, [ebp + 8]
    mov ebx, 0
    mov ecx, [ebp + 12]
    
.L_Horner:
    test eax, eax
    je .ret
    
    mov edx, 0
    div ecx
    
    imul ebx, ecx
    add ebx, edx
    
    jmp .L_Horner
    
.ret:
    mov eax, ebx
    
    pop ebx
    leave
    ret
