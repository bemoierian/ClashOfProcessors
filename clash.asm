;-------------------------start.asm---------------------------
EXTRN startScreen1:far 
EXTRN BUFFNAME1:BYTE, BufferData1:BYTE
EXTRN BUFFNAME2:BYTE, BufferData2:BYTE
PUBLIC Player
;-------------------------RM.asm---------------------------
EXTRN RegMemo:far
PUBLIC m0_1,m1_1,m2_1,m3_1,m4_1,m5_1,m6_1 ,m7_1,m8_1,m9_1,mA_1,mB_1 ,mC_1,mD_1,mE_1,mF_1 
PUBLIC m0_2,m1_2,m2_2,m3_2,m4_2,m5_2,m6_2 ,m7_2,m8_2,m9_2,mA_2,mB_2 ,mC_2,mD_2,mE_2,mF_2 
PUBLIC AxVar1,BxVar1,CxVar1,DxVar1,SiVar1,DiVar1,SpVar1 ,BpVar1
PUBLIC AxVar2,BxVar2,CxVar2,DxVar2,SiVar2,DiVar2,SpVar2 ,BpVar2
PUBLIC Carry_1,Carry_2
;-------------------------chat.asm---------------------------
;EXTRN Chat:far 
EXTRN StartChat:far 
EXTRN line:BYTE,endchat:BYTE,pre:BYTE,thechatended:BYTE
EXTRN yps:BYTE,xps:BYTE,ypr:BYTE,xpr:BYTE
PUBLIC Player
PUBLIC sendVarL
PUBLIC ReceiveVarL
;-------------------------cmd_p1.asm---------------------------
EXTRN execute1:far 
EXTRN CLEAR_TO_EXECUTE_1:BYTE
;-------------------------cmd_p2.asm---------------------------
EXTRN execute2:far
EXTRN CLEAR_TO_EXECUTE_2:BYTE
PUBLIC commandStr,commandCode,isExternal,Instruction,Destination,Source,External
PUBLIC commandS
;-------------------------Gun.asm---------------------------
EXTRN DrawGun1:far
EXTRN FireGun1_initial:far
EXTRN FireGun1_Continue:far
EXTRN DrawGun2:far
EXTRN FireGun2_initial:far
EXTRN FireGun2_Continue:far
EXTRN FlyObj1_Continue:far
EXTRN FlyObj2_Continue:far
EXTRN FlyObj_initial:far
EXTRN gun1NewX:WORD,gun1NewY:WORD,gun2NewX:WORD,gun2NewY:WORD
EXTRN l11:BYTE,c11:BYTE,l12:BYTE,c12:BYTE,l13:BYTE,c13:BYTE,l14:BYTE,c14:BYTE,l15:BYTE,c15:BYTE,l21:BYTE,c21:BYTE,l22:BYTE,c22:BYTE,l23:BYTE,c23:BYTE,l24:BYTE,c24:BYTE,l25:BYTE,c25:BYTE
;-------------------powerups.asm----------------------------
EXTRN forbiddin_char1:BYTE,forbiddin_char2:BYTE
EXTRN power_up1_player1:FAR
EXTRN power_up1_player2:FAR
EXTRN power_up2_player1:FAR
EXTRN power_up2_player2:FAR
EXTRN power_up3_player1:FAR
EXTRN power_up3_player2:FAR
EXTRN power_up4_player1:FAR
EXTRN power_up4_player2:FAR
EXTRN power_up5_player1:FAR
EXTRN power_up5_player2:FAR
EXTRN power_up6_player1:FAR
EXTRN power_up6_player2:FAR
PUBLIC P1_score,P2_score,target
PUBLIC ClearCommandString,SwitchTurn
;-------------------------LEVEL.ASM--------------------------
EXTRN forbiddin_char1:BYTE,forbiddin_char2:BYTE,chosen_level:BYTE
EXTRN select_level:FAR
EXTRN show_level:FAR
EXTRN select_forbidden_char1:FAR
EXTRN select_forbidden_char2:FAR
EXTRN show_forb_chars:FAR
EXTRN initial_reg1:far
EXTRN initial_reg2:far
EXTRN MainScreenFunctions:far
EXTRN GostartGame:BYTE, GoStartMshBgad:BYTE, GoToChat:BYTE, isfirst:BYTE, player2name:BYTE, player1name:BYTE

