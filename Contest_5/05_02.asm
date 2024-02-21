extern printf, scanf, strstr


section .rodata
    printf_str_1_2 db `1 2`, 0
    printf_str_2_1 db `2 1`, 0
    printf_str_0 db `0`, 0
    scanf_str db `%s %s`, 0


section .bss
    str_1 resd 1000 + 1
    str_2 resd 1000 + 1


section .text
global main
main:
    push ebp
    mov ebp, esp

    sub esp, 3*4
    push str_2
    push str_1
    push scanf_str
    call scanf
    add esp, 3*4 + 3*4
    
    
    push str_1
    push str_2
    call strstr
    add esp, 2*4
    
    test eax, eax
    jne .str_1_2
    
    
    push str_2
    push str_1
    call strstr
    add esp, 2*4
    
    test eax, eax
    jne .str_2_1


.str_0:    
    sub esp, 1*4
    push printf_str_0
    call printf
    add esp, 2*4
    
    xor eax, eax
    leave
    ret


.str_1_2:
    sub esp, 1*4
    push printf_str_1_2
    call printf
    add esp, 2*4
    
    xor eax, eax
    leave
    ret
    

.str_2_1:
    sub esp, 1*4
    push printf_str_2_1
    call printf
    add esp, 2*4
    
    xor eax, eax
    leave
    ret
