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
ENDM
DrawRegisters MACRO
    mov ah,0
    mov al,13h
    int 10h

    mov xpos,10
    mov ypos,20
    

    Rectangel8:
        Rectangel xpos,ypos
        add xpos,60
        Rectangel xpos,ypos
        add ypos,20
        mov xpos,10
        dec counterDrawRegisters
        cmp counterDrawRegisters,0
    jnz Rectangel8
ENDM

.DATA
xpos dw 10
ypos dw 10
counterDrawRegisters db 4
.CODE
MAIN PROC FAR
MOV AX, @DATA
MOV DS, AX
DrawRegisters


HLT
MAIN ENDP
END MAIN