PUBLIC StaticScreen
;-------------------------UI.inc------------------------------
include UI.inc

;cleartop
cleartop MACRO
   
mov ax,0600h
mov bh,07h
mov ch,1   
mov cl,0     
mov dh,11   
mov dl,79
int 10h 
  
ENDM cleartop 

;clearbottom
clearbottom MACRO
   
mov ax,0600h
mov bh,07h
mov ch,14  
mov cl,0      
mov dh,22
mov dl,79
int 10h 
  
ENDM clearbottom
;------------------win.asm----------
EXTRN printwin1:BYTE,printwin2:BYTE,winner:BYTE,programend:BYTE
EXTRN CheckWinner:far

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
AxVar1 dw 0
BxVar1 dw 0
CxVar1 dw 0
DxVar1 dw 0

SiVar1 dw 0
DiVar1 dw 0
SpVar1 dw 10h
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
SpVar2 dw 10h 
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
isGun1 db 0
isGun2 db 0
isBackSpace db 0
isEnter db 0
isChar db 0
isPowerUp db 0
;----------------------------------------------------------
target dw 105eH ;target values

;------------------------------------
cyclesCounter1 dw 0
cyclesCounter2 DW 0
;-----------------Serial Port vars---------------
sendVarL db ?
sendVarH db ?
ReceiveVarL db ?
ReceiveVarH db ?

InputVarL db ?
InputVarH db ?

