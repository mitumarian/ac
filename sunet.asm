.model large
.stack 100h
.code
    Old_08 label dword
    Old_08_off dw ?
    Old_08_seg dw ?
    contor db ?
    contor1 dw ?
    note dw 03ch, 0e2h, 089h, 0d5h, 08dh, 0c9h, 03dh, 0beh, 090h, 0b3h, 07ch, 0a9h, 0f9h, 09fh, 0feh, 096h
         dw 085h, 08eh, 085h, 086h, 0f8h, 07eh, 0d8h, 077h, 01eh, 071h, 0c4h, 06ah, 0c6h, 064h, 01eh, 05fh
            
;procedura sound, genereaza un sunet de anumita frecventa
sound proc far
    mov ax, 22AAh       
    mov dx, 0012h       
    div bx              
    mov bx,ax
    in  al, 61h         
    
    test   al, 03h     ;verifica cei mai putin semnificativi biti
    jne et1         ;daca sunt pe 1 sare
    
    or  al, 03h         
    out 61h, al         ;da drumul la sunet
    mov al, 0B6h        
    out 43h, al         
    
et1: 
    mov al, bl          
    out 42h, al         
    mov al, bh          
    out 42h, al         
    ret
sound endp

;procedura nosound, opreste sunetul
nosound proc far
    in  al, 61h         
    and al, 0FCh        
    out 61h, al         
    ret
nosound endp

slow proc near
    push cx
    push ax
    mov cx,0020H
    
et: 
    mul al
    loop et
    pop ax
    pop cx
    ret                 
slow endp

;MAIN-UL
start:  
    mov al,0h           
    mov cs:contor,al
    mov cs:contor1, 0
    
    mov ax,3508h        ;citirea vector intrerupere
    int 21h             ;timer sistem
    
    mov cs:Old_08_off,bx 
    mov cs:Old_08_seg,es 
    mov ax,cs
    mov ds,ax
    mov dx,offset New_08
    
    mov ax,2508h
    int 21h
    
    mov bx, cs:note[si]
    cmp bx, 0
    je  ns
    call sound
    
ns: 
    call nosound
    inc si
    cmp si, 20h
    jbe salt
    mov si, 0
    
salt:   
    mov cs:contor1, si
    call slow
    
    mov ah,0                ;asteptarea unei taste
    int 16h 
    
    mov ax,cs:Old_08_seg
    mov ds,ax
    mov dx,cs:Old_08_off
    mov ax,2508h
    int 21h

    mov ax, 4c00h
    int 21h

New_08 proc far
    mov al, cs:contor
    push ax
    add al, '0'
    mov ah, 0eh
    mov bx, 0
    int 10h
    pop ax
    inc al
    cmp al, 0ah  
    jne next  
    xor al, al  
    
next:
    mov cs:contor, al
    pushf
    call cs:Old_08
    iret 
New_08 endp

end start