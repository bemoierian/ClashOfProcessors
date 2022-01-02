PUBLIC printwin1,printwin2,winner
EXTRN BUFFNAME1:BYTE, BufferData1:BYTE
EXTRN BUFFNAME2:BYTE, BufferData2:BYTE
EXTRN AxVar1:WORD,BxVar1:WORD,CxVar1:WORD,DxVar1:WORD,SiVar1:WORD,DiVar1:WORD,SpVar1 :WORD,BpVar1 :WORD
EXTRN AxVar2:WORD,BxVar2:WORD,CxVar2:WORD,DxVar2:WORD,SiVar2:WORD,DiVar2:WORD,SpVar2 :WORD,BpVar2 :WORD
EXTRN P1_score:BYTE,P2_score:BYTE,target:BYTE
PUBLIC CheckWinner
;;;;;;;;;;;;;;;;;;;;;;;;;;;
setcursor macro p
    mov ah,2
    mov dx,p ;move cursorposition to dx
    int 10h
endm setcursor
;------------------------------------------------------
.286
.MODEL SMALL
.STACK 64
.DATA
;--------------------------win--------------------------
;---------print winner---------------
printwin1 DB 'winner is player 1 ','$'
printwin2 DB 'winner is player 2 ','$'

winner db 0 ;flag of winner in the game
;------------------------------------

.CODE
CheckWinner PROC FAR
    mov ax, @data
    mov ds, ax
    ;;;;;;;;;;;;;;;;;;
    cmp P1_score,0
    jz setwinner2
    cmp P2_score,0
    jz setwinner1
    mov si,offset AxVar1
    mov cx,8 
    w1:
    mov dl,target
    cmp [si],dl
    jz setwinner2
    add si,2
    dec cx
    cmp cx,0
    jnz w1

    mov si,offset AxVar2
    mov cx,8
    w2:
    mov dl,target
    cmp [si],dl
    jz setwinner1
    add si,2
    dec cx
    cmp cx,0
    jnz w2  
    jmp byebye


    setwinner1:
    mov winner,1
    jmp byebye
    setwinner2:
    mov winner,2
    

  byebye:
      cmp winner,1
          jz print1 

          cmp winner,2
            jz print2 

            jmp yes

            
    print1:
    
  ; mov ax,0600h
  ; mov bh,07
  ; mov cx,0
  ; mov dx,184FH
  ; int 10h
    mov ah,0
    mov al,3h
    int 10h
  setcursor 0010d
    mov ah,09
    mov dx,offset printwin1
    int 21h

  setcursor 0110d
  mov ah,09
  mov dx,offset BUFFNAME1
  int 21h
  jmp No
  print2:

  mov ax,0600h
  mov bh,07
  mov cx,0
  mov dx,184FH
  int 10h
  mov ah,0
  mov al,3h
  int 10h
  setcursor 0010d
  mov ah,09
  mov dx,offset printwin2
  int 21h
    setcursor 0110d
  mov ah,09
  mov dx,offset BUFFNAME2
  int 21h
  jmp No
        yes:
    RET
    No: 
    MOV AH, 04CH    ;TO RETURN TO THE OPERATING SYSTEM
    INT 21H 
    ret
CheckWinner ENDP
END



