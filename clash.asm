;-------------------------start.asm---------------------------
EXTRN startScreen1:far 
EXTRN BUFFNAME1:BYTE, BufferData1:BYTE
EXTRN startScreen2:far 
EXTRN BUFFNAME2:BYTE, BufferData2:BYTE
;-------------------------RM.asm---------------------------
EXTRN RegMemo:far
PUBLIC m0_1,m1_1,m2_1,m3_1,m4_1,m5_1,m6_1 ,m7_1,m8_1,m9_1,mA_1,mB_1 ,mC_1,mD_1,mE_1,mF_1 
PUBLIC m0_2,m1_2,m2_2,m3_2,m4_2,m5_2,m6_2 ,m7_2,m8_2,m9_2,mA_2,mB_2 ,mC_2,mD_2,mE_2,mF_2 
PUBLIC AxVar1,BxVar1,CxVar1,DxVar1,SiVar1,DiVar1,SpVar1 ,BpVar1
PUBLIC AxVar2,BxVar2,CxVar2,DxVar2,SiVar2,DiVar2,SpVar2 ,BpVar2
PUBLIC Carry_1,Carry_2
;-------------------------chat.asm---------------------------
EXTRN Chat:far 
;-------------------------command.asm---------------------------
EXTRN execute:far 
PUBLIC commandStr,commandCode,isExternal,Instruction,Destination,Source,External
PUBLIC commandS
;-------------------------Gun.asm---------------------------
EXTRN DrawGun:far
EXTRN FireGun_initial:far
EXTRN FireGun_Continue:far
EXTRN FlyObj_Continue:far
EXTRN FlyObj_initial:far
EXTRN gun1PrevX:WORD,gun1PrevY:WORD,gun1NewX:WORD,gun1NewY:WORD
EXTRN l11:BYTE,c11:BYTE,l12:BYTE,c12:BYTE,l13:BYTE,c13:BYTE,l14:BYTE,c14:BYTE,l15:BYTE,c15:BYTE,l21:BYTE,c21:BYTE,l22:BYTE,c22:BYTE,l23:BYTE,c23:BYTE,l24:BYTE,c24:BYTE,l25:BYTE,c25:BYTE
;-------------------powerups.asm----------------------------
EXTRN forbiddin_char1:BYTE,forbiddin_char2:BYTE
EXTRN power_up3_player1:FAR
EXTRN power_up3_player2:FAR
EXTRN power_up4_player1:FAR
EXTRN power_up4_player2:FAR
EXTRN power_up5_player1:FAR
EXTRN power_up5_player2:FAR
PUBLIC P1_score,P2_score
;-------------------------LEVEL.ASM--------------------------
EXTRN forbiddin_char1:BYTE,forbiddin_char2:BYTE,chosen_level:BYTE
EXTRN select_level:FAR
EXTRN show_level:FAR
EXTRN select_forbidden_char1:FAR
EXTRN select_forbidden_char2:FAR
EXTRN show_forb_chars:FAR


;-----------------------win.asm------------------

EXTRN printwin1:BYTE,printwin2:BYTE,winner:BYTE
EXTRN CheckWinner:far
;-------------------------UI.inc------------------------------
include UI.inc

.286
.MODEL HUGE
.STACK 64
.DATA
;-------------------------Main Screen-----------------------------------
main_str1 DB 'To start chatting press F1','$'
main_str2 DB 'To start the game press F2','$'
main_str3 DB 'To end the program press ESC','$'
;----------------------------MEMORY-------------------------------------
;These variables are not in an array just to simplifie to vision
;---------Registers for player 1
AxVar1 dw 105eh
BxVar1 dw 3
CxVar1 dw 4
DxVar1 dw 0

SiVar1 dw 0
DiVar1 dw 0
SpVar1 dw 0
BpVar1 dw 0
;---------Memory for player 1
m0_1 db 0
m1_1 DB 0
m2_1 DB 0
m3_1 DB 0
m4_1 DB 0
m5_1 DB 0
m6_1 DB 0
m7_1 DB 0
m8_1 DB 0
m9_1 DB 0
mA_1 DB 0
mB_1 DB 0
mC_1 DB 0
mD_1 DB 0
mE_1 DB 0
mF_1 DB 0
Carry_1 DB 0
;---------------------------------------
;---------Registers for player 2
AxVar2 dw 0
BxVar2 dw 0
CxVar2 dw 0
DxVar2 dw 0

SiVar2 dw 0
DiVar2 dw 0
SpVar2 dw 0 
BpVar2 dw 0
;---------Memory for player 2
m0_2 db 0
m1_2 DB 0
m2_2 DB 0
m3_2 DB 0
m4_2 DB 0
m5_2 DB 0
m6_2 DB 0
m7_2 DB 0
m8_2 DB 0
m9_2 DB 0
mA_2 DB 0
mB_2 DB 0
mC_2 DB 0
mD_2 DB 0
mE_2 DB 0
mF_2 DB 0

