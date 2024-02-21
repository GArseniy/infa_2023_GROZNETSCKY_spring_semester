extern io_get_dec, io_print_dec


section .bss
    N resd 1
    M resd 1
    K resd 1
    D resd 1
    X resd 1
    Y resd 1


section .text
global main
main:
    call io_get_dec
    mov [N], eax
    
    call io_get_dec
    mov [M], eax
    
    call io_get_dec
    mov [K], eax
    
    call io_get_dec
    mov [D], eax
    
    call io_get_dec
    mov [X], eax
    
    call io_get_dec
    mov [Y], eax
    
    
    mov eax, [N]
    imul eax, [M]
    imul eax, [K]
    
    mov esi, eax
    
    mov ebx, [D]
    mov edx, 0
    idiv ebx
    
    add edx, 0xffffffff
    adc eax, 0
    
    
    mov ebx, [X]
    imul ebx, 60
    
    add ebx, [Y]
    
    mov ecx, 5*60+59
    xchg ecx, eax
    
    sub eax, ebx
    
    cdq
    and edx, 1
    mov edi, edx
    
    mov eax, ecx
    
    imul eax, edi
    
    add eax, 2
    mov ebx, 3
    mov edx, 0
    idiv ebx
    
    
    sub ecx, eax

    
    mov eax, ecx
    
    mov ebx, 0
    add esi, 0xffffffff
    
    adc ebx, 0
    not ebx
    and ebx, 1
    imul ebx, edi
    
    add eax, ebx
    
    call io_print_dec
      
    xor eax, eax
    ret
