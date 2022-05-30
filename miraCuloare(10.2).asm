.model small
.stack 100h
.data
    crtmode db 0
.code
SetVideoMode proc near
    mov ah, 00h
    int 10h
    ret
SetVideoMode endp

GetVideoMode proc near
    mov ah, 0fh
    int 10h
    ret
GetVideoMode endp

Square proc near
    mov ax, 0a000h
    mov es, ax
    mov bp, sp
    mov cx, [bp+4]
    sub cx, [bp+8]
    mov di, cx
    mov bx, [bp+8]
e1:
    mov cx, [bp+6]
    sub cx, [bp+10]
e2:
    push dx
    mov ax, 320
    mul bx
    pop dx
    add ax, dx
    mov si, ax
    mov ax, [bp+2]
    mov es:[si], al
    inc dx
    loop e2
    inc bx
    dec di
    jnz e1
Square endp

SetColorRegister proc near
    mov ax, 1010h
    int 10h
    ret
SetColorRegister endp

Getch proc near
    mov ah, 0
    int 16h
    ret
Getch endp

start:
    mov ax, @data
    mov es, ax
    call GetVideoMode
    mov crtmode, al
    mov al, 13h
    call SetVideoMode
    mov ax, 10
    push ax
    mov ax, 10
    push ax
    mov ax, 50
    push ax
    mov ax, 50
    push ax
    mov ax, 10
    push ax
et3:
    call Square
    call Getch
    cmp al, 27
    je fin
    mov bx, 1
    mov ch, 0
    mov cl, 0
    mov dh, 0
    call SetColorRegister
    call Square
    call Getch
    cmp al, 27
    je fin
    mov bx, 10
    mov ch, 0
    mov cl, 63
    mov dh, 0
    call SetColorRegister
    jmp et3
fin:
    mov al, crtmode
    call SetVideoMode
    mov ax, 4c00h
    int 21h
end start