Carry_2 DB 0
;-------------------------Command String-------------------------------
commandStr LABEL BYTE
cmdMaxSize db 15 ;maximum size of command
cmdCurrSize db 0 ; current size of command
commandS db 22 dup('$') ;22 3shan bytb3 3lehom m3rfsh leh :)
cursor dw ?          ;holds the address of the upcomming letter

commandCode LABEL BYTE
isExternal db 0
Instruction db 00
Destination db 00
Source db 00
External dw 0000
;------------------------Empty string------------------------------
EmptyString db 22 dup('$')
;----------------------------Error----------------------------------
isError db 0
;---------------------------------Turns------------------------------
Turn db 1
;--------------------------From start screen-------------------------
P2_score db 0
P1_score db 0
;---------------------------INPUT FLAGS-------------------------
isGun db 0
isBackSpace db 0
isEnter db 0
isChar db 0
isPowerUp db 0
;----------------------------------------------------------

cyclesCounter1 dw 0
cyclesCounter2 DW 0
.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
    UserNames:
        call startScreen1  ;start.asm 
        call startScreen2 
    EndUserNames:
    ;Clear Screen
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
    ;CHOOSE LEVEL
    CALL select_level
    CALL show_level
    CALL select_forbidden_char1
    CALL select_forbidden_char2
    CALL show_forb_chars
    ;CLEAR SCREEN
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
                jnz keyESC    ;if the key is not F2, jump to next check
                jmp EndMainScreen
            keyESC:
                cmp ah, 1h ;compare key code with f1 code
                jnz MainInput    ;if the key is not esc, take input again
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
    
    verticalline 0,160,170              ;vertical line
     ;horizontalline 145,162,319          ;horizontal line
    drawrectangle  120,161,0Eh,10,120
    

    ;display name
    CALL DisplayNamesAndScore
    ;START THE GAME
    mov di, offset commandS
    mov cursor, di
    Game:
        ;---------------------------
         push cx
         call  CheckWinner
         pop cx
        ;  cmp winner,1
        ;  jz  EndGame

        ;  cmp winner,2
        ;   jz EndGame 

          
      
        inc cyclesCounter1
        inc cyclesCounter2
        CALL ResetInputFlags
        CALL PrintCommandString
        ;----------------------gun.asm----------------------------- 

        CALL FireGun_Continue

        cmp cyclesCounter1, 100H
        jnz dontInitiateFly
        CALL FlyObj_initial
        mov cyclesCounter1, 0
        dontInitiateFly:

        cmp cyclesCounter2, 2H
        jnz dontDrawFly
        CALL FlyObj_Continue
        mov cyclesCounter2, 0
        dontDrawFly:
        ;----------------------rm.asm-----------------------------
        call RegMemo
         mov l11,01
       mov c11,0ah

       mov l12,05
       mov c12,9h

       mov l13,03
       mov c13,0ch

        mov l14,08
       mov c14,0eh

       mov l15,02
       mov c15,0dh

       mov l21,07
       mov c21,0ah


       mov l22,04
       mov c22,9h

       mov l23,05
       mov c23,0ch

       mov l24,09
       mov c24,0eh

       mov l25,09
       mov c25,0dh
     
        setcursor 0000
       drawrectanglewith  140,7,c11,15,15,63497d,l11,c11
       setcursor 0000
       drawrectanglewith  140,30,c12,15,15,63500d,l12,c12
       setcursor 0000
       drawrectanglewith  140,53,c13,15,15,63503d,l13,c13
       setcursor 0000
       drawrectanglewith  140,77,c14,15,15,63506d,l14,c14
       setcursor 0000
       drawrectanglewith  140,101,c15,15,15, 63509d,l15,c15
    
        setcursor 0000  
        drawrectanglewith  120,163,c21,15,15,63518d,l21,c21
        setcursor 0000
        drawrectanglewith  120,186,c22,15,15,63521d,l22,c22
        setcursor 0000
        drawrectanglewith   120,209,c23,15,15,63524d,l23,c23
        setcursor 0000
        drawrectanglewith  120,232,c24,15,15,63527d,l24,c24
        setcursor 0000
        drawrectanglewith  120,255,c25,15,15, 63530d,l25,c25



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
        ;----------------------------GUN--------------------------------
        CALL GunInput
        CMP isGun, 1
        jz Game
        ;------------------------BACKSPACE------------------------------
        CALL BackspaceInput
        CMP isBackSpace, 1
        jz Game
        ;--------------------------ENTER--------------------------------
        CALL EnterInput
        CMP isEnter, 1
        jz Game
        ;-------------------------CHARACTER------------------------------
        CALL CharInput
        ;--------------------Exit game if key is F3----------------------
    
        cmp al, 13h
        jz MainScreen
        jmp Game



