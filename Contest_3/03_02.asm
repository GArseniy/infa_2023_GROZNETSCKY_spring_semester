extern io_get_udec, io_print_dec


BIT_DEPTH equ 32


section .text
global main
main:
    call io_get_udec
    
    mov ecx, BIT_DEPTH
    mov ebx, 0
    
.loop:
    test ecx, ecx
    je .end
    dec ecx
    
    ror eax, 1
    adc ebx, 0
    
    jmp .loop
    
.end:
    
    mov eax, ebx
    call io_print_dec


    xor eax, eax
    ret
