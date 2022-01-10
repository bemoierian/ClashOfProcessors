PUBLIC power_up3_player1,power_up1_player1,power_up2_player1,power_up6_player1
PUBLIC power_up3_player2,power_up1_player2,power_up2_player2,power_up6_player2
PUBLIC power_up4_player1,power_up4_player2
PUBLIC power_up5_player1,power_up5_player2
EXTRN P1_score:BYTE,P2_score:BYTE,Source:BYTE,forbiddin_char1:BYTE,forbiddin_char2:BYTE,DestinationValue1:WORD,DestinationValue2:WORD,External:WORD
EXTRN AxVar1:WORD,BxVar1:WORD,CxVar1:WORD,DxVar1:WORD,SiVar1:WORD,DiVar1:WORD,SpVar1 :WORD,BpVar1 :WORD
EXTRN AxVar2:WORD,BxVar2:WORD,CxVar2:WORD,DxVar2:WORD,SiVar2:WORD,DiVar2:WORD,SpVar2 :WORD,BpVar2 :WORD
EXTRN chosen_level:BYTE,target:WORD
EXTRN execute1:FAR
EXTRN execute2:FAR
EXTRN ClearCommandString:FAR
EXTRN SwitchTurn:far
EXTRN CLEAR_TO_EXECUTE_1:BYTE
EXTRN CLEAR_TO_EXECUTE_2:BYTE
.model HUGE
.data
;power up 3
powerup3_isused_player1 db 0h
powerup3_isused_player2 db 0h
;power uo 4
line_num1 DB 0
stuck_value1 DB 0
src_value1  DW  0

line_num2 DB 0
stuck_value2 DB 0
src_value2  DW  0
;power up5
powerup5_isused_player1 db 0h
powerup5_isused_player2 db 0h
;POWER UP 6
digit db '$'
number dw 0
powerup6_isused_player1 db 0h
powerup6_isused_player2 db 0h
exist db 0

.code
;POWER UP 1
power_up1_player1 PROC FAR
    ;CALL EXCUTE FOR PLAYER 1
    cmp P1_score,5
    jb notP11
    call execute2
    CMP CLEAR_TO_EXECUTE_2, 0
    JNZ finish_execute11
    cmp P1_score,5
    jz finish_execute11
    DEC P1_score
    finish_execute11:

    CALL ClearCommandString
    CALL SwitchTurn
    cmp chosen_level,2
    jz notP11
    SUB P1_score,5
    notP11:
    ret
    ;call execute1
power_up1_player1 ENDP

power_up1_player2 PROC FAR
    cmp P2_score,5
    jb notP12
    ;CALL EXCUTE FOR PLAYER 2
    CALL execute1
    CMP CLEAR_TO_EXECUTE_1, 0
    JNZ finish_execute12
    cmp P2_score,5
    jz finish_execute12
    DEC P2_score
    finish_execute12:

    CALL ClearCommandString
    CALL SwitchTurn
    cmp chosen_level,2
    jz notP12
    SUB P2_score,5
    notP12:
    ret
power_up1_player2 ENDP

;POWER UP 2
power_up2_player1 PROC FAR
    cmp P1_score,3
    jb notP21
    ;CALL EXCUTE FOR PLAYER 1
    call execute1
    ;CALL EXCUTE FOR PLAYER 2
    CALL execute2
    CMP CLEAR_TO_EXECUTE_2, 0
    JNZ finish_execute21
    cmp P1_score,3
    jz finish_execute21
    DEC P1_score
    finish_execute21:
    CALL ClearCommandString
    CALL SwitchTurn
    SUB P1_score,3
    notP21:
    ret
power_up2_player1 ENDP

power_up2_player2 PROC FAR
    cmp P2_score,3
    jb notP22
    ;CALL EXCUTE FOR PLAYER 1
    call execute1
    ;CALL EXCUTE FOR PLAYER 2
    CALL execute2
    CMP CLEAR_TO_EXECUTE_1, 0
    JNZ finish_execute22
    cmp P2_score,3
    jz finish_execute22
    DEC P2_score
    finish_execute22:
    CALL ClearCommandString
    CALL SwitchTurn
    SUB P2_score,3
    notP22:
    ret
power_up2_player2 ENDP

