.model small
.stack 100h

.data
    func db "STRLEN", "$"
    str1 db "World", "$"
    str2 db "World", "$"
    errormsg db "Invalid string command", "$"

.code

main proc
    mov ax, @data
    mov ds, ax

lencheck:
    mov al, func[0]
    cmp al, 'S'
    jnz cmpcheck

    mov al, func[1]
    cmp al, 'T'
    jnz cmpcheck

    mov al, func[2]
    cmp al, 'R'
    jnz cmpcheck

    mov al, func[3]
    cmp al, 'L'
    jnz cmpcheck

    mov al, func[4]
    cmp al, 'E'
    jnz cmpcheck

    mov al, func[5]
    cmp al, 'N'
    jnz cmpcheck

    mov al, func[6]
    cmp al, '$'
    jnz cmpcheck

    call strlen
jmp abort


cmpcheck:
    mov al, func[0]
    cmp al, 'S'
    jnz revcheck

    mov al, func[1]
    cmp al, 'T'
    jnz revcheck

    mov al, func[2]
    cmp al, 'R'
    jnz revcheck

    mov al, func[3]
    cmp al, 'C'
    jnz revcheck

    mov al, func[4]
    cmp al, 'M'
    jnz revcheck

    mov al, func[5]
    cmp al, 'P'
    jnz revcheck

    mov al, func[6]
    cmp al, '$'
    jnz revcheck

    call strcmp
jmp abort


revcheck:
    mov al, func[0]
    cmp al, 'S'
    jnz error

    mov al, func[1]
    cmp al, 'T'
    jnz error

    mov al, func[2]
    cmp al, 'R'
    jnz error

    mov al, func[3]
    cmp al, 'R'
    jnz error

    mov al, func[4]
    cmp al, 'E'
    jnz error

    mov al, func[5]
    cmp al, 'V'
    jnz error

    mov al, func[6]
    cmp al, '$'
    jnz error

    call strrev
jmp abort


error:
    lea dx, errormsg
    mov ah, 09h
    int 21h


abort:
    mov ah, 4ch
    int 21h
main endp




strlen proc
    push ax
    push dx
    push si

    mov si, 0

strlenloop:
    mov al, str1[si]
    cmp al, '$'
    jz strlenbreak
    inc si
jmp strlenloop

strlenbreak:
    lea dx, func
    mov ah, 09h
    int 21h

    mov dl, '('
    mov ah, 02h
    int 21h

    mov dl, '"'
    int 21h

    lea dx, str1
    mov ah, 09h
    int 21h

    mov dl, '"'
    mov ah, 02h
    int 21h

    mov dl, ')'
    int 21h

    mov dl, '='
    int 21h

    mov ax, si
    call print_decimal

    pop si
    pop dx
    pop ax
    ret
strlen endp




strcmp proc
    push ax
    push dx
    push si
    mov si, 0

strcmploop:
    mov ah, str1[si]
    mov al, str2[si]

    cmp ah, '$'
    jz lastcomp
    cmp al, '$'
    jz morethan

    inc si
    cmp ah, al
jz strcmploop
js lessthan
jmp morethan

lastcomp:
    cmp al, '$'
    jnz lessthan

    mov dl, '"'
    mov ah, 02h
    int 21h

    lea dx, str1
    mov ah, 09h
    int 21h

    mov dl, '"'
    mov ah, 02h
    int 21h

    mov dl, '='
    int 21h
    
    mov dl, '"'
    int 21h

    lea dx, str2
    mov ah, 09h
    int 21h

    mov dl, '"'
    mov ah, 02h
    int 21h

    jmp strcmpend


lessthan:
    mov dl, '"'
    mov ah, 02h
    int 21h

    lea dx, str1
    mov ah, 09h
    int 21h

    mov dl, '"'
    mov ah, 02h
    int 21h

    mov dl, '<'
    int 21h
    
    mov dl, '"'
    int 21h

    lea dx, str2
    mov ah, 09h
    int 21h

    mov dl, '"'
    mov ah, 02h
    int 21h

    jmp strcmpend


morethan:
    mov dl, '"'
    mov ah, 02h
    int 21h

    lea dx, str1
    mov ah, 09h
    int 21h

    mov dl, '"'
    mov ah, 02h
    int 21h

    mov dl, '>'
    int 21h
    
    mov dl, '"'
    int 21h

    lea dx, str2
    mov ah, 09h
    int 21h

    mov dl, '"'
    mov ah, 02h
    int 21h


strcmpend:
    pop si
    pop dx
    pop ax
    ret
strcmp endp




strrev proc
    push ax
    push dx
    push si
    push di

    lea dx, func
    mov ah, 09h
    int 21h

    mov dl, '('
    mov ah, 02h
    int 21h

    mov dl, '"'
    int 21h

    lea dx, str1
    mov ah, 09h
    int 21h

    mov dl, '"'
    mov ah, 02h
    int 21h

    mov dl, ')'
    int 21h

    mov dl, '='
    int 21h

    mov si, 0

strlenloop2:
    mov al, str1[si]
    cmp al, '$'
    jz strlenbreak2
    inc si
jmp strlenloop2

strlenbreak2:
    mov di, 0
    dec si
    
strrevloop:
    mov al, str1[si]
    mov ah, str1[di]
    mov str1[di], al
    mov str1[si], ah
    dec si
    inc di
    cmp si, di
jz revloopbreak
js revloopbreak

revloopbreak:    
    mov dl, '"'
    mov ah, 02h
    int 21h

    lea dx, str1
    mov ah, 09h
    int 21h

    mov dl, '"'
    mov ah, 02h
    int 21h

    pop di
    pop si
    pop dx
    pop ax
    ret
strrev endp




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

end