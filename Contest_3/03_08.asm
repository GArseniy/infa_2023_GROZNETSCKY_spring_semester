extern io_print_dec, io_print_char, io_newline, io_get_dec


section .bss
    N resd 1
    M resd 1
    K resd 1
    A resw 100 * 100
    B resw 100 * 100
    C resd 100 * 100
    

section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    
    call io_get_dec
    mov [N], eax
    
    call io_get_dec
    mov [M], eax
    
    call io_get_dec
    mov [K], eax
    
    
    mov esi, [N]
    imul esi, [M]
    mov ebx, 0
.L_A_get:
    call io_get_dec
    mov [A + 2 * ebx], ax

    inc ebx
    cmp ebx, esi
    jne .L_A_get


    mov esi, [M]
    imul esi, [K]
    mov ebx, 0
.L_B_get:
    call io_get_dec
    mov [B + 2*ebx], ax
    
    inc ebx
    cmp ebx, esi
    jne .L_B_get
    
    
    mov ecx, [N]
.L_i:
    test ecx, ecx
    je .L_print_C
    dec ecx
    
    mov edx, [K]
.L_j:
    test edx, edx
    je .L_i
    dec edx
    
    mov ebx, [M]
    
    mov edi, ecx
    imul edi, [K]
    add edi, edx
    
    mov eax, 0
    mov [C + 4*edi], eax
    
.L_m:
    test ebx, ebx
    je .L_j
    dec ebx
    
    mov esi, ecx
    imul esi, [M]
    add esi, ebx
    
    
    mov ax, [A + 2*esi]
    movsx eax, ax
    
    mov esi, ebx
    imul esi, [K]
    add esi, edx
    
    mov ch, bl
    movsx ebx, word[B + 2*esi]
    imul eax, ebx
    add [C + 4*edi], eax
    
    mov ebx, 0
    mov bl, ch
    mov ch, 0
    
    jmp .L_m
    

    
.L_print_C:
    mov esi, [N]
    mov edi, [K]
    
    mov ecx, -1
.L_C_print_row:
    inc ecx
    cmp esi, ecx
    je .end
    
    mov edx, -1
.L_C_print_elem:
    inc edx
    cmp edi, edx
    je .L_C_after_print_elem
    
    mov ebx, ecx
    imul ebx, edi
    add ebx, edx
    
    mov eax, [C + 4*ebx]
    
    push edx
    push ecx
    call io_print_dec
    pop ecx
    pop edx
    
    mov eax, ' '
    push edx
    push ecx
    call io_print_char
    pop ecx
    pop edx
    
    
    jmp .L_C_print_elem

.L_C_after_print_elem:
    push edx
    push ecx
    call io_newline
    pop ecx
    pop edx
    
    
    jmp .L_C_print_row
    
.end:
    xor eax, eax
    ret 
