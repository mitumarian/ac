.model large ; modelul de memorie

.stack 100h ; dimensiune stiva - 256 octeti

.code

    Old_08 label dword

    Old_08_off dw ? ;offsetul vechii rutine 08h

    Old_08_seg dw ? ;adresa de segment a vecii rutine 08h

    count db ? ;contorul ce va fi afisat

start:

    xor al,al ;al ia valoarea 0
    
    mov cs:count,al ; count ia valorea 0
    
    mov ax,3508h ;in al fct 35 , in ah 08h => obtinem vectorul de intrerupere
    ;in bx obtinem offsetul
    ;in es obtinem adresa de segment
    
    int 21h
    
    mov cs:Old_08_off,bx;salvam vechiul offset
    
    mov cs:Old_08_seg,es;salvam vechea adr de segment
    
    mov ax,cs;adr de seg al noii intreruperi
    
    mov ds,ax
    
    mov dx,offset New_08;offsetul pt noua intrerupere 08h
    
    mov ax,2508h; cu functia 25h vectorul de intrerupere va pointa spre New_08
    
    int 21h
    
    mov ah,0;asteptam dupa o tasta
    
    int 16;asteptam dupa o tasta
    
    mov ax,cs:Old_08_seg;punem inapoi vechea adr de seg
    
    mov ds,ax
    
    mov dx,cs:Old_08_off;punem inapoi vechul offset
    
    mov ax,2508h
    
    int 21h
    
    mov ax,4c00h ;terminarea programului
    
    int 21h
    
New_08 proc far

    mov al,cs:count ;citirea contorului
    
    push ax ;salvam ax in stiva
    
    add al,'0';transformam al in ascii
    
    mov ah,0eh;functia 0eh afiseaza caracterul
    
    mov bx,0
    
    int 10h
    
    pop ax;restauram ax
    
    inc al;crestem contorul
    
    cmp al,0ah;daca a ajuns contorul la 10
    
    jne next;daca da sarin la next
    
    xor al,al;al ia valoarea 0
    
next:
    
    mov cs:count,al;refacem cs-ul
    
    pushf;salvam flagurile in stiva
    
    call cs:Old_08;apelam vechea rutina
    
    iret;revenim
    
New_08 endp

end start
