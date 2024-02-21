extern io_get_dec, io_print_udec, io_print_char


section .bss
    n resd 30



section .data
    sign dd 1


section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_dec
    mov ebx, eax

    cmp eax, 0
    jg .skip_sign_a
    je .zero_case
    
    mov edi, 1
    imul edi, dword[sign], -1
    mov dword[sign], edi
    
    neg ebx
    
.skip_sign_a:
    
    call io_get_dec
    mov esi, eax
    
    cmp eax, 0
    jg .skip_sign_b
    je .zero_case
    
    mov edi, 1
    imul edi, dword[sign], -1
    mov dword[sign], edi
    
    neg esi
    
.skip_sign_b:
    
    call io_get_dec
    
    cmp eax, 0
    jg .skip_sign_c
    je .zero_case
    
    mov edi, 1
    imul edi, dword[sign], -1
    mov dword[sign], edi
    
    neg eax
    
.skip_sign_c:
    
    mul esi
    mov edi, edx
    
    mul ebx
    mov ecx, eax
    mov esi, edx
    
    mov eax, edi
    mul ebx
     
    add eax, esi
    adc edx, 0
    
    push edx
    push eax
    push ecx
    
    mov ebx, 30
.L_div_10:
    test ebx, ebx
    je .print
    dec ebx
    
    call div_bin
    
    mov [n + 4 * ebx], eax
    jmp .L_div_10
    
.print:
    add esp, 12
    mov ebx, -1
    
.L_skip_zero:
    inc ebx
    cmp ebx, 30
    je .zero_case
    
    mov eax, [n + 4 * ebx]
    test eax, eax
    je .L_skip_zero
    
    cmp dword[sign], -1
    jne .skip_sign_print
    mov eax, '-'
    call io_print_char
    
.skip_sign_print:
    mov eax, [n + 4 * ebx]
    call io_print_udec
    
.L_print:
    inc ebx
    cmp ebx, 30
    je .end
    
    mov eax, [n + 4 * ebx]
    call io_print_udec
    
    jmp .L_print
  
.zero_case:
    mov eax, 0
    call io_print_udec
        
.end:
    xor eax, eax
    ret
    
    
div_bin:
    push ebp
    mov ebp, esp
    
    push dword[ebp + 16]
    push dword[ebp + 12]
    push dword[ebp + 8]
    
    mov ecx, 32*3
    mov eax, 0
    
.div_bin_for:
    test ecx, ecx
    je .ret
    dec ecx

    shl dword[esp], 1
    rcl dword[esp + 4], 1
    rcl dword[esp + 8], 1
    rcl eax, 1
    
    cmp eax, 10
    jb .div_bin_zero
    jmp .div_bin_one

.div_bin_zero:
    clc
    rcl dword[ebp + 8], 1
    rcl dword[ebp + 12], 1
    rcl dword[ebp + 16], 1
    
    jmp .div_bin_for

.div_bin_one:
    stc
    rcl dword[ebp + 8], 1
    rcl dword[ebp + 12], 1
    rcl dword[ebp + 16], 1
    sub eax, 10
    
    jmp .div_bin_for

    
.ret:
    add esp, 3 * 4
    leave
    ret
