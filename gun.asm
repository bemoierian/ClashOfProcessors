;-----------------------Called in clash.asm--------------------
PUBLIC DrawGun
PUBLIC gunPrevX,gunPrevY,gunNewX,gunNewY
.286
.MODEL SMALL
.STACK 64
.DATA
gunPrevX dw 50
gunPrevY dw 100
gunNewX dw 50
gunNewY dw 100
.CODE
;Draws gun at the new position at gunNewX, gunNewY and stores the previous position in gunPrevX, gunPrevY
DrawGun PROC
    ;size of gun = 3x6
    ;Draw pixel
    mov bx, 0
    mov ah,0ch       ;Draw Pixel Command
    mov al,0Fh       ;Pixel color
    mov cx,gunPrevX   ;Column
    mov dx,gunPrevY   ;Row   
    ;loop to draw the new gun
    outer1:
        mov cx, gunPrevX ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        cmp bh,4  ;if draw 3 rows then then the gun is completed
        jz exit1
        inc bh    ;outer counter
        ;same as inner1
        inner1:  
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,8 ;if you draw 3 columns jump to outer
        jnz inner1
        jz outer1
    exit1:
    mov bx, 0
    mov al,04h       ;Pixel color
    mov cx,gunNewX   ;Column
    mov dx,gunNewY   ;Row   
    outer2:
        mov cx, gunNewX ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        cmp bh,4  ;if draw 3 rows then then the gun is completed
        jz exit2
        inc bh    ;outer counter
        ;same as inner1
        inner2:  
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,8 ;if you draw 3 columns jump to outer
        jnz inner2
        jz outer2
    exit2:

    mov ax, gunNewX
    mov bx, gunNewY
    mov gunPrevX, ax ;move the new position to previous position
    mov gunPrevY, bx
    ret
DrawGun ENDP     


END