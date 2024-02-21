extern io_get_dec, io_print_dec, io_print_char


section .bss
    x1 resd 1
    y1 resd 1
    x2 resd 1
    y2 resd 1
    x3 resd 1
    y3 resd 1


section .text
global main
main:
    mov ebp, esp; for correct debugging

    call io_get_dec
    mov [x1], eax
    
    call io_get_dec
    mov [y1], eax
    
    call io_get_dec
    mov [x2], eax
    
    call io_get_dec
    mov [y2], eax
    
    call io_get_dec
    mov [x3], eax
    
    call io_get_dec
    mov [y3], eax
    
    
S:
    mov ebx, [y2]
    sub ebx, [y3]
    imul ebx, [x1]
    
    mov ecx, [y3]
    sub ecx, [y1]
    imul ecx, [x2]
    
    mov edx, [y1]
    sub edx, [y2]
    imul edx, [x3]
    
    mov eax, 0
    
    add eax, ebx
    add eax, ecx
    add eax, edx
    
    cdq
    xor eax, edx
    sub eax, edx
    
    mov esi, 2
    cdq
    div esi
    
    
    mov esi, eax
Pick:
    inc esi
    
    mov ebx, 0
    
    push dword[x1]
    push dword[y1]
    
    push dword[x2]
    push dword[y2]
    
    call count
    add esp, 4 * 4
    
    add ebx, eax
    
    
    push dword[x2]
    push dword[y2]
    
    push dword[x3]
    push dword[y3]
    
    call count
    add esp, 4 * 4
    
    add ebx, eax
    
    
    push dword[x1]
    push dword[y1]
    
    push dword[x3]
    push dword[y3]
    
    call count
    add esp, 4 * 4
    
    add ebx, eax
    
    mov eax, ebx
    cdq
    mov ebx, 2
    div ebx
    
    sub esi, eax
    
    mov eax, esi
    call io_print_dec
    
    xor eax, eax
    ret
    

    
count:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    
    mov ebx, [ebp + 8]
    mov ecx, [ebp + 12]
    mov edi, [ebp + 16]
    mov esi, [ebp + 20]
    
    sub ebx, edi
    sub ecx, esi
    
    
    mov eax, ebx
    
    cdq
    xor eax, edx
    sub eax, edx
    
    mov ebx, eax
    
    
    mov eax, ecx
    
    cdq
    xor eax, edx
    sub eax, edx
    
    mov ecx, eax
    
    
    push ebx
    push ecx
    call gcd
    add esp, 2 * 4
    
    
    pop edi
    pop esi
    pop ebx
    leave
    ret    
    
    
gcd:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp + 12]
    
    test ebx, ebx
    jne .recursive
    
    mov eax, [ebp + 8]
    
    
    mov esp, ebp
    pop ebp
    ret
    
.recursive:
    mov eax, [ebp + 8]
    cdq
    div dword[ebp + 12]
    
    
    push edx
    push dword[ebp + 12]
    
    call gcd
    
    add esp, 2*4
    
    mov esp, ebp
    pop ebp
    ret