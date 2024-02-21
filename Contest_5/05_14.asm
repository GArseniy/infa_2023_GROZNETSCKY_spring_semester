extern fopen, fclose, fscanf, fprintf, malloc, free

NULL equ 0
SIZE_OF_NODE equ 8

section .rodata
    input_name db `input.txt`, 0 
    output_name db `output.txt`, 0
    
    mode_r db `r`, 0
    mode_w db `w`, 0
    
    fs_fprintf db `%d `, 0
    fs_fscanf db `%d`, 0
    
section .bss
    input resd 1
    output resd 1
    
    left resd 1
    right resd 1
    
    list resd 1
    key resd 1
    
section .text
node_print:
        push ebp
        mov ebp, esp
        push ebx
        mov ebx, [ebp + 12]
        
    .node_print_while:
        test ebx, ebx
        je .node_print_ret
        sub esp, 2*4
        
        push dword[ebx + 0]
        push fs_fprintf
        push dword[ebp + 8]
        call fprintf
        
        add esp, 5*4
        mov ebx, [ebx + 4]
        jmp .node_print_while

    .node_print_ret:
        pop ebx
        leave
        ret

node_read: 
        push ebp
        mov ebp, esp
        push ebx

        mov ebx, NULL
    .node_read_while:
        sub esp, 2*4
        push key
        push fs_fscanf
        push dword[ebp + 8]
        call fscanf
        add esp, 5*4
        
        cmp eax, 0
        jng .node_read_ret

        push SIZE_OF_NODE
        call malloc
        add esp, 1*4

        mov ecx, [key]
        mov [eax + 0], ecx
        mov [eax + 4], ebx
        mov ebx, eax
        
        jmp .node_read_while

    .node_read_ret:
        mov eax, ebx
        pop ebx
        leave
        ret

node_delete:
        push ebp
        mov ebp, esp
        push ebx

        mov eax, [ebp + 8]
    .node_delete_while:
        test eax, eax
        je .node_delete_ret

        mov ebx, [eax + 4]
        push eax
        call free
        add esp, 1*4
        mov eax, ebx

        jmp .node_delete_while

    .node_delete_ret:
        pop ebx
        leave
        ret

node_merge_sort:
        push ebp
        mov ebp, esp

        mov eax, dword[ebp + 8]
        mov eax, [eax]
        test eax, eax
        je .node_merge_sort_ret
        
        mov ecx, [eax + 4]
        test ecx, ecx
        je .node_merge_sort_ret

        sub esp, 3*4
        push right
        push left
        push eax
        call node_split
        add esp, 6*4

        push dword[right]
        push left
        call node_merge_sort
        add esp, 1*4
        pop dword[right]

        push dword[left]
        push right
        call node_merge_sort
        add esp, 1*4
        pop dword[left]

        push dword[right]
        push dword[left]
        call node_merge_sorted
        add esp, 2*4
    
        mov ecx, dword[ebp + 8]
        mov [ecx], eax

    .node_merge_sort_ret:
        leave
        ret

node_merge_sorted:
        push ebp
        mov ebp, esp
        push ebx
        
        mov eax, [ebp + 12]
        mov ecx, [ebp + 8]
        test ecx, ecx
        je .node_merge_sorted_ret
        
        mov eax, [ebp + 8]
        mov ecx, [ebp + 12]
        test ecx, ecx
        je .node_merge_sorted_ret
        mov ebx, NULL

        mov eax, [ebp + 8]
        mov edx, [ebp + 12]
        
        mov eax, [eax + 0]
        mov edx, [edx + 0]
        
        cmp eax, edx
        jg .node_merge_sorted_if_else
        mov ebx, [ebp + 8]

        sub esp, 3*4
        push dword[ebp + 12]
        push dword[ebx + 4]
        call node_merge_sorted
        add esp, 5*4
        
        mov dword[ebx + 4], eax
        mov eax, ebx
        jmp .node_merge_sorted_ret
        
    .node_merge_sorted_if_else:
        mov ebx, [ebp + 12]

        sub esp, 3*4
        push dword[ebx + 4]
        push dword[ebp + 8]
        call node_merge_sorted
        add esp, 5*4
        
        mov dword[ebx + 4], eax
        mov eax, ebx
        jmp .node_merge_sorted_ret

    .node_merge_sorted_ret:
        pop ebx
        leave
        ret
    
node_split:
        push ebp
        mov ebp, esp

        mov eax, [ebp + 12]
        mov ecx, [ebp + 8]
        mov [eax], ecx
        
        mov eax, [ebp + 16]
        mov dword[eax], NULL

        mov eax, [ebp + 8]
        test eax, eax
        je .node_split_ret
        
        mov eax, [eax + 4]
        test eax, eax
        je .node_split_ret

        mov eax, [ebp + 8]
        mov edx, [eax + 4]

    .node_split_while:
        test edx, edx
        je .node_split_after_while

        mov edx, [edx + 4]
        test edx, edx
        je .node_split_while

        mov eax, [eax + 4]
        mov edx, [edx + 4]
        jmp .node_split_while

    .node_split_after_while:
        mov edx, [ebp + 12]
        mov ecx, [ebp + 8]
        mov [edx], ecx

        mov edx, [ebp + 16]
        mov ecx, [eax + 4]
        mov [edx], ecx

        mov dword[eax + 4], NULL
    .node_split_ret:
        leave
        ret

global main
main:
        push ebp
        mov ebp, esp

        push mode_r
        push input_name
        call fopen
        add esp, 2*4

        sub esp, 1*4
        push dword[input]
        call node_read
        add esp, 2*4
        mov [list], eax

        sub esp, 1*4
        push dword[input]
        call fclose
        add esp, 2*4

        sub esp, 1*4
        push list
        call node_merge_sort
        add esp, 2*4

        push mode_w
        push output_name
        call fopen
        add esp, 2*4
        mov [output], eax

        push dword[list]
        push dword[output]
        call node_print
        add esp, 2*4

        sub esp, 1*4
        push dword[output]
        call fclose
        add esp, 2*4

        sub esp, 1*4
        push dword[list]
        call node_delete
        add esp, 2*4

        xor eax, eax
        leave
        ret
