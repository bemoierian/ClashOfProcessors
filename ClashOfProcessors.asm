.286
.MODEL SMALL
.STACK 64
.DATA
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
    
    call MoveGun

HLT
MAIN ENDP


;Reads the input from user (left,right,up,down arrows) and moves the gun
MoveGun PROC
    pusha
    loop1:
        mov ah,0
        int 16h   ;Get key pressed (Wait for a key-AH:scancode,AL:ASCII)
        ;right arrow
        right:
            cmp ah, 4Dh ;compare key code with right key code
            jnz left    ;if the key is not right, jump to next check
            add gunNewX, 3  ;if the key is right, move the gun 3 pixels to the right
            call DrawGun    ;draw the new gun
            jmp loop1       ;loop to check the next input
        ;left arrow    
        left:
            cmp ah, 4Bh
            jnz up
            sub gunNewX, 3
            call DrawGun
            jmp loop1
        ;up arrow
        up:
            cmp ah, 48h
            jnz down
            sub gunNewY, 3
            call DrawGun
            jmp loop1
        ;down arrow
        down:
            cmp ah, 50h
            jnz esc1
            add gunNewY, 3
            call DrawGun
            jmp loop1          
    
    esc1:
    popa
    ret
MoveGun ENDP


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
    ;loop to delete the previous gun (Delete here means draw a black box on it)
    outer1: ;outer to increment rows
        mov cx, gunPrevX ;X position of previous gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        inc bh    ;outer counter
        cmp bh,3  ;if draw 3 rows then then the gun is deleted
        jz exit1
    
        inner1:  ;to draw lines
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,3 ;if you draw 3 columns jump to outer 
        jnz inner1
        jz outer1
    exit1:
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