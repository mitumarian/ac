.model small
.stack
.data
    sir1 db 'F', 2Eh, 'I', 2eh, 'L', 2eh, 'E', 2eh, 'E', 1eh, 'D', 1eh, 'I', 1eh, 'T', 1eh, 'E', 1eh, 'X', 1eh, 'I', 1eh, 'T', 1eh
    sir2 db 'F', 1Eh, 'I', 1eh, 'L', 1eh, 'E', 1eh, 'E', 2eh, 'D', 2eh, 'I', 2eh, 'T', 2eh, 'E', 1eh, 'X', 1eh, 'I', 1eh, 'T', 1eh
    sir3 db 'F', 1Eh, 'I', 1eh, 'L', 1eh, 'E', 1eh, 'E', 1eh, 'D', 1eh, 'I', 1eh, 'T', 1eh, 'E', 2eh, 'X', 2eh, 'I', 2eh, 'T', 2eh
    Temp dw 0
    Ten dw 0
    x db 0
    y db 0
.code

    mov ax,@data
    mov ds, ax
    call citire
    mov ax, 0
    add al, y
    cmp al, 4
    jge et1
    mov ax, 0b800h
    mov es, ax
    mov di, 0
    lea si, sir1
    mov cx, 24
    rep movsb
    jmp finish
et1:
    cmp al, 8
    jge et2
    mov ax, 0b800h
    mov es, ax
    mov di, 0
    lea si, sir2
    mov cx, 24
    rep movsb
    jmp finish
et2:
    mov ax, 0b800h
    mov es, ax
    mov di, 0
    lea si, sir3
    mov cx, 24
    rep movsb
finish:
    mov ax, 4c00h
    int 21h
    
citire proc near
    mov cx, 0
    mov cl, es:[80h]
    inc cl
    mov ax, es
    add ax, 80h
    mov es, ax
    mov bx, 0
    
    call proc1
    
    call proc2
    mov x, al
    
    call proc1
    call proc2
    mov y, al
    
    add al, x
    cmp al, 0
    je fin
    
    mov ax, 40h
    mov es, ax
    mov bh, es:[62h]
    mov ah, 02h
    mov dh, x
    mov dl, y
    int 10h
fin:
    ret
    
citire endp

proc1 proc near
Getch:
    inc bx
    mov dl, es:[bx]
    cmp cx, bx
    jl fin1
    cmp dl, 30h
    jl Getch
    cmp dl, 39h
    ja Getch
fin1:
    ret
    
proc1 endp

proc2 proc near
    mov ax, 0
Next:
    cmp dl, 30h
    jl fin2
    cmp dl, 39h
    ja fin2
    sub dl, 30h
    mov Temp, dx
    mul Ten
    add ax, Temp
    mov dx, 0
    inc bx
    mov dl, es:[bx]
    cmp bx, cx
    jl Next
fin2:
    ret
    
proc2 endp
    end