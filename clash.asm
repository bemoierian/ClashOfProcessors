EXTRN execute:far 
PUBLIC commandStr,commandCode,isExternal,Instruction,Destination,Source

EXTRN startScreen:far 
EXTRN BUFFNAME:BYTE, BufferData:BYTE

EXTRN RegMemo:far
PUBLIC m0_1,m1_1,m2_1,m3_1,m4_1,m5_1,m6_1 ,m7_1,m8_1,m9_1,mA_1,mB_1 ,mC_1,mD_1,mE_1,mF_1 
PUBLIC m0_2,m1_2,m2_2,m3_2,m4_2,m5_2,m6_2 ,m7_2,m8_2,m9_2,mA_2,mB_2 ,mC_2,mD_2,mE_2,mF_2 
PUBLIC AxVar1,BxVar1,CxVar1,DxVar1,SiVar1,DiVar1,SpVar1 ,BpVar1
PUBLIC AxVar2,BxVar2,CxVar2,DxVar2,SiVar2,DiVar2,SpVar2 ,BpVar2 

include UI.inc
include gun_obj.inc



.286
.MODEL SMALL
.STACK 64
.DATA
;-------------------------Main Screen-----------------------------------
main_str1 DB 'To start chatting press F1','$'
main_str2 DB 'To start the game press F2','$'
main_str3 DB 'To end the program press ESC','$'
;----------------------------MEMORY-------------------------------------
;These variables are not in an array just to simplifie to vision
;---------Memory for player 1
m0_1 db 2fh
m1_1 DB 24
m2_1 DB 0
m3_1 DB 0ah
m4_1 DB 0
m5_1 DB 0
m6_1 DB 03h
m7_1 DB 0
m8_1 DB 0ffh
m9_1 DB 0
mA_1 DB 0
mB_1 DB 0
mC_1 DB 0
mD_1 DB 0
mE_1 DB 0
mF_1 DB 0c1h
;---------Memory for player 2
m0_2 db 2dh
m1_2 DB 01bh
m2_2 DB 0
m3_2 DB 0
m4_2 DB 0
m5_2 DB 0c1h
m6_2 DB 0
m7_2 DB 0
m8_2 DB 0
m9_2 DB 0
mA_2 DB 0
mB_2 DB 0e9h
mC_2 DB 0
mD_2 DB 0
mE_2 DB 0
mF_2 DB 0


;---------Variables for player 1
AxVar1 dw 0h
BxVar1 dw 0h
CxVar1 dw 0bbffh
DxVar1 dw 0h

SiVar1 dw 0f2ah
DiVar1 dw 0h
SpVar1 dw 0h 
BpVar1 dw 0c4bh

;---------Variables for player 2
AxVar2 dw 1ah
BxVar2 dw 12h
CxVar2 dw 154h
DxVar2 dw 4h

SiVar2 dw 0ffffh
DiVar2 dw 9Fh
SpVar2 dw 0h 
BpVar2 dw 0h


