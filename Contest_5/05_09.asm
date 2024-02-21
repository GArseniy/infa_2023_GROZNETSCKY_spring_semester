extern malloc, free, scanf, printf


SIZE_OF_LONG equ 8


section .rodata
    fs_scanf_d db `%d`, 0
    fs_printf_d db `%d `, 0
    fs_printf_n db `\n`, 0


section .bss
    n resd 1
    
    dim resd 1
    matrix resd 1
    tr resq 1
    
    max_dim resd 1
    max_matrix resd 1
    max_trace resq 1


section .text


read:
    ;   void read(int ***m, int *dim);
        push ebp
        mov ebp, esp
        
        
    ;   scanf("%d", dim);
        push dword[ebp + 12]
        push fs_scanf_d
        call scanf
        add esp, 2*4
        
    
    ;   *m = malloc(*dim * sizeof(int *));
        mov eax, [ebp + 12]
        mov eax, [eax]
        lea eax, [4*eax]
        
        sub esp, 1*4
        push eax
        call malloc
        add esp, 2*4
        
        mov ecx, [ebp + 8]
        mov [ecx], eax
        
        
    ;   for (int i = 0; i < *dim; ++i) {
    ;       (*m)[i] = malloc(*dim * sizeof(int));
    ;   }
        mov ecx, 0
    .read_while:
        mov eax, [ebp + 12]
        cmp ecx, [eax]
        jnl .read_after_while
        
        mov eax, [ebp + 12]
        mov eax, [eax]
        lea eax, [4*eax]
        
        push ecx
        push eax
        call malloc
        mov ecx, [esp + 4]
        add esp, 2*4
        
        
        mov edx, [ebp + 8]
        mov edx, [edx]
        lea edx, [edx + 4*ecx]
        mov [edx], eax
        
        
        inc ecx
        jmp .read_while
        
        
    .read_after_while:
    ;   for (int i = 0; i < *dim; ++i) {
    ;       for (int j = 0; j < *dim; ++j) {
    ;           scanf("%d", &(*m)[i][j]);
    ;       }
    ;   }
    
        mov ecx, 0
    .read_for_i:
        mov eax, [ebp + 12]
        cmp ecx, [eax]
        jnl .read_ret
        push ecx
        
        
        mov ecx, 0
    .read_for_j:
        mov eax, [ebp + 12]
        cmp ecx, [eax]
        jnl .read_after_for_j
        pop eax
        
    
        mov edx, [ebp + 8]
        mov edx, [edx]
        lea edx, [edx + 4*eax]
        mov edx, [edx]
        lea edx, [edx + 4*ecx]
        
        push eax
        push ecx
        
        sub esp, 2*4
        push edx
        push fs_scanf_d
        call scanf
        add esp, 4*4
        
        pop ecx
        inc ecx
        jmp .read_for_j
        
    
    .read_after_for_j:
        pop ecx
        inc ecx
        jmp .read_for_i
        
        
    ;   return;
    .read_ret:
        leave
        ret


write:
    ;   void write(int **m, int dim);
        push ebp
        mov ebp, esp
        push esi
        push edi
        
    ;   for (int i = 0; i < dim; ++i) {
    ;       for (int j = 0; j < dim; ++j) {
    ;           printf("%d ", m[i][j]);
    ;       }
    ;
    ;       printf("\n");
    ;   }
        mov esi, 0
    .write_for_i:
        cmp esi, [ebp + 12]
        jnl .write_ret
        
        
        mov edi, 0
    .write_for_j:
        cmp edi, [ebp + 12]
        jnl .write_after_for_j
        
        
    ;   printf("%d ", m[i][j]);
        mov eax, [ebp + 8]
        lea eax, [eax + 4*esi]
        mov eax, [eax]
        lea eax, [eax + 4*edi]
        
        sub esp, 2*4
        push dword[eax]
        push fs_printf_d
        call printf
        add esp, 4*4
        
        
        inc edi
        jmp .write_for_j
        
        
    .write_after_for_j:
    ;   printf("\n");
        sub esp, 3*4
        push fs_printf_n
        call printf
        add esp, 4*4
        
        
        inc esi
        jmp .write_for_i
        
        
    ;   return;
    .write_ret:
        leave
        ret


delete:
    ;   void delete(int **m, int dim);
        push ebp
        mov ebp, esp
        push ebx
        
    ;   for (int j = 0; j < dim; ++j) {
    ;       free(m[j]);
    ;   }
        mov ebx, 0
    .delete_while:
        cmp ebx, [ebp + 12]
        jnl .delete_ret
        
        
        mov eax, [ebp + 8]
        lea eax, [eax + 4*ebx]
        
        push dword[eax]
        call free
        add esp, 1*4
        
        inc ebx
        jmp .delete_while
        
        
    .delete_ret:
    ;   free(m);
        push dword[ebp + 8]
        call free
        add esp, 1*4
        
        
        pop ebx
        leave
        ret
    
    
