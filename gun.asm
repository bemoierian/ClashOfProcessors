;-----------------Called in clash.asm------------------
PUBLIC FlyObj1_Continue, FlyObj2_Continue, FlyObj_initial
PUBLIC DrawGun1, FireGun1_initial, FireGun1_Continue
PUBLIC gun1NewX,gun1NewY
PUBLIC DrawGun2, FireGun2_initial, FireGun2_Continue
PUBLIC gun2NewX,gun2NewY
PUBLIC l11,c11,l12,c12,l13,c13,l14,c14,l15,c15,l21,c21,l22,c22,l23,c23,l24,c24,l25,c25
;------------------------------------------------------
EXTRN P1_score:BYTE, P2_score:BYTE
;------------------------------------------------------
.286
.MODEL SMALL
.STACK 64
.DATA
;--------------------------Gun--------------------------
gun1PrevX dw 80
gun1PrevY dw 100
gun1NewX dw 80
gun1NewY dw 100

gun2PrevX dw 240
gun2PrevY dw 100
gun2NewX dw 240
gun2NewY dw 100
;------------------------Gun fire-----------------------
Fire1X dw 0
Fire1Y dw 0
isFiring1 db 0
Fire1Hit db 0

Fire2X dw 0
Fire2Y dw 0
isFiring2 db 0
Fire2Hit db 0
;----------------------Flying objects-------------------
Fly1PosX_strt dw 150
Fly1PosY_strt dw 3
Fly1PosX_end dw 0
Fly1PosY_end dw 0
Fly2PosX_strt dw 310
Fly2PosY_strt dw 3
Fly2PosX_end dw 0
Fly2PosY_end dw 0
FlyColor db 04h
isFlying db 0

ColorCount db 0 ;index for color array
arr_color db 0ah,09h,0ch,0eh,0DH
;-------------------scores values and colors --------------
l11 db 0
l12 db 0
l13 db 0
l14 db 0
l15 db 0
c11 db 0ah
c12 db 9h
c13 db 0ch
c14 db 0eh
c15 db 0dh
;-----------------
l21 db 0
l22 db 0
l23 db 0
l24 db 0
l25 db 0
c21 db 0ah
c22 db 9h
c23 db 0ch
c24 db 0eh
c25 db 0dh
;-------------------------------------------------------
.CODE
;Draws gun at the new position at gunNewX, gunNewY and stores the previous position in gunPrevX, gunPrevY
DrawGun1 PROC FAR
    mov ax, @data
    mov ds, ax
    ;size of gun = 3x9
    ;Draw pixel
    mov bx, 0
    mov ah,0ch       ;Draw Pixel Command
    mov al,0Fh       ;Pixel color
    mov cx,gun1PrevX   ;Column
    mov dx,gun1PrevY   ;Row   
    ;loop to delete the old gun (draw white box)
    outer1:
        mov cx, gun1PrevX ;X position of new gun
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
    mov cx,gun1NewX   ;Column
    mov dx,gun1NewY   ;Row   
    outer2:
        mov cx, gun1NewX ;X position of new gun
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

    mov ax, gun1NewX
    mov bx, gun1NewY
    mov gun1PrevX, ax ;move the new position to previous position
    mov gun1PrevY, bx
    ret
DrawGun1 ENDP     

FireGun1_initial PROC FAR
    mov ax, @data
    mov ds, ax
    cmp isFiring1, 0
    jnz alreadyFiring1
    mov ax, gun1PrevX
    add ax, 3
    mov bx, gun1PrevY
    sub bx, 3
    mov Fire1X, ax
    mov Fire1Y, bx
    mov isFiring1, 1
    mov Fire1Hit, 0
    alreadyFiring1:
    RET
FireGun1_initial ENDP


FireGun1_Continue PROC FAR
    mov ax, @data
    mov ds, ax
    cmp isFiring1, 1
    jnz notFiring1
    mov bx, 0
    mov ah,0ch       ;Draw Pixel Command
    mov al,0Fh       ;Pixel color
    mov cx,Fire1X   ;Column
    mov dx,Fire1Y   ;Row   
    ;loop to draw the new gun
    outer3:
        mov cx, Fire1X ;X position of new gun
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
    cmp Fire1Y, 0
    jnz stillFiring1
    mov isFiring1, 0
    jmp notFiring1
    stillFiring1:
    sub Fire1Y, 1
    mov bx, 0
    mov al,04h       ;Pixel color
    mov cx,Fire1X   ;Column
    mov dx,Fire1Y   ;Row   
    outer4:
        mov cx, Fire1X ;X position of new gun
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
    CMP Fire1Hit, 0
    JNZ notFiring1
    CALL DidFire1Hit
    notFiring1:
    RET
FireGun1_Continue ENDP

