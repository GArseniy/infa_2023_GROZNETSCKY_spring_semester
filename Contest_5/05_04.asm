extern printf, fscanf, fopen, fclose


section .rodata
    printf_str db `%d`, 0
    fscanf_str db `%u `, 0
    mode db `r`, 0
    filename dd `data.in`, 0
    

section .bss
    x resd 1
    fp resd 1


section .text
global main
main:
    push ebp
    mov ebp, esp
    

    push mode
    push filename
    call fopen
    mov [fp], eax
    
    sub esp, 4
    mov ebx, -1
    
    push x
    push fscanf_str
    push dword[fp]
    
.L_get_udec:
    inc ebx
    call fscanf
    
    cmp eax, 0
    jg .L_get_udec
    
    add esp, 24
    
    push ebx
    push printf_str
    call printf
    add esp, 8

    push dword[fp]
    call fclose
    add esp, 4
    
    xor eax, eax
    leave
    ret