;power up 3
power_up3_player1 PROC FAR 
    cmp P1_score,8
    jb P31
    cmp powerup3_isused_player1,1h
    jz used_before31  
    ; mov dl,1 ;SET THE CRSR
    ; mov dh,20
    ; mov ah,2
    ; int 10h
   CHECK1: mov ah,1
   int 16h
   jz CHECK1
   mov ah,0
   int 16h
    ; mov ah,1
    ; int 21h ;READ THE CHAR
    mov forbiddin_char1,al ;CHANGE THE FORBIDDEN CHAR
    CALL SwitchTurn
    sub P1_score,8 ;sub from the score
    mov powerup3_isused_player1,1h ;set used
used_before31:
    ; mov dl,1 ;set the crsr 
    ; mov dh,20
    ; mov ah,2
    ; int 10h
    ; mov ah,2 ;print space
    ; mov dl,20h
    ; int 21h
    P31:
    ret
power_up3_player1 ENDP 

power_up3_player2 PROC FAR
    cmp P2_score,8
    jb notP32
    cmp powerup3_isused_player2,1h
    jz used_before32  
    ; mov dl,65 
    ; mov dh,20
    ; mov ah,2
    ; int 10h
    CHECK2: 
    mov ah,1
    int 16h
    jz CHECK2
    mov ah,0
    int 16h
    mov ah,1
    int 21h
    mov forbiddin_char2,al
    CALL SwitchTurn
    sub P2_score,8h 
    mov powerup3_isused_player2,1h
    used_before32:
    ; mov dl,65 
    ; mov dh,20
    ; mov ah,2
    ; int 10h
    ; mov ah,2
    ; mov dl,20h
    ; int 21h
    notP32:
    ret
power_up3_player2 ENDP
;power up 4
power_up4_player1 PROC FAR
    cmp P1_score,2
    jb P41
    MOV BX,DestinationValue1 ;SOURCE VALUE OF THE FIRST PLAYER
    MOV DX,[BX]
    mov src_value1,DX
    ;take line number
    mov dl,1 ;SET THE CRSR
    mov dh,20
    mov ah,2
    int 10h
    ; mov ah,1 ;read one char from the user and put it in al
    ; int 21h 
    ; mov line_num1,al  
    ; mov ah,1 ;read one char from the user and put it in al
    ; int 21h 
    ; mov stuck_value1,al 
    noline:
    mov ah,1
    int 16h
    jz noline 
    mov ah,0
    int 16h
    mov line_num1,al
    nokey:
    mov ah,1
    int 16h
    jz nokey
    mov stuck_value1,al 
;stuck_value one or zero
cmp stuck_value1,31h
jz stuck_at_one

cmp stuck_value1,30h
jz stuck_at_zero
 
;___________________________________________________________________________
;if stuck at one or with 00-1-00
stuck_at_one: 
cmp line_num1,30h ;0
jz L10
cmp line_num1,31h
jz L11
cmp line_num1,32h
jz L12
cmp line_num1,33h
jz L13 
cmp line_num1,34h
jz L14 
cmp line_num1,35h
jz L15 
cmp line_num1,36h
jz L16 
cmp line_num1,37h
jz L17 
cmp line_num1,38h
jz L18
cmp line_num1,39h
jz L19
cmp line_num1,61h  ;a,10
jz L1A           
cmp line_num1,62h
jz L1B 
cmp line_num1,63h
jz L1C 
cmp line_num1,64h
jz L1D 
cmp line_num1,65h
jz L1E 
cmp line_num1,66h
jz L1F 
;_______________________________________________________________________________________
;if stuck at zero and with 11-0-11
stuck_at_zero: 
cmp line_num1,30h
jz L00
cmp line_num1,31h
jz L01
cmp line_num1,32h
jz L02
cmp line_num1,33h
jz L03 
cmp line_num1,34h
jz L04 
cmp line_num1,35h
jz L05 
cmp line_num1,36h
jz L06 
cmp line_num1,37h
jz L07 
cmp line_num1,38h
jz L08
cmp line_num1,39h
jz L09
cmp line_num1,61h
jz L0A 
cmp line_num1,62h
jz L0B 
cmp line_num1,63h
jz L0C 
cmp line_num1,64h
jz L0D 
cmp line_num1,65h
jz L0E 
cmp line_num1,66h
jz L0F 

