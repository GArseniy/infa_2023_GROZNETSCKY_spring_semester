extern io_get_dec, io_get_char
extern io_print_dec, io_newline

section .data
    a dd f1, f2, 0, f3, 0, f4

section .text

global main
main:
    push      ebp

    call      io_get_dec
    push      eax

    call      io_get_char
    push      eax

    call      io_get_dec

    mov       ebx, eax
    pop       ecx
    pop       eax

    sub       cl, 42
    movzx     ebp, cl

    lea       ebp, [a + 4 * ebp]
    call      [ebp]

    call      io_print_dec
    call      io_newline

    pop       ebp
    xor       eax, eax
    ret

f1:
    imul      eax, ebx
    ret

f2:
    add       eax, ebx
    ret

f3:
    sub       eax, ebx
    ret

f4:
    cdq
    idiv      ebx
    ret