valueR db ?
isReceived db 0
valueS db ?
isSent db 0
;Holds the number of the player (1 is the one who sent the invitation 1st)
Player db 2
;Holds the mode of the game: 0. Command, 1. chat
ModePlayer1 db 0
ModePlayer2 db 0
;Is in game chat
IsChating_p1 db 0
IsChating_p2 db 0
chatxposP1 db 0
chatxposP2 db 0
;------------------------------------------------
.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX

    ;---------------Config-----------------
    mov dx,3fbh 			; Line Control Register
    mov al,10000000b		;Set Divisor Latch Access Bit
    out dx,al			;Out it
    ;Set LSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f8h			
    mov al,0ch			
    out dx,al
    ;Set MSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f9h
    mov al,00h
    out dx,al
    ;Set port configuration
    mov dx,3fbh
    mov al,00011011b
    out dx,al

    UserNames:
        call startScreen1  ;start.asm 
        ; call startScreen2
        CALL SetInitialPoints
        CALL SetMinPoints
    EndUserNames:

    mov ah,0          ;Change video mode (Text MODE)
    mov al,03h
    int 10h 
    ;CLEAR SCREEN
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
      MainScreen:
        draw_mainscreen main_str1, main_str2, main_str3 ;UI.inc
        MainInput:
        CALL MainScreenFunctions
        CMP isfirst, 1
        JNZ CHCKFLAGS
        MOV Player, 1
        CHCKFLAGS:
        CMP GoToChat, 1
        jz chat
        CMP GostartGame, 1
        jz startGame
        CMP GoStartMshBgad, 1
        jz startMshBgad

    chat:
     CALL StartChat
     JMP MainScreen
   startGame:
    ;Clear Screen
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
    ;CHOOSE LEVEL
    CALL select_level
    
    mov dx , 3FDH		; Line Status Register
    AGAIN:
        In al , dx 			;Read Line Status
  		AND al , 00100000b
  		JZ AGAIN

    ;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov  al,chosen_level
  		out dx , al 

    startMshBgad:
    CALL show_level
    cmp chosen_level,2
    jnz level1
    call initial_reg1
    call initial_reg2
    level1:
    CALL select_forbidden_char1
    ;CALL select_forbidden_char2
    CALL show_forb_chars

    mov ah,0   ;enter graphics mode
    mov al,13h
    int 10h
   
    Background                          ;background color
    horizontalline 170,0,320            ;horizontal line
    drawrectangle  125,0,0dh,13,120
    
    verticalline 0,160,170              ;vertical line
     ;horizontalline 145,162,319          ;horizontal line
    drawrectangle  125,161,0Eh,13,120
    

    CALL ClearCommandString ;as initialization
    ;START THE GAME
    mov di, offset commandS 
    mov cursor, di
    Game:
        ;---------------Win.asm--------------------
        pusha
        call CheckWinner ;if the target value in any reg
        popa
        inc cyclesCounter1 ;count cycles for flying objects (appearance)
        inc cyclesCounter2 ;count cycles for delaying the movement flying object (speed)
        CALL ResetInputFlags ;reset falgs for each input 
        CALL PrintCommandString 
        ;display name
        CALL DisplayNamesAndScore ;display name , score and forbidden char in level 1
        ;----------------------gun.asm----------------------------- 

        CALL FireGun1_Continue ;step for the bulet
        CALL FireGun2_Continue 

        cmp cyclesCounter1, 100H ;compare with 100H
        jnz dontInitiateFly     
        CALL FlyObj_initial
        mov cyclesCounter1, 0
        dontInitiateFly:

        cmp cyclesCounter2, 2H
        jnz dontDrawFly
        CALL FlyObj1_Continue
        CALL FlyObj2_Continue
        mov cyclesCounter2, 0
        dontDrawFly:
        ;----------------------rm.asm-----------------------------
        call RegMemo
        ;----------------------UI.inc-----------------------------score for colors
        CALL DrawUI
        ;Read Keyboard input
        mov ah, 1
        int 16h
        jz NotSending   ;if no key is pressed, go to other functions like flying objects, etc. -----------to be changed--------------
        mov ah, 0
        int 16h
        ;AL contains ascii of key pressed
        ;-------------------------------------------------INPORTANT NOTE-------------------------------------------------------
        ;DON'T CALL ANY FUNCTION HERE THAT CHANGES THE VALUE OF AX,
        ;IF YOU WANT TO USE AX, PUSH IT IN REG THEN POP WHEN YOU FINISH TO RESTORE ITS VALUE 
        ;----------------------------SEND--------------------------------
        call HashFunction
        mov sendVarL, al
        mov sendVarH, ah
        MOV valueS, AL
        CALL SendInput
        CMP isSent, 1
        jnz NotSending
        jmp ContinueReceive

        NotSending:
        mov sendVarL, 2Fh
        mov sendVarH, 35h
        ContinueReceive:
        ;----------------------------Receive------------------------------
        CALL ReceiveInput
        CMP isReceived, 1
        jnz notReceived
        mov dl, valueR
        mov ReceiveVarL, dl
        jmp ReceivedSuccess
        notReceived:
        ;-------------------If we received nothing or an error occured, set received vars with '/' which is our flag for error--
        ;--------------------Error is handled in backspaceInput proc---------------------------------------------------
        mov ReceiveVarL, 2Fh
        mov ReceiveVarH, 35h
        ReceivedSuccess:
        ;--------------------------IN-GAME-CHAT-------------------------
        cmp player,1
        jnz chat_player2
            ;sending player 1
            cmp sendVarL,0f9h
            jnz print_if_player1_sending
                cmp IsChating_p1 , 0
                jnz reset_chating_player1_S
                    mov IsChating_p1,1
                    jmp receiving_for_P1
                reset_chating_player1_S:
                    mov IsChating_p1,0
                    jmp receiving_for_P1

                print_if_player1_sending:
                cmp IsChating_p1,1
                jnz receiving_for_P1
                    ;here to print sent chat at player 1
                    cmp sendVarL,'/'
                    jz receiving_for_P1
                    mov ah,2
                    mov bh,0
                    mov dl,chatxposP1
                    mov dh,22
                    int 10h
                    mov ah,2
                    mov dl,sendVarL
                    int 21h
                    add chatxposP1,1
                    jmp game
            ;receiving player 1
            receiving_for_P1:
            cmp ReceiveVarL,0f9h
            jnz print_if_player1_receiving
                cmp IsChating_p2 , 0
                jnz reset_chating_player1_R
                    mov IsChating_p2,1
                    jmp game
                reset_chating_player1_R:
                    mov IsChating_p2,0
                    jmp game

                print_if_player1_receiving:
                cmp IsChating_p2,1
                jnz check_Gun
                    ;here to print rec chat at player 1
                    cmp ReceiveVarL,'/'
                    jz game
                    mov ah,2
                    mov bh,0
                    mov dl,chatxposP2
                    mov dh,23
                    int 10h
                    mov ah,2
                    mov dl,ReceiveVarL
                    int 21h
                    inc chatxposP2
                    jmp game
        ;PLAYER2----------------------------------------
        chat_player2:
            ;sending player 2
            cmp sendVarL,0f9h
            jnz print_if_player2_sending
                cmp IsChating_p2 , 0
                jnz reset_chating_player2_S
                    mov IsChating_p2,1
                    jmp receiving_for_P2
                reset_chating_player2_S:
                    mov IsChating_p2,0
                    jmp receiving_for_P2

                print_if_player2_sending:
                cmp IsChating_p2,1
                jnz receiving_for_P2
                ;here to print sent chat at player 2
                    cmp sendVarL,'/'
                    jz receiving_for_P2
                    mov ah,2
                    mov bh,0
                    mov dl,chatxposP2
                    mov dh,23
                    int 10h
                    mov ah,2
                    mov dl,sendVarL
                    int 21h
                    inc chatxposP2
                    jmp game
            ;receiving player 2
            receiving_for_P2:
            cmp ReceiveVarL,0f9h
            jnz print_if_player2_receiving
                cmp IsChating_p1 , 0
                jnz reset_chating_player2_R
                    mov IsChating_p1,1
                    jmp game
                reset_chating_player2_R:
                    mov IsChating_p1,0
                    jmp game

                print_if_player2_receiving:
                cmp IsChating_p1,1
                jnz check_Gun
                    ;here to print rec chat at player 2
                    cmp ReceiveVarL,'/'
                    jz game
                    mov ah,2
                    mov bh,0
                    mov dl,chatxposP1
                    mov dh,22
                    int 10h
                    mov ah,2
                    mov dl,ReceiveVarL
                    int 21h
                    add chatxposP1,1
                    jmp game
        ;----------------------------GUN--------------------------------
        check_Gun:
        ;mov IsInGameChat,0

        CALL TotalGunInput
        CMP isGun1, 1
        JZ Game
        CMP isGun2, 1
        JZ Game
        ;---------------------Serial port checks------------------------
        CALL SetParametersOfCommand
        ;------------------------BACKSPACE------------------------------
        CALL BackspaceInput
        CMP isBackSpace, 1
        jz Game
        ;--------------------------ENTER--------------------------------
        CALL EnterInput
        CMP isEnter, 1
        jz Game
        ;--------------------------powerups--------------------------------
        call PowerUpInput
        cmp isPowerUp, 1
        jz Game
        ;-------------------------CHARACTER------------------------------
        CALL CharInput
        ;--------------------Exit game if key is F4----------------------
        cmp ah, 3Eh
        jz MainScreen
        jmp Game