DidFire1Hit PROC FAR
    CMP isFlying, 1
    JNZ didntHit1
    mov ax, Fly1PosX_strt
    CMP Fire1X, AX
    JC didntHit1
    mov ax, Fly1PosX_end
    CMP Fire1X, AX
    JNC didntHit1
    mov ax, Fly1PosY_strt
    CMP Fire1Y, AX
    JC didntHit1
    mov ax, Fly1PosY_end
    CMP Fire1Y, AX
    JNC didntHit1
    MOV Fire1Hit, 1
    CALL FlyObj1_Continue ;call it again when hit to delete it () draw white box
    CALL FlyObj2_Continue ;call it again when hit to delete it () draw white box
    MOV isFlying, 0 
    LEA BX, l11
    MOV DL, ColorCount
    MOV DH, 0
    MOV DI, DX
    DEC DI
    ADD [BX][DI], 1
    ADD P1_score, DL
    CMP P1_score, 99
    JC didntHit1
    MOV P1_score, 99
    didntHit1:
    RET
DidFire1Hit ENDP

DrawGun2 PROC FAR
    mov ax, @data
    mov ds, ax
    ;size of gun = 3x9
    ;Draw pixel
    mov bx, 0
    mov ah,0ch       ;Draw Pixel Command
    mov al,0Fh       ;Pixel color
    mov cx,gun2PrevX   ;Column
    mov dx,gun2PrevY   ;Row   
    ;loop to delete the old gun (draw white box)
    outer11:
        mov cx, gun2PrevX ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        cmp bh,4  ;if draw 3 rows then then the gun is completed
        jz exit11
        inc bh    ;outer counter
        ;same as inner1
        inner11:  
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,9 ;if you draw 3 columns jump to outer
        jnz inner11
        jz outer11
    exit11:
    mov bx, 0
    mov al,20h       ;Pixel color
    mov cx,gun2NewX   ;Column
    mov dx,gun2NewY   ;Row   
    outer21:
        mov cx, gun2NewX ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        cmp bh,4  ;if draw 3 rows then then the gun is completed
        jz exit21
        inc bh    ;outer counter
        ;same as inner1
        inner21:  
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,9 ;if you draw 3 columns jump to outer
        jnz inner21
        jz outer21
    exit21:
    mov ax, gun2NewX
    mov bx, gun2NewY
    mov gun2PrevX, ax ;move the new position to previous position
    mov gun2PrevY, bx
    ret
DrawGun2 ENDP     

FireGun2_initial PROC FAR
    mov ax, @data
    mov ds, ax
    cmp isFiring2, 0
    jnz alreadyFiring2
    mov ax, gun2PrevX
    add ax, 3
    mov bx, gun2PrevY
    sub bx, 3
    mov Fire2X, ax
    mov Fire2Y, bx
    mov isFiring2, 1
    mov Fire2Hit, 0
    alreadyFiring2:
    RET
FireGun2_initial ENDP


FireGun2_Continue PROC FAR
    mov ax, @data
    mov ds, ax
    cmp isFiring2, 1
    jnz notFiring2
    mov bx, 0
    mov ah,0ch       ;Draw Pixel Command
    mov al,0Fh       ;Pixel color
    mov cx,Fire2X   ;Column
    mov dx,Fire2Y   ;Row   
    ;loop to draw the new gun
    outer31:
        mov cx, Fire2X ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        cmp bh,3  ;if draw 3 rows then then the gun is completed
        jz exit31
        inc bh    ;outer counter
        ;same as inner1
        inner31:  
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,3 ;if you draw 3 columns jump to outer
        jnz inner31
        jz outer31
    exit31:
    cmp Fire2Y, 0
    jnz stillFiring2
    mov isFiring2, 0
    jmp notFiring2
    stillFiring2:
    sub Fire2Y, 1
    mov bx, 0
    mov al,20h       ;Pixel color
    mov cx,Fire2X   ;Column
    mov dx,Fire2Y   ;Row   
    outer41:
        mov cx, Fire2X ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        cmp bh,3  ;if draw 3 rows then then the gun is completed
        jz exit41
        inc bh    ;outer counter
        ;same as inner1
        inner41:  
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,3 ;if you draw 3 columns jump to outer
        jnz inner41
        jz outer41
    exit41:
    CMP Fire2Hit, 0
    JNZ notFiring2
    CALL DidFire2Hit
    notFiring2:
    RET
FireGun2_Continue ENDP

DidFire2Hit PROC FAR
    CMP isFlying, 1
    JNZ didntHit2
    mov ax, Fly2PosX_strt
    CMP Fire2X, AX
    JC didntHit2
    mov ax, Fly2PosX_end
    CMP Fire2X, AX
    JNC didntHit2
    mov ax, Fly2PosY_strt
    CMP Fire2Y, AX
    JC didntHit2
    mov ax, Fly2PosY_end
    CMP Fire2Y, AX
    JNC didntHit2
    MOV Fire2Hit, 1
    CALL FlyObj1_Continue
    CALL FlyObj2_Continue
    MOV isFlying, 0
    LEA BX, l21
    MOV DL, ColorCount
    MOV DH, 0
    MOV DI, DX
    DEC DI
    ADD [BX][DI], 1
    ADD P2_score, DL
    CMP P2_score, 99
    JC didntHit2
    MOV P2_score, 99
    didntHit2:
    RET
