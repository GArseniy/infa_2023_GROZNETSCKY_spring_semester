extern malloc, free, scanf, printf


SIZE_OF_NODE equ 3*4
HASH_MOD equ 120077
HASH_POW equ 257
HASH_COUNT equ 7


section .rodata
    fs_scanf_op db `%c`, 0
    fs_scanf_two db `%d %d\n`, 0
    fs_scanf_one db `%d\n`, 0
    fs_printf_dd db `%d %d\n`, 0
    

section .bss
    key resd 1
    data resd 1
    mode resb 1 
    
    arr resd HASH_MOD
    func resd 256 
    

section .text


global main
main:
        push ebp
        mov ebp, esp
        
        mov dword[func + 4*'A'], add_op
        mov dword[func + 4*'S'], search_op
        mov dword[func + 4*'D'], delete_op
        mov dword[func + 4*'F'], free_op
        
    .main_process:
        push mode
        push fs_scanf_op
        call scanf
        add esp, 2*4
        
        movzx eax, byte[mode]
        call dword[func + 4*eax]
        
        cmp byte[mode], 'F'
        jne .main_process
        
    .main_ret:
        xor eax, eax
        leave
        ret
    
    


add_op:
        push ebp    
        mov ebp, esp
        
        sub esp, 3*4
        push data
        push key
        push fs_scanf_two
        call scanf
        add esp, 6*4
        
        sub esp, 1*4
        push dword[key]
        call hash
        add esp, 2*4
            
        lea ecx, [arr + 4*eax]
        cmp dword[ecx], 0
        je .add_op_malloc
            
    .add_op_go_next:
        mov ecx, [ecx]
    
        mov edx, dword[key]
        cmp [ecx + 4], edx
        je .add_op_update
    
        cmp dword[ecx + 0], 0
        jne .add_op_go_next
        
    .add_op_malloc:
        push ecx
        push SIZE_OF_NODE
        call malloc
        add esp, 1*4
        pop ecx
        
        mov [ecx], eax
        
        mov dword[eax + 0], 0
        mov edx, dword[key]
        mov dword[eax + 4], edx
        mov edx, dword[data]
        mov dword[eax + 8], edx
        
        jmp .add_op_ret
        
    .add_op_update:
        mov edx, dword[data]
        mov dword[ecx + 8], edx
        
    .add_op_ret:
        leave
        ret
    
    

    
free_op:
        push ebp
        mov ebp, esp
        
        mov ecx, -1
    .free_op_while:
        inc ecx
        cmp ecx, HASH_MOD
        je .free_op_ret
        
        mov eax, [arr + 4*ecx]
        test eax, eax
        je .free_op_while
        
        push ecx
        push eax
        call free_node
        add esp, 1*4
        pop ecx
        
        jmp .free_op_while
        
    .free_op_ret:
        leave
        ret
    
    
    

delete_op:
        push ebp
        mov ebp, esp
        
        push key
        push fs_scanf_one
        call scanf
        add esp, 2*4
            
        sub esp, 1*4
        push dword[key]
        call hash
        add esp, 2*4
            
        lea ecx, [arr + 4*eax]
        cmp dword[ecx], 0
        je .delete_op_ret
            
    .delete_op_go_next:
        mov eax, ecx
        mov ecx, [ecx]
            
        mov edx, [key]
        cmp [ecx + 4], edx
        je .delete_op_free
            
        cmp dword[ecx + 0], 0
        jne .delete_op_go_next
        jmp .delete_op_ret
        
    .delete_op_free:
        mov edx, [ecx + 0]
        mov [eax + 0], edx
        
        sub esp, 1*4
        push ecx
        call free
        sub esp, 2*4
        
    .delete_op_ret:
        leave
        ret
    
    
    
    
search_op:
        push ebp
        mov ebp, esp
        
        push key
        push fs_scanf_one
        call scanf
        add esp, 2*4
        
        sub esp, 1*4
        push dword[key]
        call hash
        add esp, 2*4
            
        lea ecx, [arr + 4*eax]
        cmp dword[ecx], 0
        je .search_op_ret
            
    .search_op_go_next:
        mov ecx, [ecx]
    
        mov edx, dword[key]
        cmp [ecx + 4], edx
        je .search_op_print
    
        cmp dword[ecx + 0], 0
        jne .search_op_go_next
        jmp .search_op_ret
        
    .search_op_print:
        sub esp, 3*4
        push dword[ecx + 8]
        push dword[ecx + 4]
        push fs_printf_dd
        call printf
        add esp, 6*4
        
    .search_op_ret:
        leave
        ret
    
    


free_node:
        push ebp
        mov ebp, esp
        
        mov eax, [ebp + 8]
        mov eax, [eax + 0]
        test eax, eax
        je .free_node_ret
        
        sub esp, 1*4
        push eax
        call free_node
        add esp, 2*4
        
    .free_node_ret:
        sub esp, 1*4
        push dword[ebp + 8]
        call free
        add esp, 2*4
        
        leave
        ret




hash:
        push ebp
        mov ebp, esp
        push ebx
        
        xor eax, eax
        xor ebx, ebx
    .hash_while:
        cmp ebx, HASH_COUNT
        je .hash_ret
        
        add eax, [ebp + 8]
        mov edx, HASH_POW
        mul edx
        
        mov ecx, HASH_MOD
        div ecx
        mov eax, edx
        
        inc ebx
        jmp .hash_while
        
    .hash_ret:
        pop ebx
        xor eax, eax
        leave
        ret