;_________________________________________________________________________________________
;if stuck at one or with 00-1-00

L10:or src_value1,0001h
    jmp exit
L11:or src_value1,0002h
    jmp exit
L12:or src_value1,0004h         
    jmp exit
L13:or src_value1,0008h
    jmp exit 
L14:or src_value1,0010h
    jmp exit
L15:or src_value1,0020h
    jmp exit
L16:or src_value1,0040h
    jmp exit
L17:or src_value1,0080h
    jmp exit 
L18:or src_value1,0100h
    jmp exit
L19:or src_value1,0200h
    jmp exit
L1A:or src_value1,0400h
    jmp exit
L1B:or src_value1,0800h
    jmp exit 
L1C:or src_value1,1000h
    jmp exit
L1D:or src_value1,2000h
    jmp exit
L1E:or src_value1,4000h
    jmp exit
L1F:or src_value1,8000h
    jmp exit 
;_____________________________________________________________________________  
 ;if stuck at zero and with 11-0-11
   
L00:and src_value1,0FFFEH
    jmp exit
L01:and src_value1,0FFFDH
    jmp exit
L02:and src_value1,0FFFBH
    jmp exit
L03:and src_value1,0FFF7H
    jmp exit 
L04:and src_value1,0FFEFH
    jmp exit
L05:and src_value1,0FFDFH
    jmp exit
L06:and src_value1,0FFBFH
    jmp exit
L07:and src_value1,0FF7FH
    jmp exit 
L08:and src_value1,0FEFFH
    jmp exit
L09:and src_value1,0FDFFH
    jmp exit
L0A:and src_value1,0FBFFH
    jmp exit 
L0B:and src_value1,0F7FFH
    jmp exit
L0C:and src_value1,0EFFFH
    jmp exit
L0D:and src_value1,0DFFFH
    jmp exit
L0E:and src_value1,0BFFFH
    jmp exit
L0F:and src_value1,07FFFH
    jmp exit 
;_____________________________________________________________________________    
exit:
    ; mov dl,1 ;SET THE CRSR
    ; mov dh,20
    ; mov ah,2
    ; int 10h
    ; mov ah,2 ;print space
    ; mov dl,20h
    ; int 21h
    ; mov dl,2 ;SET THE CRSR
    ; mov dh,20
    ; mov ah,2
    ; int 10h
    ; mov ah,2 ;print space
    ; mov dl,20h
    ; int 21h
    ;CALL SwitchTurn
    mov dx,src_value1
    mov BX,DestinationValue1
    mov [BX],dx
    sub P1_score,2h 
    P41:
    ret
power_up4_player1 ENDP 

power_up4_player2 PROC FAR  
    cmp P2_score,2
    jb P42
    MOV BX,DestinationValue2 ;SOURCE VALUE OF THE FIRST PLAYER
    MOV DX,[BX]
    MOV src_value2,DX
    ;take line number
    mov dl,65 
    mov dh,20
    mov ah,2
    int 10h
    ; mov ah,1 ;read one char from the user and put it in al
    ; int 21h 
    ; mov line_num2,al  
    ; mov ah,1 ;read one char from the user and put it in al
    ; int 21h 
    ; mov stuck_value2,al  
    noline2:
    mov ah,1
    int 16h
    jz noline2
    mov ah,0
    int 16h
    mov line_num2,al
    nokey2:
    mov ah,1
    int 16h
    jz nokey2
    mov stuck_value2,al 

;stuck_value one or zero
cmp stuck_value2,31h
jz stuck_at_one2

cmp stuck_value2,30h
jz stuck_at_zero2
 
;____________________________________________________________________________
;if stuck at one or with 00-1-00
stuck_at_one2: 
cmp line_num2,30h ;0
jz L10_2
cmp line_num2,31h
jz L11_2
cmp line_num2,32h
jz L12_2
cmp line_num2,33h
jz L13_2 
cmp line_num2,34h
jz L14_2 
cmp line_num2,35h
jz L15_2 
cmp line_num2,36h
jz L16_2
cmp line_num2,37h
jz L17_2
cmp line_num2,38h
jz L18_2
cmp line_num2,39h
jz L19_2
cmp line_num2,61h  ;a,10
jz L1A_2         
cmp line_num2,62h
jz L1B_2
cmp line_num2,63h
jz L1C_2 
cmp line_num2,64h
jz L1D_2 
cmp line_num2,65h
jz L1E_2 
cmp line_num2,66h
jz L1F_2 
;_______________________________________________________________________________________


