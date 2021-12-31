;-----------------Called in clash.asm------------------
PUBLIC DrawGun, FireGun_initial, FireGun_Continue
PUBLIC gunPrevX,gunPrevY,gunNewX,gunNewY
;------------------------------------------------------
.286
.MODEL SMALL
.STACK 64
.DATA
;--------------------------Gun--------------------------
gunPrevX dw 50
gunPrevY dw 100
gunNewX dw 50
gunNewY dw 100
;------------------------Gun fire-----------------------
FireX dw 0
FireY dw 0
isFiring db 0
;----------------------Flying objects-------------------
FlyPosX db 0
FlyPosY db 0
FlyColor db 0
isFlying db 0
;-------------------------------------------------------
.CODE
;Draws gun at the new position at gunNewX, gunNewY and stores the previous position in gunPrevX, gunPrevY
DrawGun PROC FAR
    mov ax, @data
    mov ds, ax
    ;size of gun = 3x9
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
        cmp bl,9 ;if you draw 3 columns jump to outer
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
        cmp bl,9 ;if you draw 3 columns jump to outer
        jnz inner2
        jz outer2
    exit2:

    mov ax, gunNewX
    mov bx, gunNewY
    mov gunPrevX, ax ;move the new position to previous position
    mov gunPrevY, bx
    ret
DrawGun ENDP     

FireGun_initial PROC FAR
    mov ax, @data
    mov ds, ax
    cmp isFiring, 0
    jnz alreadyFiring
    mov ax, gunPrevX
    add ax, 3
    mov bx, gunPrevY
    sub bx, 3
    mov FireX, ax
    mov FireY, bx
    mov isFiring, 1
    alreadyFiring:
    RET
FireGun_initial ENDP


FireGun_Continue PROC FAR
    mov ax, @data
    mov ds, ax
    cmp isFiring, 1
    jnz notFiring
    mov bx, 0
    mov ah,0ch       ;Draw Pixel Command
    mov al,0Fh       ;Pixel color
    mov cx,FireX   ;Column
    mov dx,FireY   ;Row   
    ;loop to draw the new gun
    outer3:
        mov cx, FireX ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        cmp bh,3  ;if draw 3 rows then then the gun is completed
        jz exit3
        inc bh    ;outer counter
        ;same as inner1
        inner3:  
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,3 ;if you draw 3 columns jump to outer
        jnz inner3
        jz outer3
    exit3:
    cmp FireY, 0
    jnz stillFiring
    mov isFiring, 0
    jmp notFiring
    stillFiring:
    sub FireY, 1
    mov bx, 0
    mov al,04h       ;Pixel color
    mov cx,FireX   ;Column
    mov dx,FireY   ;Row   
    outer4:
        mov cx, FireX ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        cmp bh,3  ;if draw 3 rows then then the gun is completed
        jz exit4
        inc bh    ;outer counter
        ;same as inner1
        inner4:  
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,3 ;if you draw 3 columns jump to outer
        jnz inner4
        jz outer4
    exit4:
    notFiring:
    RET
FireGun_Continue ENDP

DidFireHit PROC FAR
    
    RET
DidFireHit ENDP
END