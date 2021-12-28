


Rectangel macro   
local outer,inner
    ;DRAW ONE RECTANGEL
    mov dx,Rectangleypos
    mov al,Regcolor ;COLOR
    mov ah,0ch ;DRAW PIXEL
    mov bx,Rectanglexpos
    add bx,36  ;Width
    mov di,Rectangleypos
    add di,12  ;Height
        outer:
        mov cx,Rectanglexpos 
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

    call ConvertTo4Digit 

    mov dh,Regvalue_YPOS   ;Y pos
    mov dl,Regvalue_XPOS   ;X pos
    

    
    OneDigit d3
    OneDigit d2
    OneDigit d1
    OneDigit d0
    ;-----------
endm Rectangel 

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





writeRegisterNameLeft macro l1,l2,col
    mov dl, Regvalue_XPOS
    mov dh, Regvalue_YPOS
    sub dx,3
    Writeletter dx,l1,col
    mov dl, Regvalue_XPOS
    mov dh, Regvalue_YPOS
    sub dx,2
    Writeletter dx,l2,col
endm writeRegisterNameLeft

writeRegisterNameRight macro l1,l2,col
    mov dl, Regvalue_XPOS
    mov dh, Regvalue_YPOS
    add dx,5
    Writeletter dx,l1,col
    mov dl, Regvalue_XPOS
    mov dh, Regvalue_YPOS
    add dx,6
    Writeletter dx,l2,col
endm writeRegisterNameRight

;This macro is responsible for drawing the 8 registers 
;PARAMETERS: -->    Rect pos(x),Rect pos(y),Reg pos(x),Reg pos(y),Color, ax, bx, cx, dx, si, di, sp, bp




DrawMemory macro x,y
local next123,NotNumber123
    call ConvertTo2Digit 

    mov ah,2
    mov dh,y
    mov dl,x
    int 10h
    
    Writeletter dx,d1,0fh
    mov dh,y
    mov dl,x
    inc dl 
    Writeletter dx,d0,0fh
    mov dh,y
    mov dl,x
    inc dl 
    inc dl
    inc dl
    mov ah,MemNumber
    mov MemTemp,ah
    cmp MemTemp,10d 
    jnc NotNumber123
        add MemTemp,30h  ;if it is just a digit
        jmp next123
    NotNumber123:
        add MemTemp,55d  ;if it is just a char (a,b,c,d,e,f)
    next123:
    Writeletter dx,MemTemp,0fh

endm DrawMemory

setcursorPOS macro p
    mov ah,2
    mov dx,p ;move cursorposition to dx
    int 10h
endm setcursorPOS

Writeletter macro  p,l,c
    setcursorPOS  p ;setcursor position
    mov ah,9
    mov bh,0
    mov al,l ;letter
    mov cx,1 ;count
    mov bl,c ;color
    int 10h
endm Writeletter

PUBLIC RegMemo
EXTRN m0_1:BYTE,m1_1:BYTE,m2_1:BYTE,m3_1:BYTE,m4_1:BYTE,m5_1:BYTE,m6_1 :BYTE,m7_1:BYTE,m8_1:BYTE,m9_1:BYTE,mA_1:BYTE,mB_1 :BYTE,mC_1:BYTE,mD_1:BYTE,mE_1:BYTE,mF_1 :BYTE
EXTRN m0_2:BYTE,m1_2:BYTE,m2_2:BYTE,m3_2:BYTE,m4_2:BYTE,m5_2:BYTE,m6_2 :BYTE,m7_2:BYTE,m8_2:BYTE,m9_2:BYTE,mA_2:BYTE,mB_2 :BYTE,mC_2:BYTE,mD_2:BYTE,mE_2:BYTE,mF_2:BYTE 
EXTRN AxVar1:WORD,BxVar1:WORD,CxVar1:WORD,DxVar1:WORD,SiVar1:WORD,DiVar1:WORD,SpVar1 :WORD,BpVar1 :WORD
EXTRN AxVar2:WORD,BxVar2:WORD,CxVar2:WORD,DxVar2:WORD,SiVar2:WORD,DiVar2:WORD,SpVar2 :WORD,BpVar2 :WORD

