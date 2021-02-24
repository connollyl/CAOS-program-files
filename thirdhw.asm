

; Logan Connolly and Patrick Terpstra

%include "asm_io.inc"
segment .data
;
; initialized data is put in the data segment here
;
outmsg1 db "PLEASE SELECT AN OPTION FROM THE MENU:", 0
outmsg2 db "--------------------------------------", 0
promt1 db "1. Enter a new string", 0
promt2 db "2. Count the number of words in your string", 0
promt3 db "3. Remove leading and duplicate blank characters in your received string", 0
promt4 db "4. Reverse the words in your string", 0
promt5 db "5. Test if your string is palindrome", 0
promt6 db "6. Exit", 0
outmsg3 db "Choice #: ", 0
entermsg db "Enter a new string: ", 0
stringmsg db "Your string is: ", 0
numbermsg db "The number of words in: ", 0
ismsg db " is ", 0
charactermsg db "After removing leading and dublicate blank characters: ", 0
reversemsg db "After reversing the words:", 0
string2msg db "The string: ",0
isnotmsg db " is not ", 0
palindromemsg db "palindrome", 0
exitmsg db "Good Bye", 0

segment .bss
;
; uninitialized data is put in the bss segment
;
string1 resb 255
reversestring resb 255
removestring resb 255
palindromestr resb 255
temp resb 1
tempcount resd 1

segment .text
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pusha

Read:
		mov eax, outmsg1
		call print_string
		call print_nl
		mov eax, outmsg2
		call print_string
		call print_nl
		mov eax, promt1
		call print_string
		call print_nl
		mov eax, promt2
		call print_string
		call print_nl
		mov eax, promt3
		call print_string
		call print_nl
		mov eax, promt4
		call print_string
		call print_nl
		mov eax, promt5
		call print_string
		call print_nl
		mov eax, promt6
		call print_string
		call print_nl
		call print_nl
		mov eax, outmsg3
		call print_string
		mov eax, 0
		call read_int
		cmp eax, dword 1
		je enterstring
		cmp eax, dword 2
		je countstring
		cmp eax, dword 3
		je characterstring
		cmp eax, dword 4
		je revstring
		cmp eax, dword 5
		je palindrome
		cmp eax, dword 6
		je exit
		jmp Read
enterstring:
		call read_char
		call Read_String
		jmp Read
countstring:
		call read_char
		call Word_Count
		jmp Read
characterstring:
		call Remove_Blank
		jmp Read
revstring:
		call Reverse_Word
		jmp Read
palindrome:
		call read_char
		push dword[string1]
		call Is_Palindrome
		jmp Read	
exit:
		mov eax, exitmsg
		call print_string
		call print_nl
		
        popa
        mov eax, 0            ; return back to C
        leave
		ret

segment .text
Read_String:
		push ebp
		mov ebp, esp
		
		mov eax, entermsg
		call print_string
		mov ecx, 0
loopread:
		call read_char
		mov [string1 + ecx], AL
		inc ecx
		cmp AL, 0xA
		JNE loopread
		mov edx, ecx
		sub edx, 1
		mov byte[string1 + (ecx - 1)], 0x00
		mov eax, stringmsg
		call print_string
		mov eax, string1
		call print_string
		call print_nl
		call print_nl
		jmp exit1
exit1:	
		pop ebp
		ret
		
segment .text
Word_Count:
		push ebp
		mov ebp, esp

		mov edx, 0
		mov ecx, string1
	wordcount:
		mov al, [ecx]
		inc ecx
		cmp al, 0x00
		je exit2
		cmp al, 0x20
		je wordcount
		inc edx
	characterskip:
		mov al, [ecx]
		inc ecx
		cmp al, 0x00
		je exit2
		cmp al, 0x20
		jne characterskip
		jmp wordcount
	exit2:
		mov eax, numbermsg
		call print_string
		mov eax, string1
		call print_string
		mov eax, ismsg
		call print_string
		mov eax, edx
		call print_int
		call print_nl
		
		pop ebp
		ret

		
	
