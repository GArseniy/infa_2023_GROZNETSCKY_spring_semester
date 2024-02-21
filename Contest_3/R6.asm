extern io_get_udec, io_print_udec

section .text
global main
main:
    mov ebx, 0xffffffff
again:
    call io_get_udec
    cmp eax, 0
    jz exit
    cmp eax, ebx
    ja again
    mov ebx, eax
    jmp again
exit:
    mov eax, ebx
    call io_print_udec
    xor eax, eax
    ret