extern io_get_udec, io_print_udec, io_print_char


section .bss
    a11 resd 1
    a12 resd 1
    a21 resd 1
    a22 resd 1
    b1 resd 1
    b2 resd 1
    x resd 1
    y resd 1
    

section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    
    call io_get_udec
    mov [a11], eax
    
    call io_get_udec
    mov [a12], eax
    
    call io_get_udec
    mov [a21], eax
    
    call io_get_udec
    mov [a22], eax
    
    call io_get_udec
    mov [b1], eax
    
    call io_get_udec
    mov [b2], eax
    
    
    ; x = 1 ^ b1 ^ b2 ^ ... Zhegalkin's polynom
    
    
    mov eax, 0xffffffff
    mov [x], eax; x = 0xFFFFFFFF
    
    mov eax, [b1]
    xor [x], eax; x ^= b1
    
    mov eax, [b2]
    xor [x], eax; x ^= b2
    
    mov eax, [a11]
    xor [x], eax; x ^= a11
    
    mov eax, [a21]
    xor [x], eax; x ^= a21
    
    mov eax, [b1]
    and eax, [b2]
    xor [x], eax; x ^= b1 & b2
    
    mov eax, [a22]
    and eax, [b2]
    xor [x], eax; x ^= a22 & b2
    
    mov eax, [a21]
    and eax, [b1]
    xor [x], eax; x ^= a21 & b1
    
    mov eax, [a21]
    and eax, [a22]
    xor [x], eax; x ^= a21 & a22
    
    mov eax, [a12]
    and eax, [b1]
    xor [x], eax; x ^= a12 & b1
    
    mov eax, [a11]
    and eax, [b2]
    xor [x], eax; x ^= a11 & b2
    
    mov eax, [a11]
    and eax, [a21]
    xor [x], eax; x ^= a11 & a21
    
    mov eax, [a11]
    and eax, [a12]
    xor [x], eax; x ^= a11 & a12
    
    mov eax, [a22]
    and eax, [b1]
    and eax, [b2]
    xor [x], eax; x ^= a22 & b1 & b2
    
    mov eax, [a22]
    and eax, [a21]
    and eax, [b1]
    xor [x], eax; x ^= a22 & a21 & b1
    
    mov eax, [a12]
    and eax, [b1]
    and eax, [b2]
    xor [x], eax; x ^= a12 & b1 & b2
    
    mov eax, [a12]
    and eax, [a22]
    and eax, [b2]
    xor [x], eax; x ^= a12 & a22 & b2
    
    mov eax, [a12]
    and eax, [a22]
    and eax, [b1]
    xor [x], eax; x ^= a12 & a22 & b1
    
    mov eax, [a12]
    and eax, [a21]
    and eax, [b1]
    xor [x], eax; x ^= a12 & a21 & b1
    
    mov eax, [a12]
    and eax, [a21]
    and eax, [a22]
    xor [x], eax; x ^= a12 & a21 & a22
    
    mov eax, [a11]
    and eax, [a22]
    and eax, [b2]
    xor [x], eax; x ^= a11 & a22 & b2
    
    mov eax, [a11]
    and eax, [a21]
    and eax, [a22]
    xor [x], eax; x ^= a11 & a21 & a22
    
    mov eax, [a11]
    and eax, [a12]
    and eax, [b2]
    xor [x], eax; x ^= a11 & a12 & b2
    
    mov eax, [a11]
    and eax, [a12]
    and eax, [a22]
    xor [x], eax; x ^= a11 & a12 & a22
    
    mov eax, [a11]
    and eax, [a12]
    and eax, [a21]
    xor [x], eax; x ^= a11 & a12 & a21
    
    mov eax, [a12]
    and eax, [a22]
    and eax, [b1]
    and eax, [b2]
    xor [x], eax; x ^= a12 & a22 & b1 & b2
    
    mov eax, [a12]
    and eax, [a21]
    and eax, [a22]
    and eax, [b1]
    xor [x], eax; x ^= a12 & a21 & a22 & b1
    
    mov eax, [a11]
    and eax, [a12]
    and eax, [a22]
    and eax, [b2]
    xor [x], eax; x ^= a11 & a12 & a22 & b2
    
    mov eax, [a11]
    and eax, [a12]
    and eax, [a21]
    and eax, [a22]
    xor [x], eax; x ^= a11 & a12 & a21 & a22
    
    
    mov eax, [x]
    call io_print_udec
    
    mov eax, ' '
    call io_print_char
    
    
    mov eax, [x]
    and [a11], eax
    and [a21], eax
    
    
    ; y = 1 ^ b1 ^ b2 ^ ... Zhegalkin's polynom
    
    
    mov eax, 0xffffffff;
    mov [y], eax; y = 0xFFFFFFFF
    
    mov eax, [b1]
    xor [y], eax; y ^= b1
    
    mov eax, [b2]
    xor [y], eax; y ^= b2
    
    mov eax, [a11]
    xor [y], eax; y ^= a11
    
    mov eax, [a12]
    xor [y], eax; y ^= a12
    
    mov eax, [a21]
    xor [y], eax; y ^= a21
    
    mov eax, [a22]
    xor [y], eax; y ^= a22
    
    mov eax, [b1]
    and eax, [b2]
    xor [y], eax; y ^= b1 & b2
    
    mov eax, [b1]
    and eax, [a22]
    xor [y], eax; y ^= b1 & a22
    
    mov eax, [a21]
    and eax, [b1]
    xor [y], eax; y ^= a21 & b1
    
    mov eax, [a12]
    and eax, [b2]
    xor [y], eax; y ^= a12 & b2
    
    mov eax, [a12]
    and eax, [a22]
    xor [y], eax; y ^= a12 & a22
    
    mov eax, [a12]
    and eax, [a21]
    xor [y], eax; y ^= a12 & a21
    
    mov eax, [a11]
    and eax, [b2]
    xor [y], eax; y ^= a11 & b2
    
    mov eax, [a11]
    and eax, [a22]
    xor [y], eax; y ^= a11 & a22
    
    mov eax, [a11]
    and eax, [a21]
    xor [y], eax; y ^= a11 & a21
    
    
    mov eax, [y]
    call io_print_udec
    
    
    xor eax, eax
    ret
