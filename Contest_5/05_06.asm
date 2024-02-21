extern fopen, fclose, fread, fwrite, io_print_dec, io_newline


MAX_COUNT equ 4*1024*1024
SIZE_OF_INT equ 4


section .rodata
    mode_wb db `wb`, 0
    mode_rb db `rb`, 0
    
    output_file db `output.bin`, 0
    input_file db `input.bin`, 0


section .bss
    input resd 1
    output resd 1
    
    arr resd MAX_COUNT
    n resd 1
    
    answer resd 1
    
    
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
    mov [n], eax
    add esp, 6*4
    
    sub esp, 1*4
    push dword[input]
    call fclose
    add esp, 2*4
    
    
    mov ecx, 1
    mov dword[answer], 1
.main_while_min_heap:
    cmp ecx, [n]
    jge .main_output
    
    mov esi, [arr + 4*ecx]
    mov edi, 2
    lea eax, [ecx - 1]
    xor edx, edx
    idiv edi
    mov edi, [arr + 4*eax]
    
    cmp esi, edi
    jl .main_after_while_min_heap

    
    inc ecx
    jmp .main_while_min_heap
    

.main_after_while_min_heap:

    mov ecx, 1
    mov dword[answer], -1
.main_while_max_heap:
    cmp ecx, [n]
    jge .main_output
    
    mov esi, [arr + 4*ecx]
    mov edi, 2
    lea eax, [ecx - 1]
    xor edx, edx
    idiv edi
    mov edi, [arr + 4*eax]
    
    cmp esi, edi
    jg .main_after_while_max_heap

    
    inc ecx
    jmp .main_while_max_heap
    
    
.main_after_while_max_heap:
    mov dword[answer], 0
    

.main_output:
    push mode_wb
    push output_file
    call fopen
    add esp, 2*4
    mov [output], eax
    
    sub esp, 2*4
    push dword[output]
    push 1
    push SIZE_OF_INT
    push answer
    call fwrite
    add esp, 6*4
    
    sub esp, 1*4
    push dword[output]
    call fclose
    add esp, 2*4
    
    
.main_ret:
    xor eax, eax
    leave
    ret
