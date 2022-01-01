;-----------------Called in clash.asm------------------
PUBLIC DrawGun, FireGun_initial, FireGun_Continue, FlyObj_Continue, FlyObj_initial
PUBLIC gun1PrevX,gun1PrevY,gun1NewX,gun1NewY
PUBLIC l11,c11,l12,c12,l13,c13,l14,c14,l15,c15,l21,c21,l22,c22,l23,c23,l24,c24,l25,c25
;------------------------------------------------------
.286
.MODEL SMALL
.STACK 64
.DATA
;--------------------------Gun--------------------------
gun1PrevX dw 80
gun1PrevY dw 150
gun1NewX dw 80
gun1NewY dw 150

gun2PrevX dw 240
gun2PrevY dw 150
gun2NewX dw 240
gun2NewY dw 150
;------------------------Gun fire-----------------------
FireX dw 0
FireY dw 0
isFiring db 0
;----------------------Flying objects-------------------
FlyPosX_strt dw 150
FlyPosY_strt dw 3
FlyPosX_end dw 0
FlyPosY_end dw 0
FlyColor db 04h
isFlying db 0
FireHit db 0
ColorCount db 0 ;index for color array
arr_color db 0ah,09h,0ch,0dh,0eh
;-------------------scores values and colors --------------
l11 db '1'
c11 db 0ah
l12 db '1'
c12 db 9h
l13 db '1'
c13 db 0ch
l14 db '1'
c14 db 0eh
l15 db '1'
c15 db 0dh
;-----------------
l21 db '1'
c21 db 0ah
l22 db '1'
c22 db 9h
l23 db '1'
c23 db 0ch
l24 db '1'
c24 db 0eh
l25 db '1'
c25 db 0dh
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
    mov cx,gun1PrevX   ;Column
    mov dx,gun1PrevY   ;Row   
    ;loop to draw the new gun
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
DrawGun ENDP     

FireGun_initial PROC FAR
    mov ax, @data
    mov ds, ax
    cmp isFiring, 0
    jnz alreadyFiring
    mov ax, gun1PrevX
    add ax, 3
    mov bx, gun1PrevY
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
    CALL DidFireHit
    notFiring:
    RET
FireGun_Continue ENDP

DidFireHit PROC FAR
    mov ax, FlyPosX_strt
    CMP FireX, AX
    JC didntHit
    mov ax, FlyPosX_end
    CMP FireX, AX
    JNC didntHit
    mov ax, FlyPosY_strt
    CMP FireY, AX
    JC didntHit
    mov ax, FlyPosY_end
    CMP FireY, AX
    JNC didntHit
    MOV isFlying, 0
    


    didntHit:
    RET
DidFireHit ENDP


FlyObj_Continue PROC FAR
    mov ax, @data
    mov ds, ax
   
    mov bx, 0
    mov ah,0ch       ;Draw Pixel Command
    mov al,0Fh       ;Pixel color
    mov cx, FlyPosX_strt   ;Column
    mov dx, FlyPosY_strt   ;Row   
    ;loop to draw the new gun
    outer5:
        mov cx, FlyPosX_strt ;X position of new gun
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
    cmp isFlying, 1
    jnz notFlying
    cmp FlyPosX_strt, 1
    jnc stillFlying
    mov isFlying, 0
    jmp notFlying
    stillFlying:
    sub FlyPosX_strt, 1
    mov bx, 0
    mov al, FlyColor       ;Pixel color
    mov cx, FlyPosX_strt   ;Column
    mov dx, FlyPosY_strt   ;Row   
    outer6:
        mov cx, FlyPosX_strt ;X position of new gun
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
    mov ax, FlyPosX_strt
    add ax, 10
    mov FlyPosX_end, ax

    mov ax, FlyPosY_strt
    add ax, 15
    mov FlyPosY_end, ax
    notFlying:
    RET
FlyObj_Continue ENDP

;description
FlyObj_initial PROC FAR
    mov ax, @data
    mov ds, ax
    cmp isFlying, 0
    jnz alreadyFlying
    mov FlyPosX_strt, 150
    mov FlyPosY_strt, 3
   
    mov al, ColorCount
    mov bx, offset arr_color
    xlat
    mov FlyColor, al
    mov isFlying, 1
    inc ColorCount
    cmp ColorCount, 5
    jnz alreadyFlying
    mov ColorCount, 0
    alreadyFlying:
    RET
FlyObj_initial ENDP
END