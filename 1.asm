.model small
.stack 100h

.data
	msg1 db "Data bytes stored starting from 3000h: $"
	msg2 db "Moved bytes from 3000h to 4000h.$"
	msg3 db "Data bytes stored starting from 4000h: $"
	bytes db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	buffer db 10 dup(?)
.code

main proc
;--Initialise data segment--
	mov ax, @data
	mov ds, ax

;--Writing array 'bytes' into memory starting from 3000h--
	mov si, 0
	mov cx, 10
write_src:
	mov al, bytes[si]
	mov [3000h + si], al
	inc si
	loop write_src


;--Displaying message--
	lea dx, msg1
	mov ah, 09h
	int 21h
	call newline


;--Printing memory starting from 3000h--
	mov si, 3000h
	mov cx, 10
	call print
	call newline
	call newline


;--Reading memory starting from 3000h into array 'buffer'--
	mov si, 0
	mov cx, 10
read_src:
	mov al, [3000h + si]
	mov buffer[si], al
	inc si
	loop read_src


;--Performing operations--
	mov si, 0
	mov cx, 10
operate:
	mov al, buffer[si]
	mov bl, 5
	mul bl
	add ax, 10
	mov buffer[si], al
	inc si
	loop operate

;--Writing array 'buffer' into memory starting from 4000h--
	mov si, 0
	mov cx, 10
write_dst:
	mov al, buffer[si]
	mov [4000h + si], al
	inc si
	loop write_dst


;--Displaying message--
	lea dx, msg2
	mov ah, 09h
	int 21h
	call newline
	call newline

	lea dx, msg3
	mov ah, 09h
	int 21h
	call newline


;--Printing memory starting from 4000h--
	mov si, 4000h
	mov cx, 10
	call print

;--Terminate--
	mov ah, 4ch
	int 21h
main endp



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