EndGame:
    mov ax,0600h
  mov bh,07
  mov cx,0
  mov dx,184FH
  int 10h

     mov ah,09
    mov dx,offset programend
    int 21h

HLT
MAIN ENDP

PrintCommandString PROC FAR
    ;-----set cursor---
    cmp Turn, 1
    jnz isTurn2
    MOV  DL, 0        ;column
    JMP isTurn1End
    isTurn2:
    MOV  DL, 20        ;column
    isTurn1End:
    MOV  DH, 16      ;row
    MOV  BH, 0        ;page
    MOV  AH, 02H      ;set cursor 
    INT  10H
    ;----print----
    mov ah, 9h
    mov dx, offset commandS
    int 21h        
    RET
PrintCommandString ENDP

ClearCommandString PROC FAR
    MOV SI, OFFSET EmptyString
    MOV DI, OFFSET commandS
    MOV CX, 22
    REP MOVSB
    MOV DI, OFFSET commandS
    MOV Cursor, DI
    MOV cmdCurrSize, 0
    ;-----------------DRAW BACKGROUND RECTANGLE AGAIN TO OVERRIDE CURRENT DISPLAYED STRING----
    horizontalline 170,0,320            ;horizontal line
    drawrectangle  125,0,0dh,13,120     ;draw the background of the command after deleting to override the old command
    drawrectangle  125,161,0Eh,13,120
    RET