.286
.MODEL SMALL
.STACK 64
.DATA

;------------------Variables for registers drawing----------------------
Rectanglexpos dw ?
Rectangleypos dw ?
Regvalue_YPOS db ?
Regvalue_XPOS db ?
counterDrawRegisters db 4

value dw ?
Regcolor db ?

temp dw ?

d0 db '0'
d1 db '0'
d2 db '0'
d3 db '0'

;----------------------------MEMORY-------------------------------------
;------------------Variables for registers drawing----------------------
MemXpos db 15
MemYpos db 1
MemNumber db 1
MemTemp db ?
temp2 db ?

MemoValue db ?
.code
RegMemo proc far
    mov ax,@data
    mov ds,AX

    call DrawRegisterPlayer1 
    call DrawRegisterPlayer2

    call MemoryForPlayer1 
    call MemoryForPlayer2
    
    ret
RegMemo endp

;---------------------------------------------PROCS---------------------------------------------------------

ConvertTo2Digit proc far
    mov al,MemoValue
    mov temp2,al
    
    mov dx,0
    mov ah,0
    mov al,temp2
    mov di,10h
    div di
    
    mov temp2,al
    lea bx,d0
    mov [bx],dx
    cmp d0,10d 
    jnc NotNumber
        add d0,30h  ;if it is just a digit
        jmp next01
    NotNumber:
        add d0,55d  ;if it is just a char (a,b,c,d,e,f)
    next01:
    mov ah,0
    mov dx,0
    mov di,10h
    div di
    mov ah,0
    mov temp2,al
    lea bx,d1
    mov [bx],dx
    cmp d1,10d 
    jnc NotNumber12
        add d1,30h  ;if it is just a digit
        jmp next11
    NotNumber12:
        add [bx],55d  ;if it is just a char (a,b,c,d,e,f)
    next11:
    ret
ConvertTo2Digit endp


ConvertTo4Digit proc 
    mov ax,value
    mov temp,ax
    
    mov dx,0
    mov ax,temp
    mov di,10h
    div di
    
    mov temp,ax
    lea bx,d0
    mov [bx],dx
    cmp d0,10d 
    jnc NotNumber0
        add d0,30h  ;if it is just a digit
        jmp next0
    NotNumber0:
        add d0,55d  ;if it is just a char (a,b,c,d,e,f)
    next0:
    mov dx,0
    mov di,10h
    div di
    mov ah,0
    mov temp,ax
    lea bx,d1
    mov [bx],dx
    cmp d1,10d 
    jnc NotNumber1
        add d1,30h  ;if it is just a digit
        jmp next1
    NotNumber1:
        add d1,55d  ;if it is just a char (a,b,c,d,e,f)
    next1:
    
    mov dx,0
    mov di,10h
    div di
    mov ah,0
    mov temp,ax
    lea bx,d2
    mov [bx],dx
    cmp d2,10d 
    jnc NotNumber2
        add d2,30h  ;if it is just a digit
        jmp next2
    NotNumber2:
        add d2,55d  ;if it is just a char (a,b,c,d,e,f)
    next2:
        
    mov dx,0
    mov di,10h
    div di
    mov ah,0
    mov temp,ax
    lea bx,d3
    mov [bx],dx
    cmp d3,10d 
    jnc NotNumber3
        add d3,30h  ;if it is just a digit
        jmp next3
    NotNumber3:
        add d3,55d  ;if it is just a char (a,b,c,d,e,f)
    next3:
    ret
ConvertTo4Digit endp

