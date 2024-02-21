extern fopen, fclose, fread, printf


MAX_COUNT equ 100000
SIZE_OF_INT equ 4
SIZE_OF_NODE equ 3*SIZE_OF_INT


section .rodata
    mode_rb db `rb`, 0
    input_file db `input.bin`, 0
    fs_fprintf db `%d `, 0


section .bss
    input resd 1
    
    arr resb MAX_COUNT * SIZE_OF_NODE
    n resd 1
    
    parents resd MAX_COUNT
    
    
section .text
global main
main:
    push ebp
    mov ebp, esp


.main_input:
    push mode_rb
    push input_file
    call fopen
    add esp, 2*4
    mov [input], eax
    
    sub esp, 2*4
    push dword[input]
    push MAX_COUNT
    push SIZE_OF_INT
    push arr
    call fread
    xor edx,edx
    mov ebx, 3
    idiv ebx
    mov [n], eax
    add esp, 6*4
    
    sub esp, 1*4
    push dword[input]
    call fclose
    add esp, 2*4
    
    
    mov ecx, 0
.main_init_parents:
    cmp ecx, [n]
    je .main_after_init_parents
    
    mov dword[parents + 4*ecx], -1
    
    inc ecx
    jmp .main_init_parents
    
    
.main_after_init_parents:
    
    mov ecx, 0
.main_while_parents:
    cmp ecx, [n]
    je .main_after_while_parents
    
    imul ebx, ecx, SIZE_OF_NODE
    
    mov eax, [arr + ebx + 4]
    cmp eax, -1
    je .main_child_1
    
    xor edx, edx
    mov esi, SIZE_OF_NODE
    idiv esi
    mov [parents + 4*eax], ecx
    
    
.main_child_1:
    mov eax, [arr + ebx + 8]
    cmp eax, -1
    je .main_child_2
    
    xor edx, edx
    mov esi, SIZE_OF_NODE
    idiv esi
    mov [parents + 4*eax], ecx
    
    
.main_child_2:
    inc ecx
    jmp .main_while_parents


.main_after_while_parents:
    mov ecx, 0
    
.main_while_not_root:
    cmp dword[parents + 4*ecx], -1
    je .main_root
    
    inc ecx
    jmp .main_while_not_root
    
    
.main_root:
    sub esp, 3*4
    imul ecx, ecx, SIZE_OF_NODE
    push ecx
    push arr
    push fs_fprintf
    call fprintf_root
    add esp, 6*4
    
.main_ret:
    xor eax, eax
    leave
    ret


fprintf_root:
    push ebp
    mov ebp, esp
    
    
    mov eax, [ebp + 16]; offset
    mov ecx, [ebp + 12]; arr
    add ecx, eax; arr + offset
    mov ecx, [ecx]; *(arr + offset)
    
    push ecx
    push dword[ebp + 8]
    call printf
    add esp, 2*4
    
    
    mov eax, [ebp + 16]; offset
    mov ecx, [ebp + 12]; arr
    lea ecx, [ecx + eax + 4]; arr + offset + 4
    mov ecx, [ecx]; *(arr + offset + 4)
    cmp ecx, -1
    je .fprintf_root_print_next
    
    
    sub esp, 3*4
    push ecx
    push dword[ebp + 12]
    push dword[ebp + 8]
    call fprintf_root
    add esp, 6*4
    
    
.fprintf_root_print_next:
    mov eax, [ebp + 16]; offset
    mov ecx, [ebp + 12]; arr
    lea ecx, [ecx + eax + 8]; arr + offset + 8
    mov ecx, [ecx]; *(arr + offset + 8)
    cmp ecx, -1
    je .fprintf_root_ret
    
    
    sub esp, 3*4
    push ecx
    push dword[ebp + 12]
    push dword[ebp + 8]
    call fprintf_root
    add esp, 6*4
    

.fprintf_root_ret:
    leave
    ret
