extern io_get_udec, io_print_udec


section .text
global main
main:
    mov ebp, esp; for correct debugging
    call io_get_udec
    mov ebx, eax
    
    call io_get_udec
    shl ebx, 8
    add ebx, eax
    
    call io_get_udec
    shl ebx, 8
    add ebx, eax
    
    call io_get_udec
    shl ebx, 8
    add ebx, eax
    
    mov eax, ebx
    bswap eax
    
    call io_print_udec
      
    xor eax, eax
    ret
