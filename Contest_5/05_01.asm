extern printf, scanf


section .rodata
    printf_str db `0x%08X\n`, 0
    scanf_str db `%u `, 0


section .bss
    x resd 1


section .text
global main
main:
    push ebp
    mov ebp, esp

.L_get_udec:
    push x
    push scanf_str
    call scanf
    add esp, 8
    
    cmp eax, 0
    jng .end
    
    push dword[x]
    push printf_str
    call printf
    add esp, 8
    
    jmp .L_get_udec
    

.end:
    xor eax, eax
    leave
    ret