EndGame:
HLT
MAIN ENDP

PrintCommandString PROC
    ;-----set cursor---
    cmp Turn, 1
    jnz isTurn2
    MOV  DL, 0        ;column
    JMP isTurn1End
    isTurn2:
    MOV  DL, 20        ;column
    isTurn1End:
    MOV  DH, 15      ;row
    MOV  BH, 0        ;page
    MOV  AH, 02H      ;set cursor 
    INT  10H
    ;----print----
    mov ah, 9h
    mov dx, offset commandS
    int 21h        
    RET
PrintCommandString ENDP

ClearCommandString PROC
    MOV SI, OFFSET EmptyString
    MOV DI, OFFSET commandS
    MOV CX, 22
    REP MOVSB
    MOV DI, OFFSET commandS
    MOV Cursor, DI
    MOV cmdCurrSize, 0
    ;-----------------DRAW BACKGROUND RECTANGLE AGAIN TO OVERRIDE CURRENT DISPLAYED STRING----
    horizontalline 170,0,320            ;horizontal line
    drawrectangle  120,0,0dh,10,120     ;draw the background of the command after deleting to override the old command
    drawrectangle  120,161,0Eh,10,120
    RET
ClearCommandString ENDP

;description
SwitchTurn PROC
    cmp Turn, 1
    jnz SwitchTo1
    MOV  Turn, 2
    JMP SwitchTo2End
    SwitchTo1:
    MOV  Turn, 1        ;column
    SwitchTo2End:
    RET
SwitchTurn ENDP


;description
ResetInputFlags PROC
    MOV isGun, 0
    MOV isBackSpace, 0
    MOV isEnter, 0
    MOV isChar, 0
    MOV isPowerUp, 0
    RET
ResetInputFlags ENDP

;description
GunInput PROC
     ;right arrow
    right:
        cmp ah, 4Dh ;compare key code with right key code
        jnz left    ;if the key is not right, jump to next check
        CMP gun1NewX, 141
        JNC GunInputDone
        add gun1NewX, 3  ;if the key is right, move the gun 3 pixels to the right
        jmp GunInputDone
    ;left arrow    
    left:
        cmp ah, 4Bh
        jnz up
        CMP gun1NewX, 4
        JC GunInputDone
        sub gun1NewX, 3
        jmp GunInputDone
    ;up arrow
    up:
        cmp ah, 48h
        jnz down
        CMP gun1NewY, 4
        JC GunInputDone
        sub gun1NewY, 3
        jmp GunInputDone
    ;down arrow
    down:
        cmp ah, 50h
        jnz space
        CMP gun1NewY, 160
        JNC GunInputDone
        add gun1NewY, 3
        jmp GunInputDone

    space:
        cmp ah, 39h
        jnz NotGunInput
        CALL FireGun_initial

    GunInputDone:
    MOV isGun, 1
    CALL DrawGun 
    NotGunInput:
    RET
GunInput ENDP
;description
BackspaceInput PROC
    cmp ah, 0Eh
    jnz NotBackspaceInput
    cmp cmdCurrSize, 0 ;if the string is empty, do nothing and continue the main loop
    jz BackspaceInputDone
    mov di, cursor ;get cursor
    dec di
    mov [di], '$$' ;to delete a character, put $. we add 2 $ because it's a word
    dec cmdCurrSize ;decrement cursor
    mov cursor, di
    horizontalline 170,0,320            ;horizontal line
    drawrectangle  120,0,0dh,10,120     ;draw the background of the command after deleting to override the old command

    ; horizontalline 145,162,319          ;horizontal line
    drawrectangle  120,161,0Eh,10,120
    BackspaceInputDone:
    MOV isBackSpace, 1
    NotBackspaceInput:
    RET
BackspaceInput ENDP
;description
EnterInput PROC
    cmp al, 13d
    jnz NotEnterInput
    CMP cmdCurrSize, 0
    JZ EnterInputDone
    CALL execute
    ;------------------------Print, peter-----------------------------
    MOV AL,Source ;PUT THE REAMINDER IN THE AL TO DIVIDE IT AGAIN
    MOV AH,0  ;MAKE AH=0 TO HAVE THE RIGHT NUMBER IN AX
    MOV BL,10h ;THE DIVISION THIS TIME IS OVER 10
    DIV BL
    
    MOV DL,AL ;TO DISPLAY THE TENS 
    MOV CH,AH ;TO SAVE THE REMAINDER THE UNITS
    
    ADD DL,30H
    MOV AH,02
    INT 21H  
    
    MOV DL,CH ;NO DIVISION
    ADD DL,30H
    MOV AH,02H
    INT 21H
    ;------------------------Print, peter-----------------------------
    CALL ClearCommandString
    CALL SwitchTurn

    EnterInputDone:
    MOV isEnter, 1
    NotEnterInput:
    RET
