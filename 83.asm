.model small
.stack 100h
.data
;matricea pt caracterul A
var
	db 00011000b
	db 00100010b
	db 10000001b
	db 10000001b
	db 11111111b
	db 10000001b
	db 10000001b
	db 10000001b

.code

start:
mov ax, 1112h ;subfuncNia 12h - încarcarea setului 8*8 ROM
mov bl, 02h ;blocul 2
int 10h

mov ax, 1104h ;subfuncNia 12h - încarcarea setului 8*16 ROM
mov bl, 03h ;blocul 3
int 10h

mov ax,@data
mov es, ax



;incarcarea noului caracter A
mov ax,1100h ;subfunctia 00h - incarcarea unui set de caractere definit de utilizator cu RESET
mov bh,8	;nr de octeti
mov bl,2	;nr blocului in care se va incarca
mov cx,1	;nr de caractere de incarcat
mov dx,41h	;codul ascii al primului caracter
lea bp,var	;ES:BP – pointer la setul de caractere ce se doreste a fi încarcat
int 10h



mov ax, 1103h ;subfuncNia 03h - setarea blocului activ
mov bl,0eh ;blocul 2 si 3
int 10h



mov ax,4c00h ;iesirea din program
int 21h
end start