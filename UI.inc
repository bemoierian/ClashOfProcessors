Rectangel MACRO x,y,x_Regvalue,y_Regvalue,value,Regcolor   
    
    local outer,inner
    ;DRAW ONE RECTANGEL
    mov dx,y
    mov al,Regcolor ;COLOR
    mov ah,0ch ;DRAW PIXEL
    mov bx,x
    add bx,60  ;Width
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
    mov dh,y_Regvalue   ;Y pos
    mov dl,x_Regvalue   ;X pos
    

    
    OneDigit '1'
    OneDigit '2'
    OneDigit '3'
    OneDigit '4'
    ;-----------
ENDM Rectangel

OneDigit macro val
    mov ah,2
    int 10h
    mov ah,9
    mov bh,0
    mov al,val ;letter
    mov cx,1   ;count
    mov bl,036h ;color
    int 10h
    inc dl 
    inc dl
endm OneDigit

WriteRegValue macro xpos,ypos,val
    
    mov dh,ypos   ;Y pos
    mov dl,xpos   ;X pos
    
    OneDigit val
    OneDigit val
    OneDigit val
    OneDigit val
endm WriteRegValue

DrawOneRegister MACRO RecXpos,RecYpos,RegInitialPos_X,RegInitialPos_Y,colorregister
local Rectangel8
    mov Rectanglexpos, RecXpos
    mov Rectangleypos, RecYpos
    
    mov Regvalue_XPOS, RegInitialPos_X
    mov Regvalue_YPOS, RegInitialPos_Y
    
    
    Rectangel8:
        mov Rectanglexpos, RecXpos
        mov Regvalue_XPOS, RegInitialPos_X

        Rectangel Rectanglexpos,Rectangleypos,Regvalue_XPOS,Regvalue_YPOS,1234,colorregister ;yellow rectangel
        add Rectanglexpos,71d
        add Regvalue_XPOS,9d
        
        Rectangel Rectanglexpos,Rectangleypos,Regvalue_XPOS,Regvalue_YPOS,1234,colorregister ;green rectangel
        add Rectangleypos,24d
        add Regvalue_YPOS, 3
        
        dec counterDrawRegisters
        cmp counterDrawRegisters,0
    jnz Rectangel8
    ;reset all variables
    mov Rectanglexpos, 10
    mov Rectangleypos, 10
    mov counterDrawRegisters, 4

ENDM DrawOneRegister

DrawRegisters macro
    DrawOneRegister 14d,22d,2,3,0eh
    DrawOneRegister 166d,22d,21d,3,0ah
endm DrawRegisters
  


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