DidFire2Hit ENDP

FlyObj1_Continue PROC FAR
    mov ax, @data
    mov ds, ax
    cmp isFlying, 1
    jnz notFlying
    mov bx, 0
    mov ah,0ch       ;Draw Pixel Command
    mov al,0Fh       ;Pixel color
    mov cx, Fly1PosX_strt   ;Column
    mov dx, Fly1PosY_strt   ;Row   
    ;loop to draw the new gun
    outer5:
        mov cx, Fly1PosX_strt ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        cmp bh,15  ;if draw 3 rows then then the gun is completed
        jz exit5
        inc bh    ;outer counter
        ;same as inner1
        inner5:  
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,10 ;if you draw 3 columns jump to outer
        jnz inner5
        jz outer5
    exit5:
    cmp Fire1Hit, 0
    jnz notFlying
    cmp Fire2Hit, 0
    jnz notFlying
    cmp Fly1PosX_strt, 1
    jnc stillFlying
    CALL FlyObj2_Continue
    mov isFlying, 0
    jmp notFlying
    stillFlying:
    sub Fly1PosX_strt, 1
    mov bx, 0
    mov al, FlyColor       ;Pixel color
    mov cx, Fly1PosX_strt   ;Column
    mov dx, Fly1PosY_strt   ;Row   
    outer6:
        mov cx, Fly1PosX_strt ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        cmp bh,15  ;if draw 3 rows then then the gun is completed
        jz exit6
        inc bh    ;outer counter
        ;same as inner1
        inner6:  
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,10 ;if you draw 3 columns jump to outer
        jnz inner6
        jz outer6
    exit6:
    mov ax, Fly1PosX_strt
    add ax, 10
    mov Fly1PosX_end, ax

    mov ax, Fly1PosY_strt
    add ax, 15
    mov Fly1PosY_end, ax
    notFlying:
    RET
FlyObj1_Continue ENDP


FlyObj2_Continue PROC FAR
    mov ax, @data
    mov ds, ax
    cmp isFlying, 1
    jnz notFlying1
    mov bx, 0
    mov ah,0ch       ;Draw Pixel Command
    mov al,0Fh       ;Pixel color
    mov cx, Fly2PosX_strt   ;Column
    mov dx, Fly2PosY_strt   ;Row   
    ;loop to draw the new gun
    outer51:
        mov cx, Fly2PosX_strt ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        cmp bh,15  ;if draw 3 rows then then the gun is completed
        jz exit51
        inc bh    ;outer counter
        ;same as inner1
        inner51:  
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,10 ;if you draw 3 columns jump to outer
        jnz inner51
        jz outer51
    exit51:
    cmp Fire1Hit, 0
    jnz notFlying1
    cmp Fire2Hit, 0
    jnz notFlying1
    cmp Fly2PosX_strt, 161
    jnc stillFlying1
    mov isFlying, 0
    jmp notFlying1
    stillFlying1:
    sub Fly2PosX_strt, 1
    mov bx, 0
    mov al, FlyColor       ;Pixel color
    mov cx, Fly2PosX_strt   ;Column
    mov dx, Fly2PosY_strt   ;Row   
    outer61:
        mov cx, Fly2PosX_strt ;X position of new gun
        mov bl, 0 ;inner counter
        inc dx    ;increment row
        cmp bh,15  ;if draw 3 rows then then the gun is completed
        jz exit61
        inc bh    ;outer counter
        ;same as inner1
        inner61:  
        int 10h  ;draw pixel
        inc cx   ;inc column
        inc bl   ;inc counter
        cmp bl,10 ;if you draw 3 columns jump to outer
        jnz inner61
        jz outer61
    exit61:
    mov ax, Fly2PosX_strt
    add ax, 10
    mov Fly2PosX_end, ax

    mov ax, Fly2PosY_strt
    add ax, 15
    mov Fly2PosY_end, ax
    notFlying1:
    RET
FlyObj2_Continue ENDP

;description
FlyObj_initial PROC FAR
    mov ax, @data
    mov ds, ax
    cmp isFlying, 0
    jnz alreadyFlying
    cmp ColorCount, 5
    jnz CorrectColor
    mov ColorCount, 0
    CorrectColor:
    mov Fly1PosX_strt, 150
    mov Fly1PosY_strt, 3
    mov Fly2PosX_strt, 310
    mov Fly2PosY_strt, 3
    mov al, ColorCount
    mov bx, offset arr_color
    xlat
    mov FlyColor, al
    mov isFlying, 1
    mov Fire1Hit, 0
    mov Fire2Hit, 0
    inc ColorCount
    alreadyFlying:
    RET
FlyObj_initial ENDP
END