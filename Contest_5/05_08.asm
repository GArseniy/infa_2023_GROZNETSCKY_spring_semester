extern fopen, fclose, fscanf, fprintf, qsort


SIZE_OF_INT equ 4


section .bss
    arr resd 1000
    
    
section .rodata
    input db `input.txt`, 0
    output db `output.txt`, 0
    fscanf_fs db `%d`, 0
    fprintf_fs db `%d `, 0
    r_mode db `r`, 0
    w_mode db `w`, 0

    
section .text
global main
main:
    push ebp
    mov ebp, esp

.open_input:
    push r_mode
    push input
    call fopen
    add esp, 2*4
    mov esi, eax
    
    
    mov eax, 1
    mov ebx, -1
    
.while_read:
    cmp eax, 0
    jng .close_input
    inc ebx
    
    sub esp, 3*4
    lea ecx, [arr + 4*ebx]

    push ecx
    push fscanf_fs
    push esi
    call fscanf
    add esp, 6*4
    
    jmp .while_read
    
.close_input:
    sub esp, 1*4
    push esi
    call fclose
    add esp, 2*4

.sort:
    sub esp, 2*4
    
    push compare
    push SIZE_OF_INT
    push ebx
    push arr
    call qsort
    add esp, 6*4
    
.open_output:
    push w_mode
    push output
    call fopen
    add esp, 2*4
    mov esi, eax
    
    
    mov edi, 0
    
.while_write:
    cmp edi, ebx
    jnl .close_output
    
    sub esp, 3*4

    push dword[arr + 4*edi]
    push fprintf_fs
    push esi
    call fprintf
    add esp, 6*4
    
    inc edi
    jmp .while_write
    
.close_output:
    sub esp, 1*4
    push esi
    call fclose
    add esp, 2*4
    
.end:
    xor eax, eax
    leave
    ret


compare:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]
    mov eax, [eax]
    
    mov edx, [ebp + 12]
    mov edx, [edx]
    
    cmp eax, edx
    
    jg .compare_pos
    je .compare_zero
    jl .compare_neg
    
    
.compare_pos:
    mov eax, 1
    jmp .compare_ret


.compare_zero:
    mov eax, 0
    jmp .compare_ret


.compare_neg:
    mov eax, -1
    jmp .compare_ret

    
.compare_ret:
    leave
    ret
