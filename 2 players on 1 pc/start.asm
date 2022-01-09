PUBLIC startScreen1
PUBLIC BUFFNAME1,BufferData1
PUBLIC startScreen2
PUBLIC BUFFNAME2,BufferData2

.MODEL SMALL
.DATA
BUFFNAME1 DB 16 DUP('$')
BUFFNAME2 DB 16 DUP('$')
ASK_NAME1 DB 'Please Enter The Name Of The First Player: ',10,13,'$' 
ASK_NAME2 DB 'Please Enter The Name Of The Second Player: ',10,13,'$'

backSpace db 8,32,8,'$' 
halfBackSpace db 32,8,'$' 

AskPoints db 10,13,'Please Enter Initial Points of 2 digits:',10,13,'$'
;TO READ THE POINTS
BufferData1 db 3 dup('$') 
BufferData2 db 3 dup('$')

PRESSENTER DB 10,13,'Press Enter Key To Continue',10,13,'$'
.CODE
startScreen1 PROC FAR
    MOV AX, @DATA
    MOV DS, AX
    mov ES,ax
   
   ;Clear screen
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
    ;set the cursor in the top left
    mov bh,0h 
    mov ah,2
    mov dh,0
    mov dl,0
    int 10h

    ;ask for name
    lea dx,ASK_NAME1
    mov ah,9
    int 21h
    
    LEA DI,BUFFNAME1

    ;take the name from user with validation
    mov cx,15 ;max length of the name
    
    
    loopname1:  
    mov ah,1 ;read one char from the user and put it in al
    int 21h
 
    MOV BL, AL ;bl = ascii code
    
    cmp bl,13 ;compare with enter if enter pressed jump to points
    jz points1
         
    CMP BL, 61H   ;check on a
    JGE DALPHABET_SMALL1
         
    CMP BL, 41H   ;check on A
    JGE DALPHABET1 
         
    CMP BL, 30H  ;COMPARE WITH 0
    JGE DDIGIT1 
         
    CMP BL, 30H ;if it's less than zero jump to special char
    JL DSPECIAL1
    
    here1:dec cx  
    jnz loopname1
   
    jmp POINTS ;JUMP TO points AFTER THIS LOOP 
    
    BKspace1:
    mov dx,offset halfbackSpace
    mov ah,9
    int 21h   
    inc cx   
    dec di
    jmp loopname1
    
    DSPECIAL1: 
    cmp bl,8 ;if the pressed key is a backspace return to the loop 
    jz BKspace1
    mov dl,07h
    mov ah,2
    int 21h
    mov dx,offset backSpace
    mov ah,9
    int 21h
    jmp LOOPNAME1
    
    DDIGIT1:  
    CMP BL, 39H    ;COMPARE WITH THE '9; WHICH IS THE LOWER BOUND OF DIGITS
    JG DSPECIAL1    ;if it's not number jump to special char
    mov dl,07h     ;bell    
    mov ah,2
    int 21h
    mov dx,offset backSpace;backspace
    mov ah,9
    int 21h
    JMP LOOPNAME1  ;jump to loop whithout decreasing the counter
    
    DALPHABET1:   ;capital letters
    CMP BL, 5AH  ;check on Z
    JG DSPECIAL1  ;if it's not jump to special char
    JMP DALPHABET_SMALL1
    
    DALPHABET_SMALL1: ;small letters
    CMP BL, 7AH 
    JG DSPECIAL1 
    STOSB ;TO PUT THE RIGHT CHAR WHICH IS IN AL IN THE STRIG POINTED BY DI
    JMP here1                                        
    
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    POINTS1:    
    cmp cx,15   ;to force the user to enter his name
    jz loopname1
    
    mov dx,offset AskPoints ;ask for points
    MOV AH,9
    INT 21H
    
    LEA DI,BufferData1
    
    mov cx,2 
    
    loopPoints1:
        
    mov ah,1 ;read one char from the user and put it in al
    int 21h
    
    MOV BL, AL    
    
    cmp bl,13 ;compare with enter if enter pressed jump to looppoints
    jz loopPoints1 ;to force the user to enter 2 digits
    
    CMP BL, 61H   ;check on a
    JGE DALPHABET_SMALL21 
         
    CMP BL, 41H   ;check on A
    JGE DALPHABET21 
         
    CMP BL, 30H  ;COMPARE WITH 0
    JGE DDIGIT21 
         
    CMP BL, 30H 
    JL DSPECIAL21     
    
    HERE21:   
    loop loopPoints1 
    
    JMP PROCEED1
    
    
    BKspace21:
    mov dx,offset halfbackSpace
    mov ah,9
    int 21h  
    inc cx   
    dec di 
    jmp loopPoints1
    
    DSPECIAL21: 
    cmp bl,8 ;if the pressed key is a backspace return to the loop 
    jz BKspace21
    mov dl,07h
    mov ah,2
    int 21h
    lea dx,backSpace
    mov ah,9
    int 21h
    jmp loopPoints1
    
    DDIGIT21:  
    CMP BL, 39H    ;COMPARE WITH THE '9; WHICH IS THE LOWER BOUND OF DIGITS
    JG DSPECIAL1    ;if it's not number jump to special char
    STOSB
    JMP HERE21  ;jump to loop whithout decreasing the counter
    
    DALPHABET21:   ;capital letters
    CMP BL, 5AH  ;check on Z
    JG DSPECIAL1  ;if it's not jump to special char  
    mov dl,07h     ;bell    
    mov ah,2
    int 21h
    lea dx,backSpace;backspace
    mov ah,9
    int 21h
    JMP loopPoints1 
    
    DALPHABET_SMALL21: ;small letters
    CMP BL, 7AH 
    JG DSPECIAL1 
    mov dl,07h     ;bell    
    mov ah,2
    int 21h
    lea dx,backSpace;backspace
    mov ah,9
    int 21h
    JMP loopPoints1 
    
    PROCEED1:;wait for enter
    lea dx,PRESSENTER
    mov ah,9
    int 21h
    
    WAITENTER1:
    MOV AH,0
    INT 16h  
    CMP AL,0DH   ;check on the pressed key
    JNZ WAITENTER1
    MOV AH,1;read enter
    INT 16h 
    ret
