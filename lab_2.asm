;LAB5 Вариант 17  

;макроопределение для вывода текста
my_write MACRO text
	mov ah, 09h
	lea dx, text
	int 21h
endm

;макроопределение для подсчета нулевых битов. t = x || l (x, если числа размером слова. l, если числа размером байта)
do_mission MACRO t
	local m1, m2, m3, m4
	mov cx, len
	mov flag, 0
	mov si, 0
	lea di, newmas  			 
	m1:
		push cx
		mov ax, 0
		mov bx, 0
		ifidni <l>, <t>
			mov cx, 8
		endif
		ifidni <x>, <t>
			mov cx, 16
			mov flag, 1
		endif
		mov b&t, mas[si]
		m2: 
			shr b&t, 1
			jc m3
			inc al
		m3:
			loop m2
			mov byte ptr[di], al
			ifidni <l>, <t>
				inc si
			endif
			ifidni <x>, <t>
				add si, 2
			endif
			m4:
			inc di
			pop cx
			loop m1
endm

;макроопределение для перевода числа в строку. Число, которое переводим должно находиться в регистре ax
convert_to_string MACRO 
        local convert1, convert2
		push cx
		mov cx, 2
		mov bx, 10
		convert1: 	
			mov dx, 0
			div bx
			add dx, 30h
			push dx
			loop convert1
		mov cx, 2
		convert2:
			pop dx
			mov ah, 2
			int 21h
			loop convert2
		pop cx
endm

dseg segment
greeting db 'The count of binary digits equal to 0 for each number:', 10, 13, '$'
mas db 1, -7, 0, 7, 2, 21;, 9, 0, 16; исходный массив
len dw ($-mas)/type mas; размер массива в байтах
nl db 10, 13, '$' 
typemas dw 0
flag db 0
count_el db 0
newmas db 20 dup(?); массив, который будет содержать количество нулевых байт чисел массива mas
dseg ends 
cseg segment 
	assume ds:dseg, es:dseg, cs:cseg
main proc far
	push ds
	sub ax, ax
	push ax
	mov ax, dseg 
	mov ds, ax
	mov es, ax
	
	my_write greeting
	
	if type mas eq 2
		do_mission x
	else
		do_mission l
	endif
	;Convert to string and output this string
	mov cx, len
	mov si, 0
	output:	 
		mov ax, 0
		mov al, newmas[si]
		convert_to_string 
		inc si 
		my_write nl
		loop output
	mov ah, 1h
	int 21h	
    ret
main endp
cseg ends
end main