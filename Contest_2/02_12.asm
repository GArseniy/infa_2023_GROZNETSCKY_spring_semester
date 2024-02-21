extern io_get_dec, io_print_char 


section .rodata
    suit db 'S', 'C', 'D', 'H'
    rank db '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'


section .text
global main
main:
    call io_get_dec
    dec al
    
    
    mov bl, 13
    div bl
    mov bx, ax
    
    
    mov eax, 0
    mov ecx, 0
    
    
    mov cl, bh
    mov al, [rank + ecx]
    call io_print_char
    
    mov ecx, 0
    mov cl, bl
    mov al, [suit + ecx]
    call io_print_char
    
    
    xor eax, eax
    ret