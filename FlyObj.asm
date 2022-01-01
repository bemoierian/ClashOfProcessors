public flying
public varCount

drawrectanglemoving  macro  col,y1,x1,y2,x2
local outer,inner
    ;DRAW ONE RECTANGEL
    mov dx,y1
    mov al,col ;COLOR
    mov ah,0ch ;DRAW PIXEL 
    ;mov bx,x2
    mov bh,0
    mov si,x2
    mov cx,y2
    mov di,cx
        outer:
        mov cx,x1
            inner:
            int 10h
            inc cx
            cmp cx,si
            jnz inner
        inc dx
        cmp dx,di
        jnz outer
endm drawrectanglemoving

verticalline macro y,x,max,color
    LOCAL back
    ;draw pixles untill the line is drawn

    mov cx,x ;column
    mov dx,y;row
    mov al,color ;black color
    mov ah,0ch ;Draw Pixel Command 
    mov bh,0
    back:
    int 10h
    inc dx
    cmp dx,max
    jnz back
endm verticalline

; add your code here  
.MODEL SMALL
.DATA
;first flying object coordinates
 y1i dw 0
 y2i dw 15
 x1i dw 0
 x2i dw 10
 ;second flying object coordinates
 y1ii dw 0
 y2ii dw 15
 x1ii dw 161
 x2ii dw 171
 ;coloring
 varCount db 0 ;index for color array
 varColor db 0 ;for color
 arr_color db 0ah,09h,0ch,0dh,0eh

.code 
flying PROC far
     
    mov ax,@data
    mov ds,ax  

    ; mov ah,0   ;enter graphics mode
    ; mov al,13h 
    ;mov ax,0013h
    ;int 10h
    mov bx,offset arr_color
    mov al,varCount
    XLAT
    mov varColor,al
 drawrectanglemoving varColor,y1i,x1i,y2i,x2i 
 drawrectanglemoving varColor,y1ii,x1ii,y2ii,x2ii
        n:
        ;the first flying object
            verticalline y1i,x1i,y2i,0 ;draw black line
            verticalline y1i,x2i,y2i,varColor ;draw red line
            inc x1i
            inc x2i
            ;second flying object
            verticalline y1ii,x1ii,y2ii,0 ;draw black line
            verticalline y1ii,x2ii,y2ii,varColor ;draw red line
            inc x1ii
            inc x2ii

            cmp x2i,160
            jz close
            
            cmp x2ii,320
            jz close
            ;push cx
            ;to delay the flying object
            mov cx,0ff00h
            ldummy:
            loop ldummy
            ;pop cx    
            jmp n
           
    close: ;drawing black rectangle at end of the screen
    mov dx,y1i
    mov al,0 ;COLOR
    mov ah,0ch ;DRAW PIXEL 
    mov bh,0
    mov si,x2i
    mov cx,y2i
    mov di,cx
        outer1:
        mov cx,x1i
            inner1:
            int 10h
            inc cx
            cmp cx,si
            jnz inner1
        inc dx
        cmp dx,di
        jnz outer1
    mov x1i,0
    mov x2i,10
    mov dx,y1i
    ;;;;;;;;;;;;;;;;;;;;;;;;;
    mov al,0 ;COLOR
    mov ah,0ch ;DRAW PIXEL 
    mov bh,0
    mov si,x2ii
    mov cx,y2ii
    mov di,cx
        outer2:
        mov cx,x1ii
            inner2:
            int 10h
            inc cx
            cmp cx,si
            jnz inner2
        inc dx
        cmp dx,di
        jnz outer2
    mov x1ii,161
    mov x2ii,171
    jmp n   
    ret
flying endp
end