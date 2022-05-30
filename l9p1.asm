.MODEL MEDIUM ;
.STACK 200H ; Set up 512 bytes of stack space

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
MOV AL, 13H ; Mod 13h
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
DesenareLinie PROC

mov ax, X2 
sub ax, X1 ; obtinem distanta  x2-x1
jnc @Dont1 ; daca x2-x1 e rezultat negativ
neg ax ; Lungime pozitiva

@Dont1:
mov DifX, ax ; Mutam diferenta in Difx;
mov ax, Y2 ; Move Y2 into AX ;
sub ax, Y1 ; Diferenta y2-y1;
jnc @Dont2 
neg ax 
@Dont2:
mov Dify, ax ; Mutam diferenta y in Dify
cmp ax, DifX ; compara difx cu Dify;
jbe @LinieNoua ;daca difx >= Dify;

mov ax, Y1 ; mutam y1 in ax
cmp ax, Y2 ; comparam y1 cu y2
jbe @DontSwap1 ; Daca Y1 <= Y2 facem salt 
mov bx, Y2 ; 
mov Y1, bx ; 
mov Y2, ax ; 
mov ax, X1 ; Put X1 into AX ;
mov bx, X2 ; Put X2 into BX ;
mov X1, bx ; Put X2 into X1 ;
mov X2, ax ; Put X1 into X2 ;

@DontSwap1:
mov IncF, 1 
mov ax, X1 
cmp ax, X2 
jbe @SkipNegate1 ; daca X1 <= X2 
neg IncF ; Negate IncF ;

@SkipNegate1:
mov ax, Y1 ; Move Y1 into AX ;
mov bx, 320 ; Move 320 into BX ;
mul bx ; Multiply 320 by Y1 ;
mov di, ax ; Put the result into DI ;
add di, X1 ; Add X1 to DI, and tada - offset in DI ;
mov bx, Dify ; Put Dify in BX ;
mov cx, bx ; Put Dify in CX ;
mov ax, 0A000h ; Put the segment to plot in, in AX ;
mov es, ax ; ES points to the VGA ;
mov dl, Color ; Put the color to use in DL ;
mov si, DifX ; Point SI to Difx ;

@DrawLoop1:
mov es:[di], dl ; Put the color to plot with, DL, at ES:DI ;
add di, 320 ; Add 320 to DI, ie, next line down ;
sub bx, si ; Subtract Difx from BX, Dify ;
jnc @GoOn1 ; Did it yield a negative result? ;
add bx, Dify ; Yes, so add Dify to BX ;
add di, IncF ; Add the amount to increment by to DI ;

@GoOn1:
loop @DrawLoop1 
jmp @ExitLine 
@LinieNoua:
mov ax, X1 ; Move X1 into AX ;
cmp ax, X2 ; Compare X1 to X2 ;
jbe @DontSwap2 ; Was X1 <= X2 ? ;
mov bx, X2 
mov X1, bx 
mov X2, ax 
mov ax, Y1 
mov bx, Y2 
mov Y1, bx 
mov Y2, ax 

@DontSwap2:
mov IncF, 320 ; Move 320 into IncF, ie, next pixel is on next row ;
mov ax, Y1 ; Move Y1 into AX ;
cmp ax, Y2 ; Compare Y1 to Y2 ;
jbe @SkipNegate2 ; Was Y1 <= Y2 ? ;
neg IncF ; No, so negate IncF

@SkipNegate2:
mov ax, Y1 ; Move Y1 into AX ;
mov bx, 320 ; Move 320 into BX ;
mul bx ; Multiply AX by 320 ;
mov di, ax ; Move the result into DI ;
add di, X1 ; Add X1 to DI, giving us the offset ;
mov bx, Difx ; Move Difx into BX ;
mov cx, bx ; Move BX into CX ;
mov ax, 0A000h ; Move the address of the VGA into AX ;
mov es, ax ; Point ES to the VGA ;
mov dl, Color ; Move the color to plot with in DL ;
mov si, Dify ; Move Dify into SI ;

@DrawLoop2:
mov es:[di], dl ; Put the byte in DL at ES:DI ;
inc di ; Increment DI by one, the next pixel ;
sub bx, si ; Subtract SI from BX ;
jnc @GoOn2 ; Did it yield a negative result? ;
add bx, Difx ; Yes, so add Difx to BX ;
add di, IncF ; Add IncF to DI ;

@GoOn2:
loop @DrawLoop2

@ExitLine:
RET
DesenareLinie ENDP

Start:

MOV AX, @DATA
MOV DS, AX ;ds pointeaza spre segementul de date

CALL InitializeMCGA 

CALL DesenareLinie 


MOV AH, 00H 
INT 16H

CALL TextMode

MOV AH, 00H 
INT 16H



MOV AH, 4CH
MOV AL, 00H
INT 21H 
END Start 