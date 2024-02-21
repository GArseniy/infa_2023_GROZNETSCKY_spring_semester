extern io_get_dec, io_print_dec, io_print_char, io_newline


MAX_C equ 500000


section .bss
    a resd MAX_C
    min resd MAX_C
    max resd MAX_C
    
    len_a resd 1
    len_max resd 1
    len_min resd 1
    
    
section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_dec
    mov [len_a], eax
    
    mov esi, [len_a]
    mov ebx, 0
    
.L_read:
    cmp ebx, esi
    je .process_min
    
    call io_get_dec
    mov [a + 4 * ebx], eax
    
    inc ebx
    jmp .L_read

    
.process_min:
    mov esi, [len_a]
    dec esi
    
    mov ecx, 0
    mov edx, 0
    
.L_min:
    inc ecx
    
    cmp ecx, esi
    jge .process_max
    
    mov eax, [a + 4 * ecx]
    
    mov ebx, ecx
    dec ebx
    
    cmp [a + 4 * ebx], eax
    jng .L_min
    
    add ebx, 2
    cmp eax, [a + 4 * ebx]
    jnl .L_min
    
    mov [min + 4 * edx], ecx
    
    inc ecx
    inc edx
    
    jmp .L_min
    

.process_max:
    mov [len_min], edx

    mov esi, [len_a]
    dec esi

    mov ecx, 0
    mov edx, 0
    
.L_max:
    inc ecx
    
    cmp ecx, esi
    jge .go_min
    
    mov eax, [a + 4 * ecx]
    
    mov ebx, ecx
    dec ebx
    
    cmp [a + 4 * ebx], eax
    jnl .L_max
    
    add ebx, 2
    cmp eax, [a + 4 * ebx]
    jng .L_max
    
    mov [max + 4 * edx], ecx
    
    inc ecx
    inc edx
    
    jmp .L_max
    
    
.go_min:
    mov [len_max], edx
    
    mov eax, [len_min]
    call io_print_dec
    call io_newline
    
    mov ebx, 0
    mov esi, [len_min]
    
.L_print_min:
    cmp ebx, esi
    je .go_max
    
    mov eax, [min + 4 * ebx]
    call io_print_dec
    
    mov eax, ' '
    call io_print_char
    
    inc ebx
    jmp .L_print_min
    

.go_max:
    cmp dword[len_min], 0
    je .not_newline
    call io_newline
    
.not_newline:
    mov eax, [len_max]
    call io_print_dec
    call io_newline
    
    mov ebx, 0
    mov esi, [len_max]
    
.L_print_max:
    cmp ebx, esi
    je .end
    
    mov eax, [max + 4 * ebx]
    call io_print_dec
    
    mov eax, ' '
    call io_print_char
    
    inc ebx
    jmp .L_print_max
    

.end:
    xor eax, eax
    ret
