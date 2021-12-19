
EXTRN execute:far 
PUBLIC commandStr,commandCode,isExternal,Instruction,Destination,Source

;EXTRN BUFFNAME:BYTE
;EXTRN BufferData:BYTE
;EXTRN startScreen:far 

include UI.inc
include gun_obj.inc

.286
.MODEL SMALL
.STACK 64
.DATA
;----------------------------------------------------------------------
BUFFNAME DB 15 DUP('$')

ASK_NAME DB 'Please Enter Your Name: ',10,13,'$' 

backSpace db 8,32,8,'$'  

initPoints db 10,13,'Initial Points:',10,13,'$'
;TO READ THE POINTS
BUFFPOINT LABEL BYTE
BufferSize db 3
ActualSize db ?
BufferData db 3 dup('$') 

;------------------Variables for registers drawing----------------------
Rectanglexpos dw 10
Rectangleypos dw 10
counterDrawRegisters db 4
xp dw 10
yp dw 20
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

    ;UserNames:
            ;call startScreen      
    ;EndUserNames:
    ;---------------------------------------------------------------------------------------------------------------
    mov ES,ax
    
    ;Clear screen
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h


    mov bh,0h 
    ;Move cursor
    mov ah,2
    mov dh,0
    mov dl,0
    int 10h


    ;ask for name
    lea dx,ASK_NAME
    mov ah,9
    int 21h
    
    LEA DI,BUFFNAME

    ;take the name from user with validation
    mov cx,15 ;max length of the name
    
    
    loopname:  
    
    mov ah,1 ;read one char from the user and put it in al
    int 21h

    MOV BL, AL 
    
    cmp bl,13
    jz points
         
    CMP BL, 61H   ;check on a
    JGE DALPHABET_SMALL 
         
    CMP BL, 41H   ;check on A
    JGE DALPHABET 
         
    CMP BL, 30H  ;COMPARE WITH 0
    JGE DDIGIT 
         
    CMP BL, 30H 
    JL DSPECIAL
    
    here:dec cx   
    jnz loopname
    
    jmp POINTS ;JUMP TO EXIT AFTER THIS LOOP
      
    DSPECIAL: 
    mov dl,07h
    mov ah,2
    int 21h
    lea dx,backSpace
    mov ah,9
    int 21h
    jmp LOOPNAME
    
    DDIGIT:  
    CMP BL, 39H    ;COMPARE WITH THE '9; WHICH IS THE LOWER BOUND OF DIGITS
    JG DSPECIAL    ;if it's not number jump to special char
    mov dl,07h     ;bell    
    mov ah,2
    int 21h
    lea dx,backSpace;backspace
    mov ah,9
    int 21h
    JMP LOOPNAME  ;jump to loop whithout decreasing the counter
    
    DALPHABET:   ;capital letters
    CMP BL, 5AH  ;check on Z
    JG DSPECIAL  ;if it's not jump to special char
    JMP DALPHABET_SMALL
    
    DALPHABET_SMALL: ;small letters
    CMP BL, 7AH 
    JG DSPECIAL 
    STOSB ;TO PUT THE RIGHT CHAR WHICH IS IN AL IN THE STRIG POINTED BY DI
    JMP here 
    
    POINTS:
    LEA DX,initPoints ;print message
    MOV AH,9
    INT 21H
    
    lea dx,BUFFPOINT ;take points from user
    mov ah,0AH
    int 21H
    exit:
    ;---------------------------------------------------------------------------------------------------------------
    MainScreen:

    EndMainScreen:
    mov ah,0   ;graphics mode
    mov al,13h
    int 10h
    ;Main Game Loop
    Game:
        Background ;background color

        horizontalline 170,0,320 ;horizontal line
        drawrectangle  120,0,0dh,10,120
        verticalline 0,160,170   ;vertical line
        horizontalline 145,162,319 ;horizontal line
        drawrectangle  120,161,0Eh,10,120

        DrawGun
        DrawRegisters
        
        ; draw squares

        
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