DrawRegisterPlayer1 proc 

    ;Player 1 background initial position is (22d,22d)
    ;Player 1 values initial position is (3,3)
    mov Rectanglexpos, 22d
    mov Rectangleypos, 22d
    
    mov Regvalue_XPOS, 5d
    mov Regvalue_YPOS, 3d
    
    
    ; Player 2 reg background color is 0eh - green
    ; Player 2 reg name color is 04h - light blue
    mov Regcolor,0eh
    ;---------------------------------------------------------------------------------------------------------------------------1   
    mov Rectanglexpos, 22d
    mov Regvalue_XPOS, 3d

    ;AX
    writeRegisterNameLeft 'A','x',04h
    mov si,AxVar1
    mov value,si
    Rectangel 
    

    add Rectanglexpos,40d
    add Regvalue_XPOS,5d
    
    ;SI
    writeRegisterNameRight 'S','i',04h
    mov si,SiVar1
    mov value,si
    Rectangel 
    
    
    add Rectangleypos,24d
    add Regvalue_YPOS, 3d


    dec counterDrawRegisters
    ;cmp counterDrawRegisters,0
;---------------------------------------------------------------------------------------------------------------------------2
    mov Rectanglexpos, 22d
    mov Regvalue_XPOS, 3d

    ;BX
    writeRegisterNameLeft 'B','x',04h
    mov si,BxVar1
    mov value,si
    Rectangel 
    

    add Rectanglexpos,40d
    add Regvalue_XPOS,5d
    
    ;DI
    writeRegisterNameRight 'D','i',04h
    mov si,DiVar1
    mov value,si
    Rectangel 

    add Rectangleypos,24d
    add Regvalue_YPOS, 3d


    dec counterDrawRegisters
    ;-----------------------------------------------------------------------------------------------------------------------3
    mov Rectanglexpos, 22d
    mov Regvalue_XPOS, 3d

    ;CX
    writeRegisterNameLeft 'C','x',04h
    mov si,CxVar1
    mov value,si
    Rectangel 
    

    add Rectanglexpos,40d
    add Regvalue_XPOS,5d
    
    ;SP
    writeRegisterNameRight 'S','P',04h
    mov si,SpVar1
    mov value,si
    Rectangel 
    
    
    add Rectangleypos,24d
    add Regvalue_YPOS, 3d


    dec counterDrawRegisters
    ;-----------------------------------------------------------------------------------------------------------------------4
    mov Rectanglexpos, 22d
    mov Regvalue_XPOS, 3d
    ;DX
    writeRegisterNameLeft 'D','x',04h
    mov si,DxVar1
    mov value,si
    Rectangel 
    
    add Rectanglexpos,40d
    add Regvalue_XPOS,5d
    
    ;BP
    writeRegisterNameRight 'B','P',04h
    mov si,BpVar1
    mov value,si
    Rectangel 
    
    add Rectanglexpos,40d
    add Regvalue_XPOS,5d
    ret
DrawRegisterPlayer1 ENDP


DrawRegisterPlayer2 PROC 

        ;Player 2 background initial position is (182d,22d)
        ;Player 2 values initial position is (23d,3d)
        mov Rectanglexpos, 182d
        mov Rectangleypos, 22d
        
        mov Regvalue_XPOS, 23d
        mov Regvalue_YPOS, 3d
        
        ; Player 2 reg background color is 0ah - green
        ; Player 2 reg name color is 03h - light blue
        mov Regcolor,0ah
        ;---------------------------------------------------------------------------------------------------------------------------1
        mov Rectanglexpos, 182d
        mov Regvalue_XPOS, 23d

        ;AX
        writeRegisterNameLeft 'A','x',03h
        mov si,AxVar2
        mov value,si
        Rectangel 


        add Rectanglexpos,40d
        add Regvalue_XPOS,5d
        
        ;SI
        writeRegisterNameRight 'S','i',03h
        mov si,SiVar2
        mov value,si
        Rectangel 
        
        
        add Rectangleypos,24d
        add Regvalue_YPOS, 3
        dec counterDrawRegisters