startScreen1  ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
startScreen2 PROC FAR
    MOV AX, @DATA
    MOV DS, AX
    mov ES,ax
   
   ;Clear screen
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
    ;set the cursor in the top left
    mov bh,0h 
    mov ah,2
    mov dh,0
    mov dl,0
    int 10h

    ;ask for name
    lea dx,ASK_NAME2
    mov ah,9
    int 21h
    
    LEA DI,BUFFNAME2

    ;take the name from user with validation
    mov cx,15 ;max length of the name
    
    
    loopname:  
    mov ah,1 ;read one char from the user and put it in al
    int 21h
 
    MOV BL, AL ;bl = ascii code
    
    cmp bl,13 ;compare with enter if enter pressed jump to points
    jz points
         
    CMP BL, 61H   ;check on a
    JGE DALPHABET_SMALL 
         
    CMP BL, 41H   ;check on A
    JGE DALPHABET 
         
    CMP BL, 30H  ;COMPARE WITH 0
    JGE DDIGIT 
         
    CMP BL, 30H ;if it's less than zero jump to special char
    JL DSPECIAL
    
    here:dec cx  
    jnz loopname
   
    jmp POINTS ;JUMP TO points AFTER THIS LOOP 
    
    BKspace:
    mov dx,offset halfbackSpace
    mov ah,9
    int 21h   
    inc cx   
    dec di
    jmp loopname
    
    DSPECIAL: 
    cmp bl,8 ;if the pressed key is a backspace return to the loop 
    jz BKspace
    mov dl,07h
    mov ah,2
    int 21h
    mov dx,offset backSpace
    mov ah,9
    int 21h
    jmp LOOPNAME
    
    DDIGIT:  
    CMP BL, 39H    ;COMPARE WITH THE '9; WHICH IS THE LOWER BOUND OF DIGITS
    JG DSPECIAL    ;if it's not number jump to special char
    mov dl,07h     ;bell    
    mov ah,2
    int 21h
    mov dx,offset backSpace;backspace
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
    
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    POINTS:    
    cmp cx,15   ;to force the user to enter his name
    jz loopname
    
    mov dx,offset AskPoints ;ask for points
    MOV AH,9
    INT 21H
    
    LEA DI,BufferData2
    
    mov cx,2 
    
    loopPoints:
        
    mov ah,1 ;read one char from the user and put it in al
    int 21h
    
    MOV BL, AL    
    
    cmp bl,13 ;compare with enter if enter pressed jump to looppoints
    jz loopPoints ;to force the user to enter 2 digits
    
    CMP BL, 61H   ;check on a
    JGE DALPHABET_SMALL2 
         
    CMP BL, 41H   ;check on A
    JGE DALPHABET2 
         
    CMP BL, 30H  ;COMPARE WITH 0
    JGE DDIGIT2 
         
    CMP BL, 30H 
    JL DSPECIAL2     
    
    HERE2:   
    loop loopPoints 
    
    JMP PROCEED
    
    
    BKspace2:
    mov dx,offset halfbackSpace
    mov ah,9
    int 21h  
    inc cx   
    dec di 
    jmp loopPoints
    
    DSPECIAL2: 
    cmp bl,8 ;if the pressed key is a backspace return to the loop 
    jz BKspace2
    mov dl,07h
    mov ah,2
    int 21h
    lea dx,backSpace
    mov ah,9
    int 21h
    jmp loopPoints
    
    DDIGIT2:  
    CMP BL, 39H    ;COMPARE WITH THE '9; WHICH IS THE LOWER BOUND OF DIGITS
    JG DSPECIAL    ;if it's not number jump to special char
    STOSB
    JMP HERE2  ;jump to loop whithout decreasing the counter
    
    DALPHABET2:   ;capital letters
    CMP BL, 5AH  ;check on Z
    JG DSPECIAL  ;if it's not jump to special char  
    mov dl,07h     ;bell    
    mov ah,2
    int 21h
    lea dx,backSpace;backspace
    mov ah,9
    int 21h
    JMP loopPoints 
    
    DALPHABET_SMALL2: ;small letters
    CMP BL, 7AH 
    JG DSPECIAL 
    mov dl,07h     ;bell    
    mov ah,2
    int 21h
    lea dx,backSpace;backspace
    mov ah,9
    int 21h
    JMP loopPoints 
    
PROCEED:;wait for enter
    lea dx,PRESSENTER
    mov ah,9
    int 21h
    
    WAITENTER:
    MOV AH,0
    INT 16h  
    CMP AL,0DH   ;check on the pressed key
    JNZ WAITENTER
    MOV AH,1;read enter
    INT 16h 
    ret
startScreen2  ENDP
END