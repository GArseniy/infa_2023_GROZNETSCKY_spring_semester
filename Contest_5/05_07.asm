extern scanf, printf, strcmp, qsort

SIZE_OF_STR equ 10+1
MAX_COUNT equ 500

section .rodata
    fs_printf_s db `%s\n`, 0
    fs_printf_d db `%d`, 0
    fs_scanf_s db `%s`, 0
    fs_scanf_d db `%d`, 0

section .bss
    arr resd MAX_COUNT * SIZE_OF_STR
    n resd 1
    
section .text
global main
main:
    push ebp
    mov ebp, esp

    push n
    push fs_scanf_d
    call scanf
    add esp, 2*4

    mov ebx, -1
.main_while_read:
    inc ebx
    cmp ebx, [n]
    je .main_sort
    
    mov eax, ebx
    imul eax, SIZE_OF_STR
    lea eax, [arr + eax]
    push eax
    push fs_scanf_s
    call scanf
    add esp, 2*4
    
    jmp .main_while_read

.main_sort:
    sub esp, 2*4
    push strcmp
    push SIZE_OF_STR
    push dword[n]
    push arr
    call qsort
    add esp, 6*4

    mov esi, [n]
    mov ebx, 0
.main_while_search:
    inc ebx
    cmp ebx, [n]
    je .main_print

    dec ebx
    mov eax, ebx
    imul eax, SIZE_OF_STR
    lea eax, [arr + eax]
    push eax
    lea eax, [eax + SIZE_OF_STR]
    push eax
    call strcmp
    add esp, 2*4
    inc ebx
    
    test eax, eax
    lahf
    shr ah, 7
    sbb esi, 0

    jmp .main_while_search

.main_print:
    push esi
    push fs_printf_d
    call printf
    add esp, 2*4

.main_ret:
    xor eax, eax
    leave
    ret
