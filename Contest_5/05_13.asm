extern printf, scanf, malloc, free


section .rodata
    fs_scanf db `%d`, 0
    fs_printf db `%d\n`, 0


section .bss
    len resd 1
    

section .text
global main
main:
    push ebp
    mov ebp, esp
    
    
    push len
    push fs_scanf
    call scanf
    add esp, 2*4
    
    
    sub esp, 1*4
    mov eax, [len]
    lea eax, [4*eax]
    push eax
    call malloc
    add esp, 2*4
    mov esi, eax
    
    
    mov ebx, -1
while:
    inc ebx
    cmp ebx, [len]
    je .after_while
    
    
    lea eax, [4*ebx]
    add eax, esi
    push eax
    push fs_scanf
    call scanf
    add esp, 2*4
    
    
    jmp while
    
    
.after_while:
    sub esp, 1*4
    push fs_printf
    push 1
    push printf
    push dword[len]
    push esi
    call apply
    add esp, 6*4
    
    
    sub esp, 1*4
    push esi
    call free
    add esp, 2*4
    
    xor eax, eax
    leave
    ret
    
    
apply:
    push ebp
    mov ebp, esp
    push ebx
    
    
    mov eax, [ebp + 20]; argc
    cdq
    mov ecx, 4
    div ecx
    test edx, edx
    je .pros
    
    
    sub ecx, edx
    sub esp, ecx

    
.pros:
    
    mov ebx, -1
    
.apply_while:
    inc ebx
    cmp ebx, [ebp + 12]; len
    je .apply_free
    
    
    push ebx
    mov ebx, -1
.apply_fill_stack:
    inc ebx
    cmp ebx, [ebp + 20]; argc
    je .apply_call
    
    
    lea eax, [ebp + 24]; argv
    lea eax, [eax + 4*ebx]
    push dword[eax]
    
    jmp .apply_fill_stack


.apply_call:
    mov eax, esp; argv
    lea eax, [eax + 4*ebx]
    mov ebx, [eax]
    
    mov ecx, [ebp + 8]; arr
    lea ecx, [ecx + 4*ebx]
    mov ecx, [ecx]
    mov [eax], ecx
    
    call dword[ebp + 16]
    mov eax, [ebp + 20]
    inc eax
    lea esp, [esp + 4*eax]
    
    jmp .apply_while
    
    
.apply_free:
    mov eax, [ebp + 20]; n
    cdq
    mov ecx, 4
    div ecx
    test edx, edx
    je .apply_ret
    
    
    sub ecx, edx
    add esp, ecx
    
    
.apply_ret:
    pop ebx
    leave
    ret