;if stuck at zero and with 11-0-11
stuck_at_zero2: 
cmp line_num2,30h
jz L00_2
cmp line_num2,31h
jz L01_2
cmp line_num2,32h
jz L02_2
cmp line_num2,33h
jz L03_2 
cmp line_num2,34h
jz L04_2 
cmp line_num2,35h
jz L05_2 
cmp line_num2,36h
jz L06_2 
cmp line_num2,37h
jz L07_2 
cmp line_num2,38h
jz L08_2
cmp line_num2,39h
jz L09_2
cmp line_num2,61h
jz L0A_2 
cmp line_num2,62h
jz L0B_2 
cmp line_num2,63h
jz L0C_2 
cmp line_num2,64h
jz L0D_2 
cmp line_num2,65h
jz L0E_2 
cmp line_num2,66h
jz L0F_2 

;_________________________________________________________________________________________
;if stuck at one or with 00-1-00

L10_2:or src_value2,0001h
    jmp exit2
L11_2:or src_value2,0002h
    jmp exit2
L12_2:or src_value2,0004h         
    jmp exit2
L13_2:or src_value2,0008h
    jmp exit2 
L14_2:or src_value2,0010h
    jmp exit2
L15_2:or src_value2,0020h
    jmp exit2
L16_2:or src_value2,0040h
    jmp exit2
L17_2:or src_value2,0080h
    jmp exit2 
L18_2:or src_value2,0100h
    jmp exit2
L19_2:or src_value2,0200h
    jmp exit2
L1A_2:or src_value2,0400h
    jmp exit2
L1B_2:or src_value2,0800h
    jmp exit2 
L1C_2:or src_value2,1000h
    jmp exit2
L1D_2:or src_value2,2000h
    jmp exit2
L1E_2:or src_value2,4000h
    jmp exit2
L1F_2:or src_value2,8000h
    jmp exit2 
;_____________________________________________________________________________  
 ;if stuck at zero and with 11-0-11
   
L00_2:and src_value2,0FFFEH
    jmp exit2
L01_2:and src_value2,0FFFDH
    jmp exit2
L02_2:and src_value2,0FFFBH
    jmp exit2
L03_2:and src_value2,0FFF7H
    jmp exit2 
L04_2:and src_value2,0FFEFH
    jmp exit2
L05_2:and src_value2,0FFDFH
    jmp exit2
L06_2:and src_value2,0FFBFH
    jmp exit2
L07_2:and src_value2,0FF7FH
    jmp exit2 
L08_2:and src_value2,0FEFFH
    jmp exit2
L09_2:and src_value2,0FDFFH
    jmp exit2
L0A_2:and src_value2,0FBFFH
    jmp exit2 
L0B_2:and src_value2,0F7FFH
    jmp exit2
L0C_2:and src_value2,0EFFFH
    jmp exit2
L0D_2:and src_value2,0DFFFH
    jmp exit2
L0E_2:and src_value2,0BFFFH
    jmp exit2
L0F_2:and src_value2,07FFFH
    jmp exit2 
;_____________________________________________________________________________    
exit2:
    mov dx,src_value2
    mov BX,DestinationValue2
    mov [BX],dx
    ;CALL SwitchTurn
    sub P2_score,2h 
    P42:
    ret
power_up4_player2 ENDP 

;POWER UP 5
power_up5_player1 PROC far
    cmp P1_score,30
    jz  used_before1
    cmp powerup5_isused_player1,1h
    jz used_before1

    mov AxVar1, 0h
    mov BxVar1, 0h
    mov CxVar1, 0h
    mov DxVar1, 0h
    mov SiVar1, 0h
    mov DiVar1, 0h
    mov SpVar1, 0h 
    mov BpVar1, 0h 
    CALL SwitchTurn
    sub P1_score,1Eh ;SUB FROM SCORE 1EH
    mov powerup5_isused_player1,1h ;SET USED
    
    used_before1:  
    ret
