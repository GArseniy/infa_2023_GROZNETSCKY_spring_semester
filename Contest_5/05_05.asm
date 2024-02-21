extern scanf, printf, malloc, realloc, free


BUF_SIZE equ 10
SIZE_OF_INT equ 4


section .rodata
    format_str db `%d`, 0
    
    
section .bss
    arr resd 1
    n resd 1
    
    
section .text
global main
main:
    push ebp
    mov ebp, esp
    
    
    sub esp, 1*4
    push BUF_SIZE * SIZE_OF_INT
    call malloc
    add esp, 2*4
    mov dword[arr], eax
    mov dword[n], BUF_SIZE
    
    
    mov ebx, 0
.main_while:
    cmp ebx, [n]
    je .main_realloc
    
    
    mov esi, [arr]
    lea esi, [esi + 4*ebx]
    push esi
    push format_str
    call scanf
    add esp, 2*4
    
    
    cmp dword[esi], 0
    je .main_after_while
    
    
    inc ebx
    jmp .main_while
    
    
.main_realloc:
    add dword[n], BUF_SIZE
    imul ecx, dword[n], SIZE_OF_INT
    push ecx
    push dword[arr]
    call realloc
    add esp, 2*4
    mov dword[arr], eax
    
    jmp .main_while
    
    
.main_after_while:
    mov ecx, 0
    test ebx, ebx
    je .main_print
    
    
    mov esi, dword[esi - 4]
.main_count:
    dec ebx
    cmp ebx, -1
    je .main_print
    
    
    mov eax, dword[arr]
    cmp [eax + 4*ebx], esi
    jnl .main_count
    
    inc ecx
    jmp .main_count
    
    
.main_print:
    push ecx
    push format_str
    call printf
    add esp, 2*4
        


.main_ret:
    xor eax, eax
    leave
    ret
