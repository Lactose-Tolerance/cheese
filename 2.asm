.model small
.stack 100h

.data
    prompt1 db "Enter a number: $"

.code
main proc
    mov ax, @data
    mov ds, ax

    lea dx, prompt1
    mov ah, 09h
    int 21h

    call read_decimal
    call print_decimal

    mov ah, 4ch
    int 21h
main endp


; Reads 8-bit unsigned decimal number (0–255) into AL
read_decimal PROC
    push bx
	push cx

    xor ax, ax        ; AX = 0
	xor cl, cl

read_loop:
    mov ah, 01h       ; read char
    int 21h
    cmp al, 0Dh       ; Enter?
    je done

    sub al, '0'       ; ASCII → digit
    mov bl, al        ; save digit

    mov al, cl
	mov bh, 10
	mul bh

	add al, bl
	mov cl, al

    jmp read_loop

done:
	pop cx
    pop bx
    ret
read_decimal ENDP


print proc
next:
	mov al, [si]
	call print_decimal

	mov dl, ' '
	mov ah, 02h
	int 21h

	inc si
	loop next

	ret
print endp


print_decimal proc
	push ax
	push bx
	push cx
	push dx

	xor ah, ah
	mov bx, 10
	xor cx, cx

div_loop:
	xor dx, dx
	div bx
	push dx
	inc cx
	cmp ax, 0
	jne div_loop

print_digits:
	pop dx
	add dl, '0'
	mov ah, 02h
	int 21h
	loop print_digits

	pop dx
	pop cx
	pop bx
	pop ax

	ret
print_decimal endp


newline proc
	push ax
	push bx
	push cx
	push dx

	mov dl, 0Dh
	mov ah, 02h
	int 21h

	mov dl, 0Ah
	mov ah, 02h
	int 21h

	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
newline endp

end