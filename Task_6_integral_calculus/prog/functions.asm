section .data
    x dq 10.0
    res dq 0
    osix dq 0.6
    three dq 3.0
    two dq 2.0
    one dq 1.0
    six dq 6.0
    twelve dq 12.0

section .text

global f_1
global df_1
global f_2
global df_2
global f_3
global df_3

f_1:
    push ebp
    mov ebp, esp
    
    finit
    fld qword[ebp+8]
    fld qword[osix]
    fmul
    fld qword[three]
    fadd
    
    mov esp, ebp
    pop ebp
    
    ret
    
df_1:
    finit
    fld qword[osix]
    
    ret
    

f_2:
    push ebp
    mov ebp, esp
    
    finit
    fld qword[ebp+8]
    fld qword[two]
    fsub
    fld st0
    fld st0
    fmulp
    fmul
    fld qword[one]
    fsub
    
    mov esp, ebp
    pop ebp
    
    ret
    
df_2: 
    push ebp
    mov ebp, esp
    
    finit
    fld qword[ebp+8]
    fld qword[two]
    fsub
    fld st0
    fmul
    fld qword[three]
    fmul
    
    mov esp, ebp
    pop ebp
    
    ret


f_3:
    push ebp
    mov ebp, esp
    
    finit
    fld qword[three]
    fld qword[ebp+8]
    fdiv
    
    
    mov esp, ebp
    pop ebp
    
    ret

df_3:
    push ebp
    mov ebp, esp
    
    finit
    fld qword[ebp+8]
    fld qword[ebp+8]
    fmul
    fld qword[three]
    fdivr
    fchs
    
    mov esp, ebp
    pop ebp
    
    ret