trace:
    ;   long trace(int **m, int dim);
        push ebp
        mov ebp, esp
        push esi
        push edi
        
        
    ;   long trace (edi:esi) = 0;
        mov edi, 0
        mov esi, 0
            
        
    ;   for (int i = 0; i < dim; ++i) {
    ;       trace += m[i][i];
    ;   }
        mov ecx, 0
    .trace_while:
        cmp ecx, [ebp + 12]
        jnl .trace_ret
        
        
        mov eax, [ebp + 8]
        lea eax, [eax + 4*ecx]
        mov eax, [eax]
        lea eax, [eax + 4*ecx]
        mov eax, [eax]
        cdq
        
        
        add esi, eax
        adc edi, edx

        
    .trace_while_inc:
        inc ecx
        jmp .trace_while
        
        
    ;   return trace;
    .trace_ret:
        mov edx, edi
        mov eax, esi
        pop edi
        pop esi
        leave
        ret
    

global main
main:
    mov ebp, esp; for correct debugging
;   int main(void);
    push ebp
    mov ebp, esp
    
    
;   scanf("%d", &n);
    push n
    push fs_scanf_d
    call scanf
    add esp, 2*4
    
    
;   read(&max_matrix, &max_dim);
    push max_dim
    push max_matrix
    call read
    add esp, 2*4


;   long max_trace = trace(max_matrix, max_dim);
    push dword[max_dim]
    push dword[max_matrix]
    call trace
    add esp, 2*4
    
    mov dword[max_trace + 0], eax
    mov dword[max_trace + 4], edx
    
    
;   for (int i = 1; i < n; ++i);
    mov ebx, 1
.main_while:
    cmp ebx, [n]
    jnl .main_after_while

    
;   read(&matrix, &dim);
    push dim
    push matrix
    call read
    add esp, 2*4
    
    
;   long tr = trace(matrix, dim);
    push dword[dim]
    push dword[matrix]
    call trace
    add esp, 2*4
    
    mov dword[tr + 0], eax
    mov dword[tr + 4], edx
    
    
;   if (tr > max_trace);
    push max_trace
    push tr
    call comparator
    add esp, 2*4
    cmp eax, 1
    jne .main_if_else

        
;   max_trace = tr;
    mov eax, [tr + 0]
    mov [max_trace + 0], eax
    mov eax, [tr + 4]
    mov [max_trace + 4], eax
    
    
;   int tmp_d = dim;
;   dim = max_dim;
;   max_dim = tmp_d;
    mov eax, [dim]
    mov ecx, [max_dim]
    mov [dim], ecx
    mov [max_dim], eax
    
    
;   int **tmp_m = matrix;
;   matrix = max_matrix;
;   max_matrix = tmp_m;
    mov eax, [matrix]
    mov ecx, [max_matrix]
    mov [matrix], ecx
    mov [max_matrix], eax

    
.main_if_else:
;   delete(matrix, dim);
    push dword[dim]
    push dword[matrix]
    call delete
    add esp, 2*4
    
    
    inc ebx
    jmp .main_while
    

.main_after_while:
;   write(max_matrix, max_dim);
    push dword[max_dim]
    push dword[max_matrix]
    call write
    add esp, 2*4
    
    
;   delete(max_matrix, max_dim);
    push dword[max_dim]
    push dword[max_matrix]
    call delete
    add esp, 2*4
    
    
;   return 0;
    xor eax, eax 
    leave
    ret
    

comparator:
        push ebp
        mov ebp, esp
        push esi
        push edi
        push ebx
        
        
        mov ebx, [ebp + 8]
        mov ecx, [ebp + 12]
        
        
        mov esi, [ebx + 0]
        mov edi, [ebx + 4]
        
        mov eax, [ecx + 0]
        mov edx, [ecx + 4] 
        
        
        cmp edi, 0
        jl .comparator_first_neg
        
        
    .comparator_first_pos:
        cmp edx, 0
        jl .comparator_greater
        jmp .comparator_both_pos
        
    .comparator_first_neg:
        cmp edx, 0
        jl .comparator_both_neg
        jmp .comparator_less
        
        
    .comparator_both_pos:
        cmp edi, edx
        ja .comparator_greater
        jb .comparator_less
        
        
        cmp esi, eax
        ja .comparator_greater
        jb .comparator_less
    
        
        mov eax, 0
        jmp .comparator_ret
    
    
    
    .comparator_both_neg:
        not eax
        not edx
        add eax, 1
        adc edx, 0
        
        not esi
        not edi
        add esi, 1
        adc edi, 0
        
        
        cmp edi, edx
        jb .comparator_greater
        ja .comparator_less
        
        
        cmp esi, eax
        jb .comparator_greater
        ja .comparator_less
    
        
        mov eax, 0
        jmp .comparator_ret
    
            
    .comparator_greater:
        mov eax, 1
        jmp .comparator_ret
    
    
    .comparator_less:
        mov eax, -1
        jmp .comparator_ret
        
        
    .comparator_ret:
        pop ebx
        pop edi
        pop esi
        leave
        ret
