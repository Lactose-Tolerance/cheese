.model small
.stack 100h

.data
    operand1 db "15", "$"
    operator db "/", "$"
    operand2 db "7", "$"
    arr db 0, 0
    errormsg db "Invalid operator value", "$"


.code

main proc
    mov ax, @data
    mov ds, ax

    call newline

    mov ah, 09h
    lea dx, operand1
    int 21h

    lea dx, operator
    int 21h

    lea dx, operand2
    int 21h

    mov ah, 02h
    mov dl, '='
    int 21h

    mov si, 0

loop1:
    mov al, operand1[si]
    cmp al, '$'
    jz break1

    sub al, '0'
    mov bl, al

    mov al, arr[0]
    xor ah, ah
    mov cx, 10
    mul cx
    add al, bl
    mov arr[0], al

    inc si
jmp loop1

break1:
    mov si, 0

loop2:
    mov al, operand2[si]
    cmp al, '$'
    jz break2

    sub al, '0'
    mov bl, al

    mov al, arr[1]
    xor ah, ah
    mov cx, 10
    mul cx
    add al, bl
    mov arr[1], al

    inc si
jmp loop2
    
break2:
    mov al, arr[0]
    mov bl, arr[1]
    xor ah, ah
    xor bh, bh

    mov cl, operator[0]

    cmp cl, '+'
    jnz comparesub
    add ax, bx
    jmp finally

comparesub:
    cmp cl, '-'
    jnz comparemul
    sub ax, bx
    jmp finally

comparemul:
    cmp cl, '*'
    jnz comparediv
    mul bl
    jmp finally

comparediv:
    cmp cl, '/'
    jnz error
    div bl
    call print_decimal
    cmp ah, 0
    jz abort
    
    mov cx, ax
    mov dl, '.'
    mov ah, 02h
    int 21h
    mov ax, cx
    
    mov cx, 5
    mov bh, 10

divprintloop:
    cmp ah, 0
    jz abort
    mov al, ah
    mul bh
    div bl
    call print_decimal
loop divprintloop

    jmp abort

error:
    lea dx, errormsg
    mov ah, 09h
    int 21h
    jmp abort

finally:
    cmp ah, 0
    jz skip
    mov bh, al
    mov al, ah
    call print_decimal
    mov al, bh
skip:
    call print_decimal

abort:
    call newline
    mov ah, 4ch
    int 21h
main endp


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