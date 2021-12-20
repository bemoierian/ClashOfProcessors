
EXTRN execute:far 
PUBLIC commandStr,commandCode,isExternal,Instruction,Destination,Source

EXTRN startScreen:far 
EXTRN BUFFNAME:BYTE
EXTRN BufferData:BYTE

include UI.inc
include gun_obj.inc

.286
.MODEL SMALL
.STACK 64
.DATA
;------------------Variables for registers drawing----------------------
Rectanglexpos dw 10
Rectangleypos dw 10
Regvalue_YPOS db 2
Regvalue_XPOS db 3
counterDrawRegisters db 4
;------------------Previous and New position of Gun---------------------
gunPrevX dw 50
gunPrevY dw 50
gunNewX dw 50
gunNewY dw 50
;----------------------------------------------------------------------
commandStr db "mov ax,bx"
commandCode LABEL BYTE
isExternal db 0
Instruction dw 0000
Destination dw 0000
Source dw 0000
.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    UserNames:
            call startScreen  ;start.asm 
    EndUserNames:
    
    MainScreen:

    EndMainScreen:
    mov ah,0   ;enter graphics mode
    mov al,13h
    int 10h
    ;Main Game Loop
    Game:
        ;UI.inc 
        Background                          ;background color
        horizontalline 170,0,320            ;horizontal line
        drawrectangle  120,0,0dh,10,120
        verticalline 0,160,170              ;vertical line
        horizontalline 145,162,319          ;horizontal line
        drawrectangle  120,161,0Eh,10,120

        DrawGun       ;gun_obj.inc
        DrawRegisters ;UI.inc 
        
       
        ;draw squares UI.inc 
        displayletter 63497d,'1',0ah
        setcursor 0000

        displayletter 63500d,'2',09h
        setcursor 0000
        
        displayletter 63503d,'3',0ch
        setcursor 0000

        displayletter 63506d,'4',0dh
        setcursor 0000
        
        displayletter 63509d,'5',0eh
        setcursor 0000

        drawrectangle  140,7,0ah,10,10
        drawrectangle  140,30,9h,10,10
        drawrectangle  140,53,0ch,10,10
        drawrectangle  140,77,0dh,10,10
        drawrectangle  140,101,0Eh,10,10

        ;Read Keyboard input
        mov ah, 1
        int 16h
        jz EndGun   ;if no key is pressed, go to other functions like flying objects, etc. -----------to be changed--------------
        mov ah, 0
        int 16h
        ;AL contains ascii of key pressed
        ;-------------------------------------------------INPORTANT NOTE-------------------------------------------------------
        ;DON'T CALL ANY FUNCTION HERE THAT CHANGES THE VALUE OF AX,
        ;IF YOU WANT TO USE AX, PUSH IT IN REG THEN POP WHEN YOU FINISH TO RESTORE ITS VALUE 
        Gun:
            ;right arrow
            right:
                cmp ah, 4Dh ;compare key code with right key code
                jnz left    ;if the key is not right, jump to next check
                add gunNewX, 3  ;if the key is right, move the gun 3 pixels to the right
                jmp EndGun
            ;left arrow    
            left:
                cmp ah, 4Bh
                jnz up
                sub gunNewX, 3
                jmp EndGun
            ;up arrow
            up:
                cmp ah, 48h
                jnz down
                sub gunNewY, 3
                jmp EndGun
            ;down arrow
            down:
                cmp ah, 50h
                jnz EndGun
                add gunNewY, 3
        EndGun:     

        ;Exit game if key if F3
        cmp al, 13h
        jz MainScreen
        jmp Game
HLT
MAIN ENDP

END MAIN