;------------------Previous and New position of Gun---------------------
gunPrevX dw 50
gunPrevY dw 50
gunNewX dw 50
gunNewY dw 50
;----------------------------------------------------------------------
;-------------------------Command String-------------------------------
commandStr LABEL BYTE
cmdMaxSize db 15 ;maximum size of command
cmdCurrSize db 0 ; current size of command
commandS db 22 dup('$') ;22 3shan bytb3 3lehom m3rfsh leh :)
cursor dw ?          ;holds the address of the upcomming letter

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
    ;Clear Screen
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
    MainScreen:
        draw_mainscreen main_str1, main_str2, main_str3 ;UI.inc
        MainInput:
            mov ah,1
            int 16h
            jz MainInput
            mov ah, 0
            int 16h
            keyF1:
                cmp ah, 3Bh ;compare key code with f1 code
                jnz keyF2    ;if the key is not F1, jump to next check
                ; jmp chat
            keyF2:
                cmp ah, 3Ch ;compare key code with f1 code
                jnz keyESC    ;if the key is not F1, jump to next check
                jmp EndMainScreen
            keyESC:
                cmp ah, 1h ;compare key code with f1 code
                jnz MainInput    ;if the key is not F1, jump to next check
                jmp EndGame
            EndMainInput:

    EndMainScreen:
    mov ah,0   ;enter graphics mode
    mov al,13h
    int 10h

    

    ;Main Game Loop
    Background                          ;background color
    horizontalline 170,0,320            ;horizontal line
    drawrectangle  120,0,0dh,10,120
    drawrectangle   5,2,0ah,5,5 ;draw shape
    verticalline 0,160,170              ;vertical line
    horizontalline 145,162,319          ;horizontal line
    drawrectangle  120,161,0Eh,10,120
    drawrectangle   5,162,0ah,5,5 ;draw shape

    ;display name
    push dx
    DisplayName
    pop dx

    mov di, offset commandS
    mov cursor, di
    
    Game:
        ;UI.inc 
        ;----------------------Test Command input----------------
        MOV  DL, 0        ;column
        MOV  DH, 15      ;row
        MOV  BH, 0        ;page
        MOV  AH, 02H      ;set cursor 
        INT  10H
        mov ah, 9h
        mov dx, offset commandS
        int 21h        
        ;--------------------------------------------------------
        DrawGun       ;gun_obj.inc
        call RegMemo
        
        
        ;draw score squares UI.inc 
         setcursor 0000
        drawrectanglewithletter  140,7,0ah,10,10,63497d,'1',0ah
    setcursor 0000
   drawrectanglewithletter  140,30,9h,10,10,63500d,'2',09h
   setcursor 0000
   drawrectanglewithletter  140,53,0ch,10,10,63503d,'3',0ch
    setcursor 0000
   drawrectanglewithletter  140,77,0dh,10,10,63506d,'4',0dh
    setcursor 0000
   drawrectanglewithletter  140,101,0Eh,10,10, 63509d,'5',0eh
    setcursor 0000

        ;Read Keyboard input
        mov ah, 1
        int 16h
        jz Game   ;if no key is pressed, go to other functions like flying objects, etc. -----------to be changed--------------
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
                jmp Game
            ;left arrow    
            left:
                cmp ah, 4Bh
                jnz up
                sub gunNewX, 3
                jmp Game
            ;up arrow
            up:
                cmp ah, 48h
                jnz down
                sub gunNewY, 3
                jmp Game
            ;down arrow
            down:
                cmp ah, 50h
                jnz commandIn
                add gunNewY, 3
            ; space:
            ;     cmp ah, 39h
            ;     jnz EndGun
            ;     ; 
            
        EndGun:
        commandIn:
            backSpace:
                cmp ah, 0Eh
                jnz InsertChar
                cmp cmdCurrSize, 0 ;if the string is empty, do nothing and continue the main loop
                jz Game
                mov di, cursor ;get cursor
                dec di
                mov [di], '$$' ;to delete a character, put $. we add 2 $ because it's a word
                dec cmdCurrSize ;decrement cursor
                mov cursor, di
                horizontalline 170,0,320            ;horizontal line
                drawrectangle  120,0,0dh,10,120     ;draw the background of the command after deleting to override the old command
                jmp Game
            InsertChar:
                ;Validation
                ; ; there is no supported characters under 30h
                ; ; range of number 30h->39h
                ; cmp al, 30h
                ; jl Game
                ; cmp al, 39h
                ; jg isChar
                ; jmp concat
                ; ;range of small letters 61h->7Ah
                ; isChar:
                ;     cmp al, 61h
                ;     jl isObracket
                ;     cmp al, 7Ah
                ;     jg Game
                ;     jmp concat
                ; ;next 2 for addressing modes
                ; isObracket:
                ;     cmp al, 5Bh
                ;     jnz isCbracket
                ;     jmp concat
                ; isCbracket:
                ;     cmp al, 5Dh
                ;     jnz isComma
                ;     jmp concat
                ; isComma:
                ;     cmp al, 2Ch
                ;     jnz Game
                ;     jmp concat
                ; ; concatinate the character after validation
                concat:
                    mov dl, cmdCurrSize
                    cmp dl, cmdMaxSize
                    jz endInsertChar
                    mov di, cursor 
                    mov [di], al
                    inc cmdCurrSize
                    inc di
                    mov cursor, di
            endInsertChar:
        endcommandIn:



        ;Exit game if key if F3
        cmp al, 13h
        jz MainScreen
        jmp Game
EndGame:
HLT
MAIN ENDP

END MAIN