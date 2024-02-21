extern io_get_dec, io_print_dec, io_newline

section .text

global main
main:
       sub     	esp, 12
       call    	io_get_dec
       mov     	dword [esp], eax
       call    	io_get_dec
       mov     	dword [esp + 4], eax
       call    	io_get_dec
       mov     	dword [esp + 8], eax
       call    	m
       add     	esp, 12
       call     io_print_dec
       call     io_newline
       xor     	eax, eax
       ret

   m:
       mov     	eax, dword [esp + 4]
       mov     	ecx, dword [esp + 8]
       mov     	edx, dword [esp + 12]
   .1:
       cmp     	eax, ecx
       jge     	.2
       xor     	eax, ecx
       xor     	ecx, eax
       xor     	eax, ecx
   .2:
       cmp     	eax, edx
       jg      	.3
       ret
   .3:
       xor     	eax, edx
       xor     	edx, eax
       xor     	eax, edx
       jmp     	.1