EnterInput ENDP
;description
CharInput PROC
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
    mov dl, cmdCurrSize
    cmp dl, cmdMaxSize
    jz endInsertChar
    mov di, cursor 
    mov [di], al
    inc cmdCurrSize
    inc di
    mov cursor, di
    endInsertChar:
    RET
CharInput ENDP
;description
PowerUpInput PROC
    keyF5:
        cmp ah, 3Fh ;compare key code with f5 code
        jnz keyF6    ;if the key is not F5, jump to next check
        ;call powerup
        jmp PowerUpInputDone
    keyF6:
        cmp ah, 40h ;compare key code with f6 code
        jnz keyF7    ;if the key is not F6, jump to next check
        ;call powerup
        jmp PowerUpInputDone
    keyF7:
        cmp ah, 41h ;compare key code with f7 code
        jnz keyF8    
        ;call powerup
        jmp PowerUpInputDone
    keyF8:
        cmp ah, 42h ;compare key code with f8 code
        jnz keyF9  
        ;call powerup  
        jmp PowerUpInputDone
    keyF9:
        cmp ah, 43h ;compare key code with f9 code
        jnz keyF10  
        ;call powerup  
        jmp PowerUpInputDone
    keyF10:
        cmp ah, 44h ;compare key code with f10 code
        jnz NotPowerUpInput 
        ;call powerup
    PowerUpInputDone:
    MOV isPowerUp, 1
    NotPowerUpInput:
    RET
PowerUpInput ENDP

DisplayNumInAL PROC 

    MOV AH,0  ;MAKE AH=0 TO HAVE THE RIGHT NUMBER IN AX
    MOV BL,10 ;THE DIVISION THIS TIME IS OVER 10
    DIV BL
    
    MOV DL,AL ;TO DISPLAY THE TENS 
    MOV CH,AH ;TO SAVE THE REMAINDER THE UNITS
    
    ADD DL,30H
    MOV AH,02
    INT 21H  
    
    MOV DL,CH ;NO DIVISION
    ADD DL,30H
    MOV AH,02H
    INT 21H
    ret
DisplayNumInAL ENDP 
DisplayNamesAndScore PROC
        mov si,offset BufferData1
        MOV AL,[si]
        sub al,30H
        MOV AH,0  ;MAKE AH=0 TO HAVE THE RIGHT NUMBER IN AX
        MOV BL,10 ;THE DIVISION THIS TIME IS OVER 10
        MUL BL
                        
        MOV DL,AL ;TO save the frist digit      
        mov al,[si+1] ;second digit   
        sub al,30H   
        add dl,al
        mov P1_score,dl ;first initial score
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov si,offset BufferData2
        MOV AL,[si]
        sub al,30H
        MOV AH,0  ;MAKE AH=0 TO HAVE THE RIGHT NUMBER IN AX
        MOV BL,10 ;THE DIVISION THIS TIME IS OVER 10
        MUL BL           
        MOV DL,AL ;TO save the frist digit

        mov al,[si+1] ;second digit   
        sub al,30H   
        add dl,al
        mov P2_score,dl
        ;I need to know the smallest of the 2 numbers the convet it to string and print it next to each name 
        ;Finding The min of the 2 initials
        mov al,P1_score
        mov bl,P2_score
        
        cmp al,bl  
        jl closeM1
        jg closeM2     
        jmp closeM    

        closeM1: 
        mov P2_score,al
        jmp closeM
        
        closeM2: 
        mov P1_score,bl 
        closeM:
        
        ;Dispkay the names and the min initial points
        ;set the crsr
        mov dl,5
        mov dh,20
        mov ah,2
        int 10h
        ;print the first name
        mov ah,09 
        mov dx,offset BUFFNAME1
        int 21h 
        ;print the score of the first player
        MOV AL,P1_score
        CALL DisplayNumInAL
        ;set the crsr
        mov dl,70 
        mov dh,20
        mov ah,2
        int 10h
        ;print the second name
        mov ah,09
        mov dx,offset BUFFNAME2 
        int 21h
        ;print the score of the second player
        MOV AL,P2_score
        CALL DisplayNumInAL
    RET
DisplayNamesAndScore ENDP  
DISPLAYLEVEL PROC
    
DISPLAYLEVEL ENDP
END MAIN