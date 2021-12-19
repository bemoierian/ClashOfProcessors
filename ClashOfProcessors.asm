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
    local back
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



;Draws gun at the new position at gunNewX, gunNewY and stores the previous position in gunPrevX, gunPrevY
DrawGun MACRO
    ;size of gun = 3x3
    ; pusha ;push registers to save them so that the function doesn' affect any reg from the outside
    ;Draw pixel
    mov bx, 0
    mov cx,gunPrevX   ;Column
    mov dx,gunPrevY   ;Row       
    mov al,0h        ;Pixel color
    mov ah,0ch       ;Draw Pixel Command
    ;Draw pixel
    mov bx, 0
    mov cx,gunNewX   ;Column
    mov dx,gunNewY   ;Row       
    mov al,04h       ;Pixel color
    mov ah,0ch       ;Draw Pixel Command
    ;loop to draw the new gun
    outer2:
        mov cx, gunNewX ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        cmp bh,3  ;if draw 3 rows then then the gun is completed
        jz exit2
        inc bh    ;outer counter
        ;same as inner1
        inner2:  
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,3 ;if you draw 3 columns jump to outer
        jnz inner2
        jz outer2
    exit2:
    mov ax, gunNewX
    mov bx, gunNewY
    mov gunPrevX, ax ;move the new position to previous position
    mov gunPrevY, bx
    ; popa    ;restore the registers
    ;ret
ENDM DrawGun     


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

.286
.MODEL SMALL
.STACK 64
.DATA
;------------------Variables for registers drawing----------------------
Rectanglexpos dw 10
Rectangleypos dw 10
counterDrawRegisters db 4
counterNumbers db 4
;------------------Previous and New position of Gun---------------------
gunPrevX dw 50
gunPrevY dw 50
gunNewX dw 50
gunNewY dw 50
.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX
    
  
    
    UserNames:


    EndUserNames:
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