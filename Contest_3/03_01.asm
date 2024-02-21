extern io_get_dec, io_print_dec, io_print_char


MIN_INT equ 0x80000000
SIZE_OF_INT equ 0x4


section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call io_get_dec
    mov ecx, eax
    
    
    mov esi, MIN_INT; max number
    mov edi, MIN_INT; pre-max number
    mov edx, MIN_INT; pre-pre-max number
    
.loop:
    test ecx, ecx
    je .end
    
    dec ecx
    
    push eax
    push ecx
    push edx
    call io_get_dec
    pop edx
    pop ecx
    add esp, SIZE_OF_INT
    
    cmp esi, eax
    jle .shift_three 
    
    cmp edi, eax
    jle .shift_two
    
    cmp edx, eax
    jle .shift_one
    
    jmp .loop
    
.shift_three:
    mov edx, edi
    mov edi, esi
    mov esi, eax
    
    jmp .loop
    
.shift_two:
    mov edx, edi
    mov edi, eax

    jmp .loop
    
.shift_one:
    mov edx, eax
    
    jmp .loop
    
.end:
    mov eax, esi
    push edx
    call io_print_dec
    pop edx
    
    mov eax, ' '
    push edx
    call io_print_char
    pop edx
    
    mov eax, edi
    push edx
    call io_print_dec
    pop edx
    
    mov eax, ' '
    push edx
    call io_print_char
    pop edx
    
    
    mov eax, edx
    push edx
    call io_print_dec
    pop edx
    
    mov eax, ' '
    push edx
    call io_print_char
    pop edx
    
    
    xor eax, eax
    ret
