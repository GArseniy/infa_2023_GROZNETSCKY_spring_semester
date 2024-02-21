extern io_get_dec, io_print_dec, io_print_char


section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call f
    
    xor eax, eax
    ret


f:
    push ebp
    mov ebp, esp
    
    call io_get_dec
    
    test eax, eax
    je .end_f
    
    call io_print_dec
    
    mov eax, ' '
    call io_print_char
    
    call g
    
    
.end_f:
    leave
    ret



g:
    push ebp
    mov ebp, esp
    
    call io_get_dec
    
    test eax, eax
    je .end_g
    
    push eax
    call f
    pop eax
    
    call io_print_dec
    
    mov eax, ' '
    call io_print_char
    
.end_g:
    leave
    ret
