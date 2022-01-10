
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
PUBLIC line,endchat,pre,thechatended 
PUBLIC StartChat
PUBLIC yps,xps,ypr,xpr
PUBLIC IsInGameChat
PUBLIC InGameChat
EXTRN BUFFNAME1:BYTE
EXTRN BUFFNAME2:BYTE

EXTRN Player:BYTE
EXTRN sendVarL:BYTE
EXTRN ReceiveVarL:BYTE

.MODEL HUGE
.STACK 64
.DATA
 
value db ?     ;value which will be sent or recieved by user
yps db 1    ;y position of sending initial will be 0
xps db 0     ;x position of sending initail wiil be 0
xpr db 0     ;x position of recieving initial will be 0
ypr db 0fh   ;y position of recieving initial wil be D because of lower part of screen                                          
IsInGameChat db 0
IsChating_p1 db 0
IsChating_p2 db 0
chatxposP1 db 0
chatxposP2 db 0

line db 80 dup('-'),'$'
endchat db 'to end chat with ','$'
name1 db 'norhan ','$'
name2 db 'nono ','$'
pre db 'press f3','$'
thechatended db'the chat is ended ! ','$'

.CODE
;description
StartChat PROC FAR
  mov ax, @data
  mov ds, ax
  ;text mode
  mov ah, 0     
  mov al, 3
  int 10h

  ;top half
  mov ax,0600h        
  mov bh,07h     ; normal video attribute         
  mov ch,1       ; top y
  mov cl,0       ; top x
  mov dh,12      ; bottom y
  mov dl,79      ; bottom x
  int 10h           

  mov ah, 9
  mov dx, offset BUFFNAME1
  int 21h

  ;draw the line 
  setcursor1 0,12
  mov ah, 9
  mov dx, offset line
  int 21h
  ;bottom half
  mov ax,0600h    ;  
  mov bh,07h      ; normal video attribute         
  mov ch,13       ; top y
  mov cl,0        ; top x
  mov dh,24       ; bottom y
  mov dl,79       ; bottom x
  int 10h   

  setcursor1 0,13
  mov ah, 9
  mov dx, offset BUFFNAME2
  int 21h

      ;draw the line 
  setcursor1 0,23
  mov ah, 9
  mov dx, offset line
  int 21h


  setcursor1 0,24
  mov ah, 9
  mov dx, offset endchat
  int 21h

  setcursor1 19,24
  mov ah, 9
  mov dx, offset BUFFNAME2
  int 21h

  setcursor1 35,24
  mov ah, 9
  mov dx, offset pre
  int 21h
  call chatmodule
  RET  
StartChat ENDP
 

chatmodule proc far
mov ax,@data
     mov ds,ax

chatcon:


mov ah,1    ;check if a key is pressed
int 16h

jz   R ;jmp to recieving mode
jnz  send    ;jmp to send mode
ex5:jmp shutchat

send:

mov ah,0   ;clear  buffer
int 16h 

mov value,al  ; save the key ascii code in al
cmp ah,3dh    ;save scan code in ah
jz isf3

cmp al,0dh    ; check if the key is enter jump no a new line endl
jnz contS
jz endlS
ex2:jmp shutchat
R:jmp recieve

isf3: 
mov value,3dh
jmp dispS
endlS:
CMP yps,11  ;clear screan if y is out of range
jz  n1
jnz n2
n1:cleartop
mov xps,0             ;set the cursor  to 0,1
mov yps,1
setcursor1 xps,yps
jmp dispS

n2:inc yps   ;if enter 
mov xps,0

contS:
setcursor1 xps,yps  ; setting the cursor
CMP xps,79           ; if x is out of range check y
JZ checkY
jnz dispS

checkY:CMP yps,11   ;if y is out of range in botton clear upper screan
JNZ dispS
cleartop
mov xps,0             ;set the cursor  to 0,1
mov yps,1
setcursor1 xps,yps

jmp dispS              ; if well print
 


dispS:
mov ah,2          ; print the char on sending screan
mov dl,value
int 21h
  ;send the char to the other screan
mov dx,3FDH 		; Line Status Register
AGAIN:In al , dx 	;Read Line Status
test al , 00100000b
jz recieve                    ;Not empty
mov dx , 3F8H		; Transmit data register
mov al,value        ; put the data into al

out dx , al         ; sending the data
call getScursor        ; get the cursor 
cmp value,3dh    ;scan code of f3
jz ex
jmp chatcon       ;continue chating



ex:jmp shutchat

S:jmp send

recieve:

mov ah,1            ;check if there is key pressed then go to the sending mode
int 16h
jnz S

mov dx , 3FDH		; Line Status Register
in al , dx 
test al , 1
JZ recieve           


mov dx , 03F8H
in al , dx 
mov value,al              
CMP value,3dh
jz ex

