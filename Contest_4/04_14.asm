extern io_get_dec, io_print_dec


MOD equ 2011


section .bss
    k resd 1
    n resd 1
    
    
section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_dec
    mov [k], eax

    call io_get_dec
    mov [n], eax
    
    call io_get_dec
    cdq
    
    
    mov ecx, MOD
    div ecx
    
    mov esi, edx
    mov edi, esi
    
    
    mov ebx, [n]
    
.L_for:
    test ebx, ebx
    je .end
    dec ebx
    
    
    push dword[k]
    push esi
    push edi
    
    call f
    
    pop esi
    add esp, 2*4
    
    cdq
    mov ecx, MOD
    div ecx
    
    mov edi, edx

    jmp .L_for


.end:
    mov eax, edi
    call io_print_dec
    
    xor eax, eax
    ret 


f:
    push ebp
    mov ebp, esp
    
    
    mov ecx, [ebp + 16]
    mov eax, [ebp + 12]
    cdq
    
    div dword[ebp + 16]
    cdq
    
    
.L_degree:
    test eax, eax
    je .ret
    
    imul ecx, [ebp + 16]
    div dword[ebp + 16]
    cdq
    
    jmp .L_degree
    
    
.ret:
    imul ecx, [ebp + 8]
    mov eax, [ebp + 12]
    add eax, ecx


    mov esp, ebp
    pop ebp
    
    ret