ClearCommandString ENDP

;description
SwitchTurn PROC FAR
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
ResetInputFlags PROC FAR
    MOV isGun1, 0
    MOV isGun2, 0
    MOV isBackSpace, 0
    MOV isEnter, 0
    MOV isChar, 0
    MOV isPowerUp, 0
    MOV isReceived, 0
    MOV isSent, 0
    RET
ResetInputFlags ENDP

;description
Gun1Input PROC FAR
     ;right arrow
    right1:
        cmp al,1 ;compare key code with right key code
        jnz left1    ;if the key is not right, jump to next check
        CMP gun1NewX, 141
        JNC Gun1InputDone
        add gun1NewX, 3  ;if the key is right, move the gun 3 pixels to the right
        jmp Gun1InputDone
    ;left arrow    
    left1:
        cmp al,2
        jnz up1
        CMP gun1NewX, 4
        JC Gun1InputDone
        sub gun1NewX, 3
        jmp Gun1InputDone
    ;up arrow
    up1:
        cmp al,3
        jnz down1
        CMP gun1NewY, 4
        JC Gun1InputDone
        sub gun1NewY, 3
        jmp Gun1InputDone
    ;down arrow
    down1:
        cmp al,4
        jnz fire1
        CMP gun1NewY, 115
        JNC Gun1InputDone
        add gun1NewY, 3
        jmp Gun1InputDone
    ;space
    fire1: 
        cmp al, 20h
        jnz NotGun1Input
        CALL FireGun1_initial

    Gun1InputDone:
    MOV isGun1, 1
    CALL DrawGun1 
    NotGun1Input:
    RET
Gun1Input ENDP
Gun2Input PROC FAR
    ;right arrow
    right2:
        cmp al,1 ;compare key code with right key code
        jnz left2    ;if the key is not right, jump to next check
        CMP gun2NewX, 311
        JNC Gun2InputDone
        add gun2NewX, 3  ;if the key is right, move the gun 3 pixels to the right
        jmp Gun2InputDone
    ;left arrow    
    left2:
        cmp al,2
        jnz up2
        CMP gun2NewX, 164
        JC Gun2InputDone
        sub gun2NewX, 3
        jmp Gun2InputDone
    ;up arrow
    up2:
        cmp al,3
        jnz down2
        CMP gun2NewY, 4
        JC Gun2InputDone
        sub gun2NewY, 3
        jmp Gun2InputDone
    ;down arrow
    down2:
        cmp al,4
        jnz fire2
        CMP gun2NewY, 115
        JNC Gun2InputDone
        add gun2NewY, 3
        jmp Gun2InputDone

    fire2:
        cmp al,20h
        jnz NotGun2Input
        CALL FireGun2_initial

    Gun2InputDone:
    MOV isGun2, 1
    CALL DrawGun2
    NotGun2Input:
    RET
