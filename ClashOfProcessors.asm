.286
.MODEL SMALL
.STACK 64

Rectangel MACRO x,y
    local outer,inner
    ;DRAW ONE YELLOW RECTANGEL
     
     mov dx,y
     mov al,0eh;COLOR
     mov ah,0ch;DRAW PIXEL
     mov bx,x
     add bx,40
     mov di,y
     add di,10
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
     ;-----------
ENDM Rectangel
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

.DATA
;------------------Variables for registers drawing----------------------
Rectanglexpos dw 10
Rectangleypos dw 10
counterDrawRegisters db 4
;------------------Previous and New position of Gun---------------------
gunPrevX dw 50
gunPrevY dw 50
gunNewX dw 50
gunNewY dw 50
.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX
    
    mov ah,0   ;graphics mode
    mov al,13h
    int 10h
    
    UserNames:



    MainScreen:

    ;Main Game Loop
    Game:
  
        DrawRegisters

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
            call DrawGun

        ;Exit game if key if F3
        cmp al, 13h
        jz MainScreen
        jmp Game
HLT
MAIN ENDP


;Draws gun at the new position at gunNewX, gunNewY and stores the previous position in gunPrevX, gunPrevY
DrawGun proc
    ;size of gun = 3x3
    pusha ;push registers to save them so that the function doesn' affect any reg from the outside
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
    mov al,0fh       ;Pixel color
    mov ah,0ch       ;Draw Pixel Command
    ;loop to draw the new gun
    outer2:
        mov cx, gunNewX ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        inc bh    ;outer counter
        cmp bh,3  ;if draw 3 rows then then the gun is completed
        jz exit2
        ;same as inner1
        inner2:  
        int 10h 
        inc cx
        inc bl
        cmp bl,3
        jnz inner2
        jz outer2
    exit2:
    mov ax, gunNewX
    mov bx, gunNewY
    mov gunPrevX, ax ;move the new position to previous position
    mov gunPrevY, bx
    popa    ;restore the registers
    ret
DrawGun endp     


END MAIN