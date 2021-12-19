Rectangel MACRO x,y,value
    local outer,inner
    ;DRAW ONE YELLOW RECTANGEL
    mov dx,y
    mov al,0eh ;COLOR
    mov ah,0ch ;DRAW PIXEL
    mov bx,x
    add bx,40  ;Width
    mov di,y
    add di,10  ;Height
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
    ;WriteRegValue x,y,'1'
    ;WriteRegValue x,y,'2'
    ;WriteRegValue x,y,'4'
    ;WriteRegValue x,y,'5'
    ;-----------
ENDM Rectangel

WriteRegValue macro x,y,val

    mov dx,y   ;Y pos
    mov cl,8
    shl dx,cl
    add dx,x   ;X pos
    displayletter dx,val,09h
    getcursor
    add dl,1
endm WriteRegValue

DrawRegisters MACRO
    mov Rectanglexpos,10
    mov Rectangleypos,20
    

    Rectangel8:
        Rectangel Rectanglexpos,Rectangleypos
        add Rectanglexpos,60
        Rectangel Rectanglexpos,Rectangleypos
        add Rectangleypos,20
        mov Rectanglexpos,10
        dec counterDrawRegisters
        cmp counterDrawRegisters,0
    jnz Rectangel8
    mov Rectanglexpos, 10
    mov Rectangleypos, 10
    mov counterDrawRegisters, 4
ENDM DrawRegisters


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



