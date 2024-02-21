extern io_get_udec, io_print_udec


section .text
global main
main:
    call io_get_udec
    mov ebx, eax
    
    call io_get_udec
    xchg ebx, eax
    mov cl, bl
    
    ror eax, cl
    
    call io_print_udec
      
    xor eax, eax
    ret
