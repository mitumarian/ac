.MODEL small 
.STACK 100h

;===========================================================================

.DATA

X1 dw 80
X2 dw 320
Y1 dw 170
Y2 dw 100
color equ 50h
IncF dw 10h
DifX Dw 0000h
Dify Dw 0000h


.CODE
;--------------------------------------------------------------------

InitializareModgraficCGA PROC

MOV AX, 0A000h
MOV ES, AX ; ES now points to the VGA

MOV AH, 00H ; Setare mod video
MOV AL, 13H ; Mod 12h
INT 10H ;
RET

InitializareModgraficCGA ENDP

TextMode PROC
MOV AH, 00H ; Setare mod video
MOV AL, 03H ; Mod 03h
INT 10H ;

RET
TextMode ENDP


;--------------------------------------------------------------------------
DesenareLinii PROC

mov ax, X2 
sub ax, X1 ; obtinem distanta  x2-x1
jnc neg1 ; daca x2-x1 e rezultat negativ
neg ax ; Lungime pozitiva

neg1:
mov DifX, ax ; Mutam diferenta in DifX;
mov ax, Y2 ; Move Y2 into AX ;
sub ax, Y1 ; Diferenta y2-y1;
jnc neg2 
neg ax 
neg2:
mov Dify, ax ; Mutam diferenta y in Dify
cmp ax, DifX ; compara difx cu Dify;
jbe NewLine ;daca difx >= Dify;

mov ax, Y1 ; mutam y1 in ax
cmp ax, Y2 ; comparam y1 cu y2
jbe et1 ; Daca Y1 <= Y2 facem salt 
mov bx, Y2 ; 
mov Y1, bx ; 
mov Y2, ax ; 
mov ax, X1 ; Put X1 into AX ;
mov bx, X2 ; Put X2 into BX ;
mov X1, bx ; Put X2 into X1 ;
mov X2, ax ; Put X1 into X2 ;

et1:
mov IncF, 1 
mov ax, X1 
cmp ax, X2 
jbe et2 ; daca X1 <= X2 
neg IncF 

et2:
mov ax, Y1 ; Move Y1 into AX ;
mov bx, 320 ; Move 320 into BX ;
mul bx ; Multiply 320 by Y1 ;
mov di, ax ;DI<-resultat
add di, X1 ; X1+di - offset in DI ;
mov bx, Dify ; Dify in BX ;
mov cx, bx ;Dify in CX ;
mov ax, 0A000h ; Put the segment in AX ;
mov es, ax 
mov dl, Color ;color to use in DL ;
mov si, DifX ; Point SI to Difx ;

desenlinie1:
mov es:[di], dl 
add di, 320 ; Add 320 to DI
sub bx, si 
jnc et3
add bx, Dify 
add di, IncF 

et3:
loop desenlinie1 
jmp finish 
NewLine:
mov ax, X1 ; Move X1 into AX ;
cmp ax, X2 ; Compare X1 to X2 ;
jbe et4 ; Was X1 <= X2 ? ;
mov bx, X2 
mov X1, bx 
mov X2, ax 
mov ax, Y1 
mov bx, Y2 
mov Y1, bx 
mov Y2, ax 

et4:
mov IncF, 320 ; Move 320 into IncF, ie
mov ax, Y1 ; Move Y1 into AX ;
cmp ax, Y2 ; Compare Y1 to Y2 ;
jbe et5 ; Was Y1 <= Y2 ? ;
neg IncF 

et5:
mov ax, Y1 ; Move Y1 into AX ;
mov bx, 320 ; Move 320 into BX ;
mul bx ; Multiply AX by 320 ;
mov di, ax ;DI<-result ;
add di, X1 ; Add X1 to DI,  offset ;
mov bx, Difx ; Move Difx into BX ;
mov cx, bx ; Move BX into CX ;
mov ax, 0A000h 
mov es, ax 
mov dl, Color 
mov si, Dify ;  SI <-dify;

desenlinie2:
mov es:[di], dl ; Put the byte in DL at ES:DI ;
inc di 
sub bx, si 
jnc et6 ;  negative result? ;
add bx, Difx ; Yes, so add Difx to BX ;
add di, IncF ; Add IncF to DI ;

et6:
loop desenlinie2

finish:
RET
DesenareLinii ENDP

Start:

MOV AX, @DATA
MOV DS, AX ;ds pointeaza spre segementul de date

CALL InitializareModgraficCGA

CALL DesenareLinii 


MOV AH, 00H 
INT 16H

CALL TextMode

MOV AH, 00H 
INT 16H



MOV AH, 4CH
MOV AL, 00H
INT 21H 
END Start 