segment .text
Remove_Blank:
		push ebp
		mov ebp, esp

		mov edx, 0
		mov ecx, string1
	loopleading:
		mov al, [ecx]
		inc ecx
		cmp al, 0x20
		je loopleading
		cmp al, 0x00
		je exit3
	addchar:
		mov [removestring + edx], al
		inc edx
		mov al, [ecx]
		cmp al, 0x20
		je addspace
		jmp loopleading
	addspace:
		mov byte[removestring + edx], 0x20
		inc edx
		jmp loopleading
	exit3:		
		mov byte[removestring + edx], 0x00
		mov eax, stringmsg
		call print_string
		mov eax, string1
		call print_string
		call print_nl
		mov eax, charactermsg
		call print_string
		mov eax, removestring
		call print_string
		call print_nl
		
		pop ebp
		ret
		
segment .text
Reverse_Word:
		push ebp
		mov ebp, esp
		
		mov edx, reversestring
		mov ebx, 0
		mov ecx, string1
	skipspace:
		mov al, [ecx]
		inc ecx
		cmp al, 0x00
		je closemsg
		cmp al, 0x20
		je skipspace
	getword:
		mov [edx], al
		mov al, [ecx]
		inc ecx
		inc edx
		cmp al, 0x20
		je pushword
		cmp al, 0x00
		je pushword
		jmp getword
		
	pushword:
		push edx
		inc ebx
		add edx, 255b
		jmp skipspace
	closemsg:
		mov eax, stringmsg
		call print_string
		mov eax, string1
		call print_string
		call print_nl
		mov eax, reversemsg
		call print_string
	loopprint:
		pop eax
		call print_string
		mov al, 0x20
		call print_char
		dec ebx
		cmp ebx, 0
		je exit5
		jmp loopprint
	exit5:
		call print_nl
		pop ebp
		ret

segment .text
Is_Palindrome:

		push ebp
		mov ebp, esp
		
		mov edx, 0
		mov ecx, string1
	loopleading1:
		mov al, [ecx]
		inc ecx
		cmp al, 0x20
		je loopleading1
		cmp al, 0x00
		je exit31
	addchar1:
		cmp al, 0x2F
		jle skipspecial
		cmp al, 0x3A
		je skipspecial
		cmp al, 0x3B
		je skipspecial
		cmp al, 0x3C
		je skipspecial
		cmp al, 0x3D
		je skipspecial
		cmp al, 0x3E
		je skipspecial
		cmp al, 0x3F
		je skipspecial
		cmp al, 0x40
		je skipspecial
		cmp al, 'Z'
		jle lowercase
		mov [removestring + edx], al
		inc edx
		mov al, [ecx]
		cmp al, 0x20
		je addspace1
		jmp loopleading1
	skipspecial:
		mov al, [ecx]
		inc ecx
		jmp addchar1
	lowercase:
		add al, 32d
		jmp addchar1
	addspace1:
		mov byte[removestring + edx], 0x20
		inc edx
		jmp loopleading1
	exit31:		
		mov byte[removestring + edx], 0x00
		mov ecx, 0
	loopstack:
		mov al, [removestring + (edx-1)]
		mov [palindromestr + ecx], al
		inc ecx
		dec edx
		cmp edx, -1
		JNE loopstack
		mov byte[palindromestr + ecx], 0x00
		mov [tempcount], ecx
	compare:
		lea esi, [removestring]
		lea edi, [palindromestr]
		sub ecx, 1
		rep cmpsb
		JNE notequal
	equal:
		mov eax, string2msg
		call print_string
		mov eax, string1
		call print_string
		mov eax, ismsg
		call print_string
		mov eax, palindromemsg
		call print_string
		call print_nl
		call print_nl
		jmp exit4
	notequal:
		mov eax, string2msg
		call print_string
		mov eax, string1
		call print_string
		mov eax, isnotmsg
		call print_string
		mov eax, palindromemsg
		call print_string
		call print_nl
		call print_nl
	exit4:
	
		pop ebp
		ret