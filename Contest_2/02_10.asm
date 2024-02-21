extern io_get_dec, io_print_dec

section .text
global main
main:
    mov ebp, esp; for correct debugging
    call io_get_dec
    dec ax
    
    mov bh, 2
    div bh
    
    mov bh, ah
    
    mov ah, 41+42
    mul ah
    
    mov bl, 41
    
    xchg ax, bx
    mul ah
    
    add bx, ax
    
    call io_get_dec
    add ax, bx
    
    call io_print_dec    
    
    xor eax, eax
    ret