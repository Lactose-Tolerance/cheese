.model small
.stack 100h

.data
	str db "Hello World!$"

.code
	mov ax, @data
	mov ds, ax

	lea dx, str
	mov ah, 09h
	int 21h

	mov ah, 4ch
	int 21h
end
