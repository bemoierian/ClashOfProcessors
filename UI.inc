;-------------------------------------Main Screen--------------------------------------
display_string_main MACRO mes,x,y
    MOV  DL, x  ;COLUMN
    MOV  DH, y   ;ROW
    MOV  BH, 0    ;DISPLAY PAGE
    MOV  AH, 02H  ;SETCURSORPOSITION
    INT  10H
    MOV AH, 9
    MOV DX, OFFSET mes
    INT 21H
ENDM display_string_main 

draw_mainscreen MACRO str1, str2, str3
    LOCAL BACK,INC_LOOP,EXIT
    ;display the 3 sentences
    display_string_main str1,5h,5h    
    display_string_main str2,5h,7h    
    display_string_main str3,5h,9h    
    
;     ;display dashed line (chat section)
;     mov cx,0 ;Column
;     MOV dx,175D ;Row 
    
;     BACK:
;         MOV al,0fh ;Pixel color
;         MOV ah,0ch ;Draw Pixel Command
;         int 10h 
;         MOV BL,2H
;         MOV AX,CX
;         DIV BL
;         CMP AH,1H
;         JZ INC_LOOP   
;         inc cx
;         cmp cx,13Fh ;319d
;         jAE EXIT

;     INC_LOOP:
;         INC CX
;         JMP BACK
; EXIT:  

ENDM draw_mainscreen 
;--------------------------------------------------------------------------------------


Rectangel MACRO x,y,x_Regvalue,y_Regvalue,value,Regcolor   
    
    local outer,inner
    
    ;DRAW ONE RECTANGEL
    mov dx,y
    mov al,Regcolor ;COLOR
    mov ah,0ch ;DRAW PIXEL
    mov bx,x
    add bx,36  ;Width
    mov di,y
    add di,12  ;Height
        outer:
        mov cx,x 
            inner:
            int 10h
            inc cx
            cmp cx,bx
            jnz inner
        inc dx
        cmp dx,di
        jnz outer
    ;WRITE THE VALUE INSIDE THE REGISTER
    ;WriteRegValue x_Regvalue,y_Regvalue,'2'

    ConvertTo4Digit value

    mov dh,y_Regvalue   ;Y pos
    mov dl,x_Regvalue   ;X pos
    

    
    OneDigit d3
    OneDigit d2
    OneDigit d1
    OneDigit d0
    ;-----------
ENDM Rectangel

OneDigit macro val
    mov ah,2
    int 10h
    mov ah,9
    mov bh,0
    mov al,val ;letter
    mov cx,1   ;count
    mov bl,0fh ;color
    int 10h
    inc dl
endm OneDigit

ConvertTo4Digit macro value
    local NotNumber0,NotNumber1,NotNumber2,NotNumber3,next0,next1,next2,next3
    mov ax,value
    mov temp,ax
    
    mov dx,0
    mov ax,temp
    mov di,10h
    div di
    
    mov temp,ax
    lea bx,d0
    mov [bx],dx
    cmp [bx],10d 
    jnc NotNumber0
        add [bx],30h  ;if it is just a digit
        jmp next0
    NotNumber0:
        add [bx],55d  ;if it is just a char (a,b,c,d,e,f)
    next0:
    mov dx,0
    mov di,10h
    div di
    mov ah,0
    mov temp,ax
    lea bx,d1
    mov [bx],dx
    cmp [bx],10d 
    jnc NotNumber1
        add [bx],30h  ;if it is just a digit
        jmp next1
    NotNumber1:
        add [bx],55d  ;if it is just a char (a,b,c,d,e,f)
    next1:
    
    mov dx,0
    mov di,10h
    div di
    mov ah,0
    mov temp,ax
    lea bx,d2
    mov [bx],dx
    cmp [bx],10d 
    jnc NotNumber2
        add [bx],30h  ;if it is just a digit
        jmp next2
    NotNumber2:
        add [bx],55d  ;if it is just a char (a,b,c,d,e,f)
    next2:
        
    mov dx,0
    mov di,10h
    div di
    mov ah,0
    mov temp,ax
    lea bx,d3
    mov [bx],dx
    cmp [bx],10d 
    jnc NotNumber3
        add [bx],30h  ;if it is just a digit
        jmp next3
    NotNumber3:
        add [bx],55d  ;if it is just a char (a,b,c,d,e,f)
    next3:
