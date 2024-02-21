extern io_print_hex, io_newline, io_get_string

%define BUF_SIZE 4095

section .bss
        buf resb BUF_SIZE + 1

        section .text

hash:
        push    esi
        xor     edx, edx
        push    ebx
        sub     esp, 1024
        mov     ecx, dword [esp+1036]
        mov     esi, esp
    .L5:
        mov     eax, edx
        xor     ebx, ebx
    .L4:
        test    al, 1
        je      .L2
        shr     eax, 1
        xor     eax, -306674912
        jmp     .L3
    .L2:
        shr     eax, 1
    .L3:
        inc     ebx
        cmp     ebx, 8
        jne     .L4
        mov     dword [esi+edx*4], eax
        inc     edx
        cmp     edx, 256
        jne     .L5
        or      eax, -1
        jmp     .L6
    .L7:
        xor     edx, eax
        inc     ecx
        movzx   edx, dl
        shr     eax, 8
        xor     eax, dword [esp+edx*4]
    .L6:
        mov     dl, byte [ecx]
        test    dl, dl
        jne     .L7
        add     esp, 1024
        not     eax
        pop     ebx
        pop     esi
        ret

global main
main:
    push    ebp
    mov     ebp, esp
    sub     esp, 4

    mov     byte [buf], 0
    mov     eax, buf
    mov     edx, BUF_SIZE
    call    io_get_string
    mov     byte [buf + BUF_SIZE], 0

    mov     dword [esp], buf
    call    hash

    call    io_print_hex
    call    io_newline

    xor     eax, eax
    mov     esp, ebp
    pop     ebp
    ret