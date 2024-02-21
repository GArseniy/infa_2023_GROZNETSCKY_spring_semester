extern io_get_dec, io_print_dec


section .text
global main
main:
    call io_get_dec
    
    
    cdq
    xor eax, edx
    sub eax, edx
    
    
    call io_print_dec
      
    xor eax, eax
    ret