endm ConvertTo4Digit


ConvertTo2Digit macro v2
local NotNumber0,NotNumber1,next0,next1
    mov al,v2
    mov temp2,al
    
    mov dx,0
    mov ah,0
    mov al,temp2
    mov di,10h
    div di
    
    mov temp2,al
    lea bx,d0
    mov [bx],dx
    cmp [bx],10d 
    jnc NotNumber0
        add [bx],30h  ;if it is just a digit
        jmp next0
    NotNumber0:
        add [bx],55d  ;if it is just a char (a,b,c,d,e,f)
    next0:
    mov ah,0
    mov dx,0
    mov di,10h
    div di
    mov ah,0
    mov temp2,al
    lea bx,d1
    mov [bx],dx
    cmp [bx],10d 
    jnc NotNumber1
        add [bx],30h  ;if it is just a digit
        jmp next1
    NotNumber1:
        add [bx],55d  ;if it is just a char (a,b,c,d,e,f)
    next1:
    
endm ConvertTo2Digit

writeRegisterNameLeft macro l1,l2,col
    mov dl, Regvalue_XPOS
    mov dh, Regvalue_YPOS
    sub dx,3
    displayletter dx,l1,col
    mov dl, Regvalue_XPOS
    mov dh, Regvalue_YPOS
    sub dx,2
    displayletter dx,l2,col
endm writeRegisterNameLeft

writeRegisterNameRight macro l1,l2,col
    mov dl, Regvalue_XPOS
    mov dh, Regvalue_YPOS
    add dx,5
    displayletter dx,l1,col
    mov dl, Regvalue_XPOS
    mov dh, Regvalue_YPOS
    add dx,6
    displayletter dx,l2,col
endm writeRegisterNameRight

;This macro is responsible for drawing the 8 registers 
;PARAMETERS: -->    Rect pos(x),Rect pos(y),Reg pos(x),Reg pos(y),Color, ax, bx, cx, dx, si, di, sp, bp
DrawOneRegister MACRO RecXpos,RecYpos,RegInitialPos_X,RegInitialPos_Y,colorregister,AxVar,BxVar,CxVar,DxVar,SiVar,DiVar,SpVar,BpVar,NameColor
local Rectangel8
    mov Rectanglexpos, RecXpos
    mov Rectangleypos, RecYpos
    
    mov Regvalue_XPOS, RegInitialPos_X
    mov Regvalue_YPOS, RegInitialPos_Y
    
    
    Rectangel8:
    ;---------------------------------------------------------------------------------------------------------------------------1
        mov Rectanglexpos, RecXpos
        mov Regvalue_XPOS, RegInitialPos_X

        ;AX
        writeRegisterNameLeft 'A','x',NameColor
        Rectangel Rectanglexpos,Rectangleypos,Regvalue_XPOS,Regvalue_YPOS,AxVar,colorregister
        

        add Rectanglexpos,40d
        add Regvalue_XPOS,5d
        
        ;SI
        writeRegisterNameRight 'S','i',NameColor
        Rectangel Rectanglexpos,Rectangleypos,Regvalue_XPOS,Regvalue_YPOS,SiVar,colorregister 
        
        
        add Rectangleypos,24d
        add Regvalue_YPOS, 3


        dec counterDrawRegisters
        ;cmp counterDrawRegisters,0
