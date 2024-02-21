extern io_get_udec, io_print_udec

    
section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_udec
    mov edi, eax
    
    call io_get_udec
    mov esi, eax
    
    mov eax, 0
    mov ecx, esi
    dec ecx
    
.L_shift:
    inc ecx
    cmp ecx, 32
    ja .end
    
    
    mov edx, ecx
    mov ecx, 32
    sub ecx, edx
    
    mov ebx, -1
    shr ebx, cl
    
    mov ecx, edx
    
    and ebx, edi
    
    sub ecx, esi
    shr ebx, cl
    add ecx, esi
    
    cmp ebx, eax
    jna .L_shift
    
    mov eax, ebx
    jmp .L_shift
    
.end:
    call io_print_udec        

    xor eax, eax
    ret