Gun2Input ENDP
;description
BackspaceInput PROC FAR
    mov al, InputVarL
    cmp al, 2Fh
    jz BackspaceInputDone
    cmp al, 08h
    jnz NotBackspaceInput
    cmp cmdCurrSize, 0 ;if the string is empty, do nothing and continue the main loop
    jz BackspaceInputDone
    mov di, cursor ;get cursor
    dec di
    mov [di], '$$' ;to delete a character, put $. we add 2 $ because it's a word
    dec cmdCurrSize ;decrement cursor
    mov cursor, di
    horizontalline 170,0,320            ;horizontal line
    drawrectangle  125,0,0dh,13,120     ;draw the background of the command after deleting to override the old command

    ; horizontalline 145,162,319          ;horizontal line
    drawrectangle  125,161,0Eh,13,120
    BackspaceInputDone:
    MOV isBackSpace, 1
    NotBackspaceInput:
    RET
BackspaceInput ENDP
;description
EnterInput PROC FAR
    mov al, InputVarL
    cmp al, 13d
    jnz NotEnterInput
    CMP cmdCurrSize, 0
    JZ EnterInputDone
    cmp turn,2
    jnz turn_1
    CALL execute2
    CMP CLEAR_TO_EXECUTE_2, 0
    JNZ finish_execute
    DEC P2_score
    jmp finish_execute
    turn_1:
    CALL execute1
    CMP CLEAR_TO_EXECUTE_1, 0
    JNZ finish_execute
    DEC P1_score
    
    finish_execute:
    CALL ClearCommandString
    CALL SwitchTurn

    EnterInputDone:
    MOV isEnter, 1
    NotEnterInput:
    RET
EnterInput ENDP
;description
CharInput PROC FAR
    mov dl, cmdCurrSize
    cmp dl, cmdMaxSize
    jz endInsertChar
    ;-------------Check if plahyer entered a forbidden character----------
    ; cmp Mode, 0
    ; jnz continueIns

    ;receivedVar
    mov al, InputVarL
    CMP Turn,1
    JNZ CHCKFORB2
    CMP AL, forbiddin_char2
    JZ endInsertChar
    jmp continueIns
    CHCKFORB2:
    CMP AL, forbiddin_char1
    JZ endInsertChar
    continueIns:
    ;------------------------------Insert--------------------------
    ;-----------------------Convert to lower case------------------
    ToLower:
    cmp al, 41h               ;41h is the lower bound ascii for capital letters
    jl  AddToResult
    cmp al, 5Ah               ;5Ah is the upper bound ascii for capital letters
    jg AddToResult
    add al, 20h               ;add 20h to make the char lower case
    AddToResult:

    mov di, cursor 
    mov [di], al
    inc cmdCurrSize
    inc di
    mov cursor, di
    endInsertChar:
    RET
CharInput ENDP
;description
PowerUpInput PROC FAR
    keyF5:
        cmp al, 0fah ;compare key code with f5 code
        jnz keyF6    ;if the key is not F5, jump to next check
        ;call powerup
        cmp Turn,1
        jnz P21
        CALL power_up1_player1
        jmp PowerUpInputDone
        P21:
        CALL power_up1_player2
        jmp PowerUpInputDone
    keyF6:
        cmp al, 0fbh ;compare key code with f6 code
        jnz keyF7    ;if the key is not F6, jump to next check
        ;call powerup
        cmp Turn,1
        jnz P22
        CALL power_up2_player1
        jmp PowerUpInputDone
        P22:
        CALL power_up2_player2
        jmp PowerUpInputDone
    keyF7:
        cmp al, 0fch ;compare key code with f7 code
        jnz keyF8    
        ;call powerup
        cmp Turn,1
        jnz P23
        CALL power_up3_player1
        jmp PowerUpInputDone
        P23:
        CALL power_up3_player2
        jmp PowerUpInputDone
    keyF8:
        cmp al, 0fdh ;compare key code with f8 code
        jnz keyF9  
        ;call powerup  
        cmp Turn,1
        jnz P24
        CALL power_up4_player1
        jmp PowerUpInputDone
        P24:
        CALL power_up4_player2
        jmp PowerUpInputDone
    keyF9:
        cmp al, 0feh ;compare key code with f9 code
        jnz keyF10  
        ;call powerup
        cmp Turn,1
        jnz P25  
        CALL power_up5_player1
        jmp PowerUpInputDone
        P25:
        CALL power_up5_player2
        jmp PowerUpInputDone
    keyF10:
        CMP chosen_level,2
        JNZ NotPowerUpInput ;if not level 2 no power up 6
        cmp al, 0ffh ;compare key code with f10 code
        jnz NotPowerUpInput  
        cmp Turn,1
        jnz P26
        CALL power_up6_player1
        jmp PowerUpInputDone
        P26:
        CALL power_up6_player2
        ;jmp PowerUpInputDone
    PowerUpInputDone:
    MOV isPowerUp, 1
    NotPowerUpInput:
    RET