;---------------------------------------------------------------------------------------------------------------------------2
        mov Rectanglexpos, RecXpos
        mov Regvalue_XPOS, RegInitialPos_X

        ;BX
        writeRegisterNameLeft 'B','x',NameColor
        Rectangel Rectanglexpos,Rectangleypos,Regvalue_XPOS,Regvalue_YPOS,BxVar,colorregister 
        

        add Rectanglexpos,40d
        add Regvalue_XPOS,5d
        
        ;DI
        writeRegisterNameRight 'D','i',NameColor
        Rectangel Rectanglexpos,Rectangleypos,Regvalue_XPOS,Regvalue_YPOS,DiVar,colorregister 
        
        
        add Rectangleypos,24d
        add Regvalue_YPOS, 3


        dec counterDrawRegisters
        ;-----------------------------------------------------------------------------------------------------------------------3
        mov Rectanglexpos, RecXpos
        mov Regvalue_XPOS, RegInitialPos_X

        ;CX
        writeRegisterNameLeft 'C','x',NameColor
        Rectangel Rectanglexpos,Rectangleypos,Regvalue_XPOS,Regvalue_YPOS,CxVar,colorregister 
        

        add Rectanglexpos,40d
        add Regvalue_XPOS,5d
        
        ;SP
        writeRegisterNameRight 'S','P',NameColor
        Rectangel Rectanglexpos,Rectangleypos,Regvalue_XPOS,Regvalue_YPOS,SpVar,colorregister 
        
        
        add Rectangleypos,24d
        add Regvalue_YPOS, 3


        dec counterDrawRegisters
        ;-----------------------------------------------------------------------------------------------------------------------4
        mov Rectanglexpos, RecXpos
        mov Regvalue_XPOS, RegInitialPos_X
        ;DX
        writeRegisterNameLeft 'D','x',NameColor
        Rectangel Rectanglexpos,Rectangleypos,Regvalue_XPOS,Regvalue_YPOS,DxVar,colorregister 
        
        add Rectanglexpos,40d
        add Regvalue_XPOS,5d
        
        ;BP
        writeRegisterNameRight 'B','P',NameColor
        Rectangel Rectanglexpos,Rectangleypos,Regvalue_XPOS,Regvalue_YPOS,BpVar,colorregister 
        

        add Rectanglexpos,40d
        add Regvalue_XPOS,5d
ENDM DrawOneRegister

;This macro is responsible for drawing the 8 registers of each player
DrawRegisters macro
    ;Rect pos(x),Rect pos(y),Reg pos(x),Reg pos(y),Color, ax, bx, cx, dx, si, di, sp, bp , nameColor
    DrawOneRegister 22d,22d,3,3,0eh,AxVar1,BxVar1,CxVar1,DxVar1,SiVar1,DiVar1,SpVar1,BpVar1,04h
    DrawOneRegister 182d,22d,23d,3,0ah,AxVar2,BxVar2,CxVar2,DxVar2,SiVar2,DiVar2,SpVar2,BpVar2,03h

endm DrawRegisters


DrawMemory macro x,y,val
local NotNumber,next
    ConvertTo2Digit val

    mov ah,2
    mov dh,y
    mov dl,x
    int 10h
    
    displayletter dx,d1,0fh
    mov dh,y
    mov dl,x
    inc dl 
    displayletter dx,d0,0fh
    mov dh,y
    mov dl,x
    inc dl 
    inc dl
    inc dl
    mov ah,MemNumber
    mov MemTemp,ah
    cmp MemTemp,10d 
    jnc NotNumber
        add MemTemp,30h  ;if it is just a digit
        jmp next
    NotNumber:
        add MemTemp,55d  ;if it is just a char (a,b,c,d,e,f)
    next:

    displayletter dx,MemTemp,0fh

endm DrawMemory


MemoryForPlayer1 macro Px

    mov MemNumber,1
    mov MemXpos,Px
        ;-------Memory Loc 1-----
        DrawMemory MemXpos,MemYpos,m1_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 2-----
        DrawMemory MemXpos,MemYpos,m2_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 3-----
        DrawMemory MemXpos,MemYpos,m3_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 4-----
        DrawMemory MemXpos,MemYpos,m4_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 5-----
        DrawMemory MemXpos,MemYpos,m5_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 6-----
        DrawMemory MemXpos,MemYpos,m6_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 7-----
        DrawMemory MemXpos,MemYpos,m7_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 8-----
        DrawMemory MemXpos,MemYpos,m8_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 9-----
        DrawMemory MemXpos,MemYpos,m9_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc A-----
        DrawMemory MemXpos,MemYpos,mA_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc B-----
        DrawMemory MemXpos,MemYpos,mB_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc C-----
        DrawMemory MemXpos,MemYpos,mC_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc D-----
        DrawMemory MemXpos,MemYpos,mD_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc E-----
        DrawMemory MemXpos,MemYpos,mE_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc F-----
        DrawMemory MemXpos,MemYpos,mF_1
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
    mov MemYpos,1
