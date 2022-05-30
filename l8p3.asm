;Sa se scrie un program care instaleaza doua seturi de caractere simultan, 
;unul dintre ele fiind definit de utilizator, celalalt fiind un set de caractere predefinit.

.model small
.DATA
temp db 00000000b
     db 00000000b
     db 01111110b
     db 01100110b
     db 01100110b
     db 01100000b
     db 01100000b
     db 01100000b
     db 01100000b
     db 01100110b
     db 01100110b
     db 01100110b
     db 00000000b
     db 00000000b
     db 00000000b
     db 00000000b



     carC db 43h     ;set de caractere definit de utilizator (1 singur caracter : C)
.CODE
START:
  mov ax,@data
  mov ds,ax
  mov es,ax

  mov ah,11h
  mov al,10h        ;Subfunctia 10h:incarcare caracter definit de utilizator
  mov bh,16     ;pe 16 octeti
  mov bl,1      ;in blocul 1
  mov cx,1      ;1 caracter
  mov dx,41h        ;offset C in bloc
  lea bp,temp       ;pointer definitie noua
  int 10h   

  mov ah,11h
  mov al,12h        ;subfunctia 12h: ?ncarcarea setului 8*8 din ROM.
  mov bl,0      ;in blocul 0
  int 10h

  mov ah,11h
  mov al,3h     ;3h: setarea blocului (setului de caractere) activ.
  mov bl,0      ;valoarea incarcata in registrul de selectare a setului de caractere activ
  int 10h

  mov ah,0      ;Read keyboard output
  int 16h
  mov ax,4c00h
  int 21h
end START
