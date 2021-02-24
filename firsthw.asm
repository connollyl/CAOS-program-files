

;Logan Connolly


%include "asm_io.inc"
segment .data
;
; initialized data is put in the data segment here
;
prompt1 db "Enter first integer: ", 0
prompt2 db "Enter second integer:", 0
outmsg1 db "The sum is: ",0
outmsg2 db "The difference is: ", 0
outmsg3 db "The product is: ", 0
outmsg4 db "The quotient is: ", 0

segment .bss
;
; uninitialized data is put in the bss segment
;
input1 resd 1
input2 resd 1
sum resd 1
difference resd 1
product resd 1
quotient resd 1

 

segment .text
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pusha

        mov eax, prompt1
        call print_string
		
		call read_int
		mov [input1], eax
		
		mov eax, prompt2
		call print_string
		
		call read_int
		mov [input2], eax
		
		mov eax, [input1]
		add eax, [input2]
		mov [sum], eax
		
		mov eax, [input1]
		sub eax, [input2]
		mov [difference], eax

		mov eax, [input1]
		mov ebx, [input2]
		mul dword ebx
		mov [product], eax

		mov eax, [input1]
		mov ebx, [input2]
		div dword ebx
		mov [quotient], eax
		
		dump_regs 1               
        dump_mem 2, outmsg1, 1 
		
		mov eax, outmsg1
		call print_string
		mov eax, [sum]
		call print_int
		call print_nl
		mov eax, outmsg2
		call print_string
		mov eax, [difference]
		call print_int
		call print_nl
		mov eax, outmsg3
		call print_string
		mov eax, [product]
		call print_int
		call print_nl
		mov eax, outmsg4
		call print_string
		mov eax, [quotient]
		call print_int
		call print_nl
		
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