endm MemoryForPlayer1

MemoryForPlayer2 macro Px

    mov MemNumber,1
    mov MemXpos,Px
        ;-------Memory Loc 1-----
        DrawMemory MemXpos,MemYpos,m1_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 2-----
        DrawMemory MemXpos,MemYpos,m2_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 3-----
        DrawMemory MemXpos,MemYpos,m3_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 4-----
        DrawMemory MemXpos,MemYpos,m4_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 5-----
        DrawMemory MemXpos,MemYpos,m5_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 6-----
        DrawMemory MemXpos,MemYpos,m6_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 7-----
        DrawMemory MemXpos,MemYpos,m7_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 8-----
        DrawMemory MemXpos,MemYpos,m8_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc 9-----
        DrawMemory MemXpos,MemYpos,m9_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc A-----
        DrawMemory MemXpos,MemYpos,mA_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc B-----
        DrawMemory MemXpos,MemYpos,mB_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc C-----
        DrawMemory MemXpos,MemYpos,mC_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc D-----
        DrawMemory MemXpos,MemYpos,mD_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc E-----
        DrawMemory MemXpos,MemYpos,mE_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
        ;-------Memory Loc F-----
        DrawMemory MemXpos,MemYpos,mF_2
        inc MemYpos
        mov MemXpos,Px
        inc dh
        inc MemNumber
    mov MemYpos,1
endm MemoryForPlayer2
  


Background macro 
    ; Scroll up function
    mov ax, 0700h    
    mov bh, 0fh    ; white background
    mov cx, 0     
    mov dx, 184FH   
    int 10H
endm Background

verticalline macro y,x,max
    LOCAL back
    ;draw pixles untill the line is drawn
    mov cx,x ;column
    mov dx,y;row
    mov al,0h ;black color
    mov ah,0ch ;Draw Pixel Command
    back:
    int 10h
    inc dx
    cmp dx,max
    jnz back
endm verticalline




horizontalline macro y,x,max
    ;draw pixles untill the line is drawn
    LOCAL b
    mov cx,x ;column
    mov dx,y ;row
    mov al,0h ;black color
    mov ah,0ch ;Draw Pixel Command
    b:
    int 10h
    inc cx
    cmp cx,max
    jnz b
endm horizontalline

drawrectangle  macro   x,y,color,horizontallen,verticallen
    LOCAL g1,g2

    mov al,color
    mov cx,y ;y position
    mov dx,x ;x position
    mov si,y 
    mov di,x
    add si,verticallen   ;position of y +length of side
    add di,horizontallen ;position of x +length of side

    g1 :
    int 10H 
    mov bx,cx

    g2 :
    inc cx
    int 10H
    cmp cx,si ; compare the column with position of y +length of side
    jne g2 
    mov cx,bx
    inc dx
    cmp dx,di;compare the row with position of x +length of side
    jle g1

endm drawrectangle

setcursor macro p
    mov ah,2
    mov dx,p ;move cursorposition to dx
    int 10h
endm setcursor

displayletter macro  p,l,c
    setcursor  p ;setcursor position
    mov ah,9
    mov bh,0
    mov al,l ;letter
    mov cx,1 ;count
    mov bl,c ;color
    int 10h
    ;newcode
    ;mov ah,2
    ;mov dl,l
    ;int 21h
endm displayletter

getcursor macro  ;getcursor position
    mov ah,3h 
    mov bh,0h 
    int 10h
endm getcursor



