section .data
msg:	db "Es Biciesto",10	
len:	equ $-msg 
msg2:	db "No Es Biciesto",10	
len2:	equ $-msg2


section .bss

	annio: resb 10 ;Donde se guarda el string de entrada


section .text
global _start

_start:
	xor ebp,ebp ;limpio el ebp porque sirve de indice al limpiar annio
	call limpiadorin ; limpio annio
leer: ;lee de la pantalla el año 
	mov eax, 3
	mov ebx, 0
	mov ecx, annio
	mov edx, 2048
	int 80h

	mov esi,ecx ;mueve el annio que esta como string al esi
	mov ecx,4 
	call string_to_int ; manda como parametros en esi el string del año para convertirlo a numero, y lo devuelve el int en el eax y en el ebx

SaberBiciesto: ;con esto vemos si el año es biciesto o no
	mov ecx,4 ;para dividir entre 4
	xor edx,edx	
	div ecx
	cmp edx,0
	jne impNoes
	mov eax,ebx
	mov ecx,100 ; dividir entre 100
	xor edx,edx
	div ecx
	cmp edx,0
	jne impEs
	mov eax,ebx
	mov ecx,400 ;dividir entre 400
	xor edx,edx
	div ecx
	cmp edx,0
	jne impNoes
	je impEs


limpiadorin: ;para limpiar el buffer de annio
	mov byte[annio+ebp],00h
	cmp ebp,10
	pushf
	inc ebp
	popf
	jne limpiadorin
	xor ebp,ebp
	ret

string_to_int:
 	 xor ebx,ebx    ; clear ebx 
	.next_digit:
 		 movzx eax,byte[esi]
  		 inc esi
 		 sub al,'0'    ; convert from ASCII to number
 		 imul ebx,10
 		 add ebx,eax   ; ebx = ebx*10 + eax
 		 cmp byte[esi+1],0h
                 jne .next_digit 
 		 mov eax,ebx
 	ret

impNoes:
	mov eax,4
	mov ebx,1
	mov ecx,msg2
	mov edx,len2
	int 80h
	jmp salir
	
	
impEs:
	push eax
	push ebx
	push edx
	mov eax,4
	mov ebx,1
	mov ecx,msg
	mov edx,len
	int 80h
	jmp salir
;Sale del programa
salir:
	mov eax,1
	mov ebx,0
	int 80h