;---------------------------------------------------------------------------------------------------------------------------2
        mov Rectanglexpos, 182d
        mov Regvalue_XPOS, 23d

        ;BX
        writeRegisterNameLeft 'B','x',03h
        mov si,BxVar2
        mov value,si
        Rectangel 

        

        add Rectanglexpos,40d
        add Regvalue_XPOS,5d
        
        ;DI
        writeRegisterNameRight 'D','i',03h
        mov si,DiVar2
        mov value,si
        Rectangel
        
        
        add Rectangleypos,24d
        add Regvalue_YPOS, 3


        dec counterDrawRegisters
        ;-----------------------------------------------------------------------------------------------------------------------3
        mov Rectanglexpos, 182d
        mov Regvalue_XPOS, 23d

        ;CX
        writeRegisterNameLeft 'C','x',03h
        mov si,CxVar2
        mov value,si
        Rectangel

        add Rectanglexpos,40d
        add Regvalue_XPOS,5d
        
        ;SP
        writeRegisterNameRight 'S','P',03h
        mov si,SpVar2
        mov value,si
        Rectangel
        
        add Rectangleypos,24d
        add Regvalue_YPOS, 3


        dec counterDrawRegisters
        ;-----------------------------------------------------------------------------------------------------------------------4
        mov Rectanglexpos, 182d
        mov Regvalue_XPOS, 23d
        ;DX
        writeRegisterNameLeft 'D','x',03h
        mov si,DxVar2
        mov value,si
        Rectangel
        
        
        add Rectanglexpos,40d
        add Regvalue_XPOS,5d
        
        ;BP
        writeRegisterNameRight 'B','P',03h
        mov si,BpVar2
        mov value,si
        Rectangel
        

        add Rectanglexpos,40d
        add Regvalue_XPOS,5d
        RET
DrawRegisterPlayer2 ENDP

MemoryForPlayer1 PROC 
        mov MemNumber,0
        ;16 is the start x position of the memory of the first player
        mov MemXpos,16
        ;-------Memory Loc 0-----
        mov bh,m0_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc 1-----
        mov bh,m1_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc 2-----
        mov bh,m2_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc 3-----
        mov bh,m3_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc 4-----
        mov bh,m4_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc 5-----
        mov bh,m5_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc 6-----
        mov bh,m6_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc 7-----
        mov bh,m7_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc 8-----
        mov bh,m8_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos,m8_1
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc 9-----
        mov bh,m9_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc A-----
        mov bh,mA_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc B-----
        mov bh,mB_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc C-----
        mov bh,mC_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc D-----
        mov bh,mD_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc E-----
        mov bh,mE_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        ;-------Memory Loc F-----
        mov bh,mF_1 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,16
        inc dh
        inc MemNumber
        mov MemYpos,1
        mov MemNumber,0
        ret
MemoryForPlayer1 ENDP


MemoryForPlayer2 PROC  
    mov MemNumber,0
    ;36 is the start x position of the memory of the second player
    mov MemXpos,36
        ;-------Memory Loc 0-----
        mov bh,m0_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc 1-----
        mov bh,m1_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc 2-----
        mov bh,m2_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc 3-----
        mov bh,m3_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc 4-----
        mov bh,m4_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc 5-----
        mov bh,m5_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc 6-----
        mov bh,m6_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc 7-----
        mov bh,m7_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc 8-----
        mov bh,m8_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc 9-----
        mov bh,m9_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc A-----
        mov bh,mA_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc B-----
        mov bh,mB_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc C-----
        mov bh,mC_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc D-----
        mov bh,mD_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc E-----
        mov bh,mE_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        ;-------Memory Loc F-----
        mov bh,mF_2 
        mov MemoValue,bh
        DrawMemory MemXpos,MemYpos
        inc MemYpos
        mov MemXpos,36
        inc dh
        inc MemNumber
        mov MemYpos,1

        ret
MemoryForPlayer2  ENDP

END

