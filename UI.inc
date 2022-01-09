;-------------------------------------Main Screen--------------------------------------
display_string_main MACRO mes,x,y
    MOV  DL, x  ;COLUMN
    MOV  DH, y   ;ROW
    MOV  BH, 0    ;DISPLAY PAGE
    MOV  AH, 02H  ;SETCURSORPOSITION
    INT  10H
    MOV AH, 9
    MOV DX, OFFSET mes
    INT 21H
ENDM display_string_main 

draw_mainscreen MACRO str1, str2, str3
    LOCAL BACK,INC_LOOP,EXIT
    ;display the 3 sentences
    display_string_main str1,5h,5h    
    display_string_main str2,5h,7h    
    display_string_main str3,5h,9h    
    
;     ;display dashed line (chat section)
;     mov cx,0 ;Column
;     MOV dx,175D ;Row 
    
;     BACK:
;         MOV al,0fh ;Pixel color
;         MOV ah,0ch ;Draw Pixel Command
;         int 10h 
;         MOV BL,2H
;         MOV AX,CX
;         DIV BL
;         CMP AH,1H
;         JZ INC_LOOP   
;         inc cx
;         cmp cx,13Fh        ;319d
;         jAE EXIT

;     INC_LOOP:
;         INC CX
;         JMP BACK
; EXIT:  

ENDM draw_mainscreen 
;--------------------------------------------------------------------------------------


DisplayName macro P2_name
    mov dl,5
    mov dh,20
    setcursor dx
    mov ah,09
    mov dx,offset BUFFNAME
    int 21h
    mov dl,50
    mov dh,20
    setcursor dx
    mov dx,offset P2_name
    int 21h
endm DisplayName  


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
    ; setcursor  p ;setcursor position
    setcursor p

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

disp macro  p,l,c
     setcursor  p ;setcursor position

mov bl,10
mov ah,0  
mov al,l   
div bl 
push ax
add al,30h
;print 

    mov ah,9
    mov bh,0
    ;mov al,dl ;letter
    mov cx,1 ;count
    mov bl,c ;color
    int 10h
pop ax 
mov al,ah
add al,30H
    mov dx,p
    inc dx
setcursor dx
    ;print small
    mov ah,9
    mov bh,0
    ;mov al,dl ;letter
    mov cx,1 ;count
    mov bl,c ;color
    int 10h

    ;newcode
    ;mov ah,2
    ;mov dl,l
    ;int 21h
endm disp

getcursor macro  ;getcursor position
    mov ah,3h 
    mov bh,0h 
    int 10h
endm getcursor


drawrectanglewith macro   x,y,color,horizontallen,verticallen,p,l,c
  
drawrectangle x,y,color,horizontallen,verticallen



disp p,l,c

endm drawrectanglewith


;set cursor 
setcursor1 MACRO x,y
mov ah,2
mov bh,0
mov dl,x
mov dh,y
int 10h
ENDM setcursor1



;cleartop
cleartop MACRO
   
mov ax,0600h
mov bh,07h
mov ch,1   
mov cl,0     
mov dh,11   
mov dl,79
int 10h 
  
ENDM cleartop 

;clearbottom
clearbottom MACRO
   
mov ax,0600h
mov bh,07h
mov ch,14  
mov cl,0      
mov dh,22
mov dl,79
int 10h 
  
ENDM clearbottom