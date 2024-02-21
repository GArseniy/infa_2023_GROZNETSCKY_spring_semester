extern io_get_udec, io_print_string, io_newline

SIZE_OF_INT equ 32

section .rodata
    yes db "YES", 0
    no db "NO", 0


section .text
global main
main:
    call io_get_udec
    mov esi, eax
    
    
.L_for:
    test esi, esi
    je .end
    dec esi
    
    call io_get_udec
    
    push eax
    call is_div_3
    pop ebx
    
    test eax, eax
    je .yes
    jmp .no


.yes:
    mov eax, yes
    call io_print_string
    call io_newline
    
    jmp .L_for
    
    
.no:
    mov eax, no
    call io_print_string
    call io_newline
    
    jmp .L_for

    
.end:
    xor eax, eax
    ret
    
    
is_div_3:
    push ebp
    mov ebp, esp
    
    xor eax, eax
    mov ecx, SIZE_OF_INT
    mov edx, [ebp + 8]
    
    
.sum:
    dec ecx
    sal edx, 1
    adc eax, 0
    
    dec ecx
    sal edx, 1
    sbb eax, 0
    
    test ecx, ecx
    jne .sum
    
    
.abs:
    cdq
    xor eax, edx
    sub eax, edx
    
    
.recursive:
    cmp eax, 1
    jna .ret
    
    push eax
    call is_div_3
    add esp, 4


.ret:
    leave
    ret
