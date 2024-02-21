extern malloc, free, fopen, fclose, fscanf, fprintf, strcmp, strcpy, strlen


SIZE_OF_NODE equ 3*4
SIZE_OF_STR equ 100
SIZE_OF_SHORT equ 0x10000

HASH_MOD equ SIZE_OF_SHORT
HASH_POW equ 257


section .rodata
    fs_scanf_d db `%d`, 0
    fs_scanf_s_u db `%s %u`, 0
    fs_scanf_s db `%s`, 0
    fs_printf_u db `%u\n`, 0
    fs_printf_d db `%d\n`, 0
    
    mode_r db `r`, 0
    mode_w db `w`, 0
    
    input_name db `input.txt`, 0
    output_name db `output.txt`, 0
    

section .bss
    input resd 1
    output resd 1

    key resd 1
    string resb SIZE_OF_STR + 1
    
    n resd 1
    m resd 1
    
    arr resb HASH_MOD * SIZE_OF_NODE
    

section .text
hash_str:
    push ebp
    mov ebp, esp
    
    mov eax, 0
    mov ecx, [ebp + 8]
.hash_str_while:
    cmp byte[ecx], 0
    je .hash_str_ret
    
    movzx dx, byte[ecx]
    add ax, dx
    mov dx, HASH_POW
    mul dx
    
    inc ecx
    jmp .hash_str_while
    
    
.hash_str_ret:
    leave
    ret


global main
main:
    push ebp
    mov ebp, esp
    
    
    push mode_r
    push input_name
    call fopen
    add esp, 2*4
    mov [input], eax
    
    
    sub esp, 3*4
    push n
    push fs_scanf_d
    push dword[input]
    call fscanf
    add esp, 6*4
    
    
    mov ebx, -1
.main_while_read:
    inc ebx
    cmp ebx, [n]
    je .main_after_while_read
    
    
    sub esp, 2*4
    push key
    push string
    push fs_scanf_s_u
    push dword[input]
    call fscanf
    add esp, 6*4
    

    sub esp, 1*4
    push string
    call strlen
    add esp, 2*4
    
    
    sub esp, 1*4
    inc eax
    push eax
    call malloc
    add esp, 2*4
    mov edi, eax
    
    
    push string
    push edi
    call strcpy
    add esp, 2*4
        
        
    sub esp, 1*4
    push string
    call hash_str
    add esp, 2*4
    
    
    movzx eax, ax
    imul eax, eax, SIZE_OF_NODE
    lea eax, [arr + eax]
    cmp dword[eax], 0
    jne .main_malloc_node
    
    
    mov edx, [key]
    mov dword[eax + 0], edx
    mov dword[eax + 4], edi
    
    
    jmp .main_while_read
    
    
.main_malloc_node:
    mov edx, [key]
    cmp dword[eax], edx
    je .main_while_read_free
    cmp dword[eax + 8], 0
    jne .main_malloc_go_next_node
    
    
    push eax
    push SIZE_OF_NODE
    call malloc
    add esp, 1*4
    mov esi, eax
    pop eax
    
    
    mov dword[eax + 8], esi
    mov edx, [key]
    mov dword[esi + 0], edx
    mov dword[esi + 4], edi
    mov dword[esi + 8], 0
    
    
    jmp .main_while_read
    
    
.main_while_read_free:
    sub esp, 1*4
    push edi
    call free
    add esp, 2*4
    
    jmp .main_while_read
    
    
.main_malloc_go_next_node:
    mov eax, dword[eax + 8]
    jmp .main_malloc_node
    
    
.main_after_while_read:
    push mode_w
    push output_name
    call fopen
    add esp, 2*4
    mov dword[output], eax
    
    
    sub esp, 3*4
    push m
    push fs_scanf_d
    push dword[input]
    call fscanf
    add esp, 6*4
    
    
    mov ebx, -1
.main_while_processing:
    inc ebx
    cmp ebx, dword[m]
    je .main_after_while_processing
    
    
    sub esp, 3*4
    push string
    push fs_scanf_s
    push dword[input]
    call fscanf
    add esp, 2*4
    
    
    sub esp, 1*4
    push string
    call hash_str
    add esp, 2*4
    
    
    movzx eax, ax
    imul eax, eax, SIZE_OF_NODE
    lea eax, [arr + eax]
    mov esi, eax


.main_while_not_searched:
    cmp dword[esi + 4], 0
    mov edi, -1
    je .main_print_d_key

    push string
    push dword[esi + 4]
    call strcmp
    add esp, 2*4
    mov edi, [esi + 0]
    test eax, eax
    je .main_print_key
    
    cmp  dword[esi + 8], 0
    mov edi, -1
    je .main_print_d_key
    mov esi, [esi + 8]
    
    jmp .main_while_not_searched
    
    
.main_print_key:
    sub esp, 3*4
    push edi
    push fs_printf_u
    push dword[output]
    call fprintf
    add esp, 6*4
    
    jmp .main_while_processing
    
    
.main_print_d_key:
    sub esp, 3*4
    push edi
    push fs_printf_d
    push dword[output]
    call fprintf
    add esp, 6*4
    
    jmp .main_while_processing
    
    
.main_after_while_processing:
    sub esp, 1*4
    push dword[input]
    call fclose
    add esp, 2*4
    
    
    sub esp, 1*4
    push dword[output]
    call fclose
    add esp, 2*4
    
    
    mov ebx, -1
.main_while_free:
    inc ebx
    cmp ebx, HASH_MOD
    je .main_ret
    
    imul edi, ebx, SIZE_OF_NODE
    lea edi, [arr + edi]
    
    cmp dword[edi + 4], 0
    je .main_while_free
    
    sub esp, 1*4
    push dword[edi + 4]
    call free
    add esp, 2*4
    
    cmp dword[edi + 8], 0
    je .main_while_free
    
    sub esp, 1*4
    push dword[edi + 8]
    call free_node
    add esp, 2*4
    
    jmp .main_while_free
    
    
    
.main_ret:
    xor eax, eax
    leave
    ret
    
    


free_node:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]
    
    push eax
    push dword[eax + 4]
    call free
    add esp, 1*4
    pop eax
    
    cmp dword[eax + 8], 0
    je .free_node_ret
    
    sub esp, 1*4
    push dword[eax + 8]
    call free_node
    add esp, 2*4
    
    
.free_node_ret:
    sub esp, 1*4
    push dword[ebp + 8]
    call free
    add esp, 2*4

    leave
    ret
