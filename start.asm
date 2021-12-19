PUBLIC startScreen
PUBLIC BUFFNAME,BufferData

.MODEL SMALL
.DATA

BUFFNAME DB 15 DUP('$')

ASK_NAME DB 'Please Enter Your Name: ',10,13,'$' 

backSpace db 8,32,8,'$'  

initPoints db 10,13,'Initial Points:',10,13,'$'
;TO READ THE POINTS
BUFFPOINT LABEL BYTE
BufferSize db 3
ActualSize db ?
BufferData db 3 dup('$') 

.CODE
startScreen PROC FAR
    MOV AX, @DATA
    MOV DS, AX
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
    ;MOV AH, 04CH    ;TO RETURN TO THE OPERATING SYSTEM
    ;INT 21H 
    ret
startScreen  ENDP
END
