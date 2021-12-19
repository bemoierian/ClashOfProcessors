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

