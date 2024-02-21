extern malloc, free, fopen, fclose, fscanf, fprintf

SIZE_OF_NODE equ 4*4
NULL equ 0
MAX_N equ 100000

section .rodata 
    input_s db `input.txt`, 0
    output_s db `output.txt`, 0
    
    mode_r db `r`, 0
    mode_w db `w`, 0
    
    fscanf_fs db `%d`, 0
    fprintf_fs db `%d `, 0

section .bss
    input resd 1
    output resd 1
    
    list resd 1
    head resd 1
    
    n resd 1
    m resd 1
    
    buf resd 1
    adr resd MAX_N + 1

section .text
global main
main:
        push ebp
        mov ebp, esp
        
        push mode_r
        push input_s
        call fopen
        add esp, 2*4
        mov [input], eax

        sub esp, 3*4
        push n
        push fscanf_fs
        push dword[input]
        call fscanf
        add esp, 6*4

        sub esp, 1*4
        push dword[n]
        call node_init
        add esp, 2*4

        sub esp, 3*4
        push dword[n]
        push eax
        push dword[input]
        call node_process
        add esp, 6*4
        mov [list], eax

        sub esp, 1*4
        push dword[input]
        call fclose
        add esp, 2*4

        push mode_w
        push output_s
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

node_push:
        push ebp
        mov ebp, esp

        sub esp, 1*4
        push SIZE_OF_NODE
        call malloc
        add esp, 2*4

        mov ecx, [ebp + 12]
        mov [eax + 0], ecx

        mov ecx, [ebp + 8]
        mov [eax + 4], ecx

        mov dword[eax + 8], NULL
        
        test ecx, ecx
        je .node_push_ret
        
        mov ecx, [ecx + 8]
        mov [eax + 8], ecx
                
        mov edx, [ebp + 8]
        mov [edx + 8], eax
        
        test ecx, ecx
        je .node_push_ret
        mov [ecx + 8], eax

    .node_push_ret:
        leave 
        ret

node_pop:
        push ebp
        mov ebp, esp

        mov eax, [ebp + 8]
        test eax, eax
        je .node_pop_ret

        mov ecx, [eax + 4]
        test ecx, ecx
        je .node_pop_cond_1
        
        mov edx, [eax + 8]
        mov [ecx + 8], edx

    .node_pop_cond_1:
        mov ecx, [eax + 8]
        test ecx, ecx
        je .node_pop_cond_2
        
        mov edx, [eax + 4]
        mov [ecx + 4], edx

    .node_pop_cond_2:
        mov eax, [ebp + 8]
        mov eax, [eax + 8]
        push eax

        push dword[ebp + 8]
        call free
        add esp, 1*4

        pop eax
    .node_pop_ret:
        leave 
        ret

node_init:
        push ebp
        mov ebp, esp
        push ebx
        
        mov eax, NULL
        mov ebx, eax
        mov ecx, 1
        
    .node_init_while:
        cmp ecx, [ebp + 8]
        jg .node_init_ret

        sub esp, 3*4
        push ecx
        push eax
        call node_push
        mov ecx, [esp + 4]
        add esp, 5*4
        
        inc ecx
        test ebx, ebx
        jne .node_init_while
        
        mov ebx, eax
        jmp .node_init_while
        
    .node_init_ret:
        mov eax, ebx
        pop ebx
        leave
        ret

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
        push fprintf_fs
        push dword[ebp + 8]
        call fprintf
        add esp, 5*4

        mov ebx, [ebx + 8]
        jmp .node_print_while

    .node_print_ret:
        pop ebx
        leave
        ret

node_delete:
        push ebp
        mov ebp, esp
        
        mov eax, [ebp + 8]
    .node_delete_while:
        test eax, eax
        je .node_delete_ret

        sub esp, 1*4
        push eax
        call node_pop
        add esp, 2*4

        jmp .node_delete_while

    .node_delete_ret:
        leave
        ret

node_process:
        push ebp
        mov ebp, esp
        push esi
        push edi
        push ebx

        mov eax, [ebp + 12]
        mov ecx, 1
        
    .node_process_while:
        cmp ecx, [ebp + 16]
        jg .node_process_end_while

        mov [adr + 4*ecx], eax
        mov eax, [eax + 8]
        
        inc ecx
        jmp .node_process_while

    .node_process_end_while:
        push m
        push fscanf_fs
        push dword[ebp + 8]
        call fscanf
        add esp, 3*4

        mov eax, [ebp + 12]
        mov [head], eax

        mov ebx, 0
    .node_process_for:
        cmp ebx, [m]
        jnl .node_process_ret
        
        push buf
        push fscanf_fs
        push dword[ebp + 8]
        call fscanf
        add esp, 3*4
        mov esi, [buf]

        push buf
        push fscanf_fs
        push dword[ebp + 8]
        call fscanf
        add esp, 3*4
        mov edi, [buf]

        mov eax, [adr + 4*esi]
        mov eax, [eax + 4]
        inc ebx
        test eax, eax
        je .node_process_for
        dec ebx

        mov ecx, [adr + 4*edi]
        mov ecx, [ecx + 8]
        mov [eax + 8], ecx

        test ecx, ecx
        je .node_process_tie
        mov [ecx + 4], eax

    .node_process_tie:
        mov eax, [adr + 4*edi]
        mov ecx, [head]
        mov [ecx + 4], eax

        mov ecx, [head]
        mov [eax + 8], ecx

        mov eax, [adr + 4*esi]
        mov [head], eax

        mov ecx, [head]
        mov dword[ecx + 4], NULL

        inc ebx
        jmp .node_process_for

    .node_process_ret:
        mov eax, [head]
        pop ebx
        pop edi
        pop esi
        leave
        ret