CMP value,0Dh             ;check if the key is enter
JNZ contR
JZ endlR


endlR:
cmp ypr,22
JZ n3
jnz n4
n3:
clearbottom
mov xpr,0
mov ypr,14
setcursor1 xpr,ypr
jmp dispR

n4:
inc ypr
mov xpr,0

contR:
setcursor1 xpr,ypr
CMP xpr,79
JZ checkYR
jnz  dispR

checkYR: cmp ypr,22
jnz dispR
clearbottom
mov xpr,0
mov ypr,14
setcursor1 xpr,ypr

dispR:
mov ah,2
mov dl,value
int 21h

call getRcursor 
jmp chatcon

shutchat:
      ret       
chatmodule endp




;get sending position
getScursor proc far
mov ax,@data
mov ds,ax 
mov ah,3h
mov bh,0h
int 10h
mov xps,dl
mov yps,dh
ret
getScursor endp

;get receving position
getRcursor proc far
mov ax,@data
mov ds,ax 

mov ah,3h
mov bh,0h
int 10h
mov xpr,dl
mov ypr,dh
ret 
getRcursor endp




;description
InGameChat PROC FAR
  mov ax,@data
  mov ds,ax
  cmp player,1
        jnz chat_player2
            ;sending player 1
            cmp sendVarL,0f9h
            jnz print_if_player1_sending
                cmp IsChating_p1 , 0
                jnz reset_chating_player1_S
                    mov IsChating_p1,1
                    jmp receiving_for_P1
                reset_chating_player1_S:
                    mov IsChating_p1,0
                    jmp receiving_for_P1

                print_if_player1_sending:
                cmp IsChating_p1,1
                jnz receiving_for_P1
                    ;here to print sent chat at player 1
                    cmp sendVarL,'/'
                    jz receiving_for_P1
                    mov ah,2
                    mov bh,0
                    mov dl,chatxposP1
                    mov dh,22
                    int 10h
                    mov ah,2
                    mov dl,sendVarL
                    int 21h
                    add chatxposP1,1
                    jmp SetGFlag
            ;receiving player 1
            receiving_for_P1:
            cmp ReceiveVarL,0f9h
            jnz print_if_player1_receiving
                cmp IsChating_p2 , 0
                jnz reset_chating_player1_R
                    mov IsChating_p2,1
                    jmp SetGFlag
                reset_chating_player1_R:
                    mov IsChating_p2,0
                    jmp SetGFlag

                print_if_player1_receiving:
                cmp IsChating_p2,1
                jnz endGameChat
                    ;here to print rec chat at player 1
                    cmp ReceiveVarL,'/'
                    jz SetGFlag
                    mov ah,2
                    mov bh,0
                    mov dl,chatxposP2
                    mov dh,23
                    int 10h
                    mov ah,2
                    mov dl,ReceiveVarL
                    int 21h
                    inc chatxposP2
                    jmp SetGFlag
        ;PLAYER2----------------------------------------
        chat_player2:
            ;sending player 2
            cmp sendVarL,0f9h
            jnz print_if_player2_sending
                cmp IsChating_p2 , 0
                jnz reset_chating_player2_S
                    mov IsChating_p2,1
                    jmp receiving_for_P2
                reset_chating_player2_S:
                    mov IsChating_p2,0
                    jmp receiving_for_P2

                print_if_player2_sending:
                cmp IsChating_p2,1
                jnz receiving_for_P2
                ;here to print sent chat at player 2
                    cmp sendVarL,'/'
                    jz receiving_for_P2
                    mov ah,2
                    mov bh,0
                    mov dl,chatxposP2
                    mov dh,23
                    int 10h
                    mov ah,2
                    mov dl,sendVarL
                    int 21h
                    inc chatxposP2
                    jmp SetGFlag
            ;receiving player 2
            receiving_for_P2:
            cmp ReceiveVarL,0f9h
            jnz print_if_player2_receiving
                cmp IsChating_p1 , 0
                jnz reset_chating_player2_R
                    mov IsChating_p1,1
                    jmp SetGFlag
                reset_chating_player2_R:
                    mov IsChating_p1,0
                    jmp SetGFlag

                print_if_player2_receiving:
                cmp IsChating_p1,1
                jnz endGameChat
                    ;here to print rec chat at player 2
                    cmp ReceiveVarL,'/'
                    jz SetGFlag
                    mov ah,2
                    mov bh,0
                    mov dl,chatxposP1
                    mov dh,22
                    int 10h
                    mov ah,2
                    mov dl,ReceiveVarL
                    int 21h
                    add chatxposP1,1
                    jmp SetGFlag

                    SetGFlag:
                    mov IsInGameChat, 1
                    endGameChat:
  RET
InGameChat ENDP
end
;set cursor 






