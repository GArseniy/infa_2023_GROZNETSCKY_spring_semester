extern io_get_udec, io_print_udec


section .bss
    n resd 32


section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_udec
    mov ebx, eax
    
    call io_get_udec
    mov esi, eax
    
    call io_get_udec

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
    
    call print_bin_dec
    
    add esp, 3 * 4
    xor eax, eax
    ret




print_bin_dec:
    push ebp
    mov ebp, esp
    push ebx
    
    push dword[ebp+8 + 8]
    push dword[ebp+8 + 4]
    push dword[ebp+8 + 0]
    
    mov ebx, 0
.is_zero:
    mov edx, [esp + 8]
    test edx, edx
    jne .div_10
    
    mov edx, [esp + 4]
    test edx, edx
    jne .div_10
    
    mov edx, [esp + 0]
    test edx, edx
    jne .div_10
    
    add esp, 12
    
    test ebx, ebx
    jne .print

    mov eax, 0
    call io_print_udec
    
    jmp .ret_print
    
    
.div_10:
    call div_bin
    
    mov [n + 4 * ebx], eax
    
    inc ebx
    jmp .is_zero
    
.print:
    test ebx, ebx
    je .ret_print
    dec ebx
    
    mov eax, [n + 4 * ebx]
    call io_print_udec
    
    jmp .print
  
.ret_print:
    add esp, 3 * 4
    pop ebx
    leave
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
    
    add eax, -10
    rcl dword[ebp + 8], 1
    rcl dword[ebp + 12], 1
    rcl dword[ebp + 16], 1
    
    cmp eax, 0
    jge .div_bin_for
    
    add eax, 10
    jmp .div_bin_for

    
.ret:
    add esp, 3 * 4
    leave
    ret