power_up5_player1 ENDP 


power_up5_player2 PROC far
   cmp P2_score,30
   jz used_before2
   cmp powerup5_isused_player2,1h
   jz used_before2

   mov AxVar2, 0h
   mov BxVar2, 0h
   mov CxVar2, 0h
   mov DxVar2, 0h
   mov SiVar2, 0h
   mov DiVar2, 0h
   mov SpVar2, 0h 
   mov BpVar2, 0h 
   CALL SwitchTurn
   sub P2_score,1Eh ;SUB FROM SCORE
   mov powerup5_isused_player2,1h

    used_before2: 
    ret
power_up5_player2 ENDP
;power up 6 for level 2
power_up6_player1 PROC far
    mov exist,0
    cmp chosen_level,1
    jz cannot1
    cmp powerup6_isused_player1,1
    jz cannot1
    call ConvertStrTo4Digit
    call compareAllReg
    cmp exist,1
    jz cannot1
    mov bx,number
    mov target,bx
    cannot1:
    CALL SwitchTurn
    ret
power_up6_player1 ENDP

power_up6_player2 PROC far
    mov exist,0
    cmp chosen_level,2
    jz cannot2
    cmp powerup6_isused_player2,1
    jz cannot2
    call ConvertStrTo4Digit
    call compareAllReg
    cmp exist,1
    jz cannot2
    mov bx,number
    mov target,bx
    cannot2:
    CALL SwitchTurn
    ret
power_up6_player2 ENDP

ConvertStrTo4Digit proc far 
    mov number,0
    firstDigit:
    ;set crsr
    mov dl,18 
    mov dh,20
    mov ah,2
    int 10h
    ;convert
    mov ah,1
    int 21H 
    mov digit,al
    cmp digit,39h ;'9'
    jg alpha
    sub digit,30h
    mov dl,digit
    mov ax,1000h ;al base 16 34an kda 1000h
    mov dh,0
    mul dx ;dxax = ax*dx       
    mov number,ax
    jmp secDigit
    alpha:   
    sub digit,57h
    mov dl,digit
    mov ax,1000h 
    mov dh,0
    mul dx ;dxax = ax*dl       
    mov number,ax
    
    secDigit: 
    mov ah,1
    int 21H 
    mov digit,al
    cmp digit,39h ;'9'
    jg alpha2
    sub digit,30h
    mov dl,digit
    mov ax,100h 
    mov dh,0
    mul dx ;dxax = ax*dl       
    add number,ax
    jmp thirdDigit
    alpha2:   
    sub digit,57h
    mov dl,digit
    mov ax,100h 
    mov dh,0
    mul dx ;dxax = ax*dl       
    add number,ax  
    
    thirdDigit:
    mov ah,1
    int 21H 
    mov digit,al
    cmp digit,39h ;'9'
    jg alpha3
    sub digit,30h
    mov dl,digit
    mov ax,10h 
    mov dh,0
    mul dx ;dxax = ax*dl       
    add number,ax
    jmp forthDigit
    alpha3:   
    sub digit,57h
    mov dl,digit
    mov ax,10h 
    mov dh,0
    mul dx ;dxax = ax*dl       
    add number,ax 
    
    forthDigit:
    mov ah,1
    int 21H 
    mov digit,al
    cmp digit,39h ;'9'
    jg alpha4
    sub digit,30h
    mov dl,digit
    mov dh,0       
    add number,dx
    jmp e
    alpha4:   
    sub digit,57h
    mov dl,digit 
    mov dh,0      
    add number,dx
    e:
    ret
ConvertStrTo4Digit endp

compareAllReg PROC
    lea si,AxVar1
    mov cx,8 
    w1:
    mov dx,number
    cmp [si],dx
    mov exist,1
    jz another ;if the value in any of the regs
    add si,2
    dec cx
    cmp cx,0
    jnz w1 ;loop over all reg

    lea si, AxVar2
    mov cx,8
    w2:
    mov dx,number
    cmp [si],dx
    jz another
    add si,2
    dec cx
    cmp cx,0
    jnz w2  
    ;if the number not exist
    mov exist,0
    another:
    ret
compareAllReg ENDP
END