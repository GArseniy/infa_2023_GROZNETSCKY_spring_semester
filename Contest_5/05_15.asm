extern malloc, free, printf, scanf, qsort, strlen, strcpy, strcmp


SIZE_OF_BUF equ 1000000
SIZE_OF_NOTE equ 8

COUNT_OF_NOTE equ 1000000


section .rodata
    format_str_scanf db `%s %hd %hd`, 0
    format_str_printf db `%-*s|%*hd|%*hd\n`, 0


section .bss
    notes resb COUNT_OF_NOTE * SIZE_OF_NOTE
    n resd 1
    
    buffer resb SIZE_OF_BUF + 1
    time resw 1
    count resw 1
    
    max_len_str resd 1
    max_len_time resd 1
    max_len_count resd 1
    
    
section .text
global main
main:
    push ebp
    mov ebp, esp
    
    
    mov ebx, 0
.main_read:
    sub esp, 2*4
    push count
    push time
    push buffer
    push format_str_scanf
    call scanf
    add esp, 6*4
    
    cmp eax, 0
    jng .main_process
    
    sub esp, 1*4
    push buffer
    call strlen
    add esp, 2*4
    
    sub esp, 1*4
    inc eax
    push eax
    call malloc
    add esp, 2*4
    mov edi, eax
    
    push buffer
    push edi
    call strcpy
    add esp, 2*4
    
    lea eax, [notes + SIZE_OF_NOTE*ebx]
    mov [eax + 0], edi
    mov di, word[time]
    mov [eax + 4], di
    mov di, word[count]
    mov [eax + 6], di
    
    inc ebx
    jmp .main_read
    
    
.main_process:
    mov [n], ebx
    
    sub esp, 2*4
    push compare
    push SIZE_OF_NOTE
    push dword[n]
    push notes
    call qsort
    add esp, 6*4
    
    mov ebx, -1
.main_while_len_str:
    inc ebx
    cmp ebx, [n]
    je .main_after_while_len_str
    
    mov eax, [notes + SIZE_OF_NOTE*ebx]
    sub esp, 1*4
    push eax
    call strlen
    add esp, 2*4
    
    cmp eax, [max_len_str]
    jng .main_while_len_str
    
    mov [max_len_str], eax
    jmp .main_while_len_str
    
    
.main_after_while_len_str:
    
    xor eax, eax
    mov ebx, -1
.main_while_max_time:
    inc ebx
    cmp ebx, [n]
    je .main_after_while_max_time
    
    mov cx, [notes + SIZE_OF_NOTE*ebx + 4]
    cmp cx, ax
    jng .main_while_max_time
    
    mov ax, cx
    jmp .main_while_max_time


.main_after_while_max_time:
    movzx eax, ax
    mov ebx, 10
    
.main_while_not_zero_time:
    test eax, eax
    je .main_count_time
    
    xor edx, edx
    div ebx
    
    inc dword[max_len_time]
    jmp .main_while_not_zero_time
    
    
.main_count_time:
    cmp dword[max_len_time], 0
    jne .main_after_big_time
    
    mov dword[max_len_time], 1
    
    
.main_after_big_time:
    
    xor eax, eax
    mov ebx, -1
.main_while_max_count:
    inc ebx
    cmp ebx, [n]
    je .main_after_while_max_count
    
    mov cx, [notes + SIZE_OF_NOTE*ebx + 6]
    cmp cx, ax
    jng .main_while_max_count
    
    mov ax, cx
    jmp .main_while_max_count


.main_after_while_max_count:
    movzx eax, ax
    mov ebx, 10
    
.main_while_not_zero_count:
    test eax, eax
    je .main_count_count
    
    xor edx, edx
    div ebx
    
    inc dword[max_len_count]
    jmp .main_while_not_zero_count
    
    
.main_count_count:
    cmp dword[max_len_count], 0
    jne .main_after_big_count
    
    mov dword[max_len_count], 1
    
.main_after_big_count:
    
    mov ebx, 0
.main_print:
    cmp ebx, [n]
    je .main_ret
    
    sub esp, 2*4
    push dword[max_len_count]
    push dword[max_len_time]
    push dword[max_len_str]
    lea eax, [notes + SIZE_OF_NOTE*ebx]
    push eax
    call print
    add esp, 6*4
    
    inc ebx
    jmp .main_print
    
.main_ret:
    xor eax, eax
    leave
    ret


print:
    push ebp
    mov ebp, esp
    

    mov eax, [ebp + 8]
    sub esp, 3*4
    
    movzx ecx, word[eax + 6]
    push ecx
    push dword[ebp + 20]
    
    movzx ecx, word[eax + 4]
    push ecx
    push dword[ebp + 16]
    
    push dword[eax + 0]
    push dword[ebp + 12]
    
    push format_str_printf
    call printf
    add esp, 10*4
    
    leave
    ret


compare:
    push ebp
    mov ebp, esp
    push esi
    push edi
    
    mov esi, [ebp + 8]
    mov edi, [ebp + 12]

.compare_count:
    mov cx, [esi + 6]
    mov dx, [edi + 6]
    
    cmp cx, dx
    je .compare_time
    
    mov eax, -1
    jg .copmare_ret
    
    mov eax, 1
    jl .copmare_ret
    
    
.compare_time:
    mov cx, [esi + 4]
    mov dx, [edi + 4]
    
    cmp cx, dx
    je .compare_name
    
    mov eax, 1
    jg .copmare_ret
    
    mov eax, -1
    jl .copmare_ret
     
     
.compare_name:
    mov ecx, [esi + 0]
    mov edx, [edi + 0]
    
    
    sub esp, 2*4
    push edx
    push ecx
    call strcmp
    add esp, 4*4
    
    
.copmare_ret:
    pop edi
    pop esi
    leave
    ret
