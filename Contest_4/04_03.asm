extern io_get_dec, io_print_dec, io_print_char


section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    call print
    
    xor eax, eax
    ret


print:
    push ebp
    mov ebp, esp
    
    call io_get_dec
    
    test eax, eax
    je .ret
    
    push eax
    call print
    pop eax
    
    call io_print_dec
    
    mov eax, ' '
    call io_print_char
 
.ret:   
    leave
    ret