PowerUpInput ENDP

DisplayNumInAL PROC FAR

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

DisplayNamesAndScore PROC FAR
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

        mov ah,02 
        mov dl, ':'
        int 21h 
        ;print the score of the first player
        MOV AL,P1_score
        CALL DisplayNumInAL
        ;FORBIDDEN CHAR
        CMP chosen_level,2
        JZ NOPRINT1
        ;PRINT THE FORBIDDEN CHAR 1
        MOV DL,20h ;PRINT SPACE
        MOV AH,2
        INT 21H
        MOV DL,forbiddin_char1
        INT 21H
        NOPRINT1:
        ;set the crsr
        mov dl,25 
        mov dh,20
        mov ah,2
        int 10h
        ;print the second name
        mov ah,09
        mov dx,offset BUFFNAME2 
        int 21h
        mov ah,02 
        mov dl, ':'
        int 21h 
        ;print the score of the second player
        MOV AL,P2_score
        CALL DisplayNumInAL
        ;FORBIDDEN CHAR 2
        CMP chosen_level,2
        JZ NOPRINT2
        ;PRINT THE FORBIDDEN CHAR
        MOV DL,20h ;PRINT SPACE
        MOV AH,2
        INT 21H
        MOV DL,forbiddin_char2
        INT 21H
        NOPRINT2:
    RET
DisplayNamesAndScore ENDP  

SetMinPoints PROC FAR;get min of 2 variables
    mov al,P1_score
    mov bl,P2_score
    
    cmp al,bl  
    jl closeM1 ;al<bl
    jg closeM2     
    jmp closeM    

    closeM1: 
    mov P2_score,al ;second score with min
    jmp closeM
    
    closeM2: 
    mov P1_score,bl ;
    closeM:
    RET
SetMinPoints ENDP

SetInitialPoints PROC FAR;but the initial points in the score variables
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
    RET
SetInitialPoints ENDP

ReceiveInput PROC FAR
    mov dx , 3FDH		; Line Status Register
    in al , dx 
    AND al , 1
    JZ EndReceiveInput ;lo mafi4 7aga tst2blha jump to end

    ;If Ready read the VALUE in Receive data registerd
        mov dx , 03F8H
        in al , dx 
        mov valueR , al ;;to the recieved char in valueR
        mov isReceived, 1
    EndReceiveInput:
    RET
ReceiveInput ENDP

;description
SendInput PROC FAR
     mov dx , 3FDH ;line status
    ;wait till THR is empty to send
        In al , dx 			;Read Line Status
        AND al , 00100000b
        JZ EndSendInput
    ;If empty put the VALUE in Transmit data register
    mov dx , 3F8H		; Transmit data register
    mov  al,valueS
    out dx , al
    mov isSent, 1
    EndSendInput:
    RET
SendInput ENDP

