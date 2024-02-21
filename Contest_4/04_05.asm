extern io_get_dec, io_get_udec, io_print_udec, io_print_string, io_newline


section .rodata
    yes db "Yes", 0
    no db "No", 0


section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_udec
    mov ebx, eax
    
    call io_get_dec
    xchg ebx, eax
    
.L_test:
    test ebx, ebx
    je .end
    dec ebx

    push eax
    call reverse
    add eax, [esp]
    add esp, 4
    
    jmp .L_test
    
   
.end:
    push eax
    call reverse
    mov ebx, [esp]
    sub eax, [esp]
    add esp, 4
    
    test eax, eax
    je .yes
    jmp .no
    
    
.yes:
    mov eax, yes
    call io_print_string

    call io_newline
    
    mov eax, ebx
    call io_print_udec
    
    xor eax, eax
    ret
    
    
.no:
    mov eax, no
    call io_print_string
    
    xor eax, eax
    ret
    
    

reverse:
    push ebp
    mov ebp, esp
    push ebx
 
    
    mov eax, [ebp + 8]
    mov ebx, 0
    mov ecx, 10
    
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