HashFunction PROC FAR
	check_Right:
        cmp ax, 4D00h ; if right arrow
	jnz check_Left
	mov al,1
	jmp EndHash
    
	check_Left:
	cmp ax, 4B00h ; if left arrow
	jnz check_Up
	mov al,2
	jmp EndHash
	
	check_Up:
	cmp ax, 4800h ; if up arrow
	jnz check_Down
	mov al,3
	jmp EndHash
    
	check_Down:
	cmp ax, 5000h ; if down arrow
	jnz F2
	mov al,4
	jmp EndHash
	
    F2:
	cmp ah, 3CH ; if F2 ->for chat
	jnz F5
	mov al, 0f9h
	jmp EndHash

    F5:
	cmp ah, 3FH ; if F5
	jnz F6
	mov al,0fah
	jmp EndHash

    F6:
	cmp ah, 40H ; if F6
	jnz F7
	mov al,0fbh
	jmp EndHash

    F7:
	cmp ah, 41H ; if F7
	jnz F8
	mov al,0fch
	jmp EndHash

    F8:
	cmp ah, 42H ; if F8
	jnz F9
	mov al,0fdh
	jmp EndHash

    F9:
	cmp ah, 43H ; if F9
	jnz F10
	mov al,0feh
	jmp EndHash

    F10:
    cmp ax, 44H ; if F10
	jnz EndHash
	mov al,0ffh

	EndHash:
    ret
HashFunction ENDP

DrawUI PROC FAR
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
        RET
DrawUI ENDP

;description
TotalGunInput PROC FAR
    cmp player,1
    jnz gunforP2
        mov al,sendVarL
        CALL Gun1Input
        CMP isGun1, 1
        jz EndTotalGun

        mov al,ReceiveVarL
        CALL Gun2Input
        CMP isGun2, 1
        jz EndTotalGun

    gunforP2:
        mov al,ReceiveVarL
        CALL Gun1Input
        CMP isGun1, 1
        jz EndTotalGun

        mov al,sendVarL
        CALL Gun2Input
        CMP isGun2, 1
        jz EndTotalGun 
    EndTotalGun:
    RET
TotalGunInput ENDP

;description
SetParametersOfCommand PROC FAR
    cmp turn,1
    jnz turn2
        cmp player,1
        jnz OtherPlayer2
            mov dl, sendVarL
            mov InputVarL, dl
            mov dl, sendVarH
            mov InputVarH, dl
            jmp continueInput
        OtherPlayer2:
            mov dl, ReceiveVarL
            mov InputVarL, dl
            mov dl, ReceiveVarH
            mov InputVarH, dl
            jmp continueInput
    turn2:
        cmp player,2
        jnz OtherPlayer1
            mov dl, sendVarL
            mov InputVarL, dl
            mov dl, sendVarH
            mov InputVarH, dl
            jmp continueInput
            OtherPlayer1:
                mov dl, ReceiveVarL
                mov InputVarL, dl
                mov dl, ReceiveVarH
                mov InputVarH, dl
                jmp continueInput
    continueInput:    
    RET
SetParametersOfCommand ENDP
;description
StaticScreen PROC FAR
    mov ah,0   ;enter graphics mode
    mov al,13h
    int 10h
    Background                          ;background color
    horizontalline 170,0,320            ;horizontal line
    drawrectangle  125,0,0dh,13,120
    
    verticalline 0,160,170              ;vertical line
    ;horizontalline 145,162,319          ;horizontal line
    drawrectangle  125,161,0Eh,13,120
    ;----------------------rm.asm-----------------------------
    call RegMemo
    ;----------------------UI.inc-----------------------------score for colors
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
    
    ;----------------Wait for input---------
    mov dx , 3FDH		; Line Status Register
	CHK:	
        in al , dx 
  		AND al , 1
  		JZ CHK

 ;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx
        mov chosen_level, al
    mov ah,0          ;Change video mode (Text MODE)
    mov al,03h
    int 10h
    RET
StaticScreen ENDP
END MAIN