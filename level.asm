PUBLIC forbiddin_char1,forbiddin_char2,chosen_level,initial_reg1,initial_reg2
PUBLIC select_level,select_forbidden_char1,select_forbidden_char2,show_forb_chars,show_level
EXTRN AxVar1:WORD,BxVar1:WORD,CxVar1:WORD,DxVar1:WORD,SiVar1:WORD,DiVar1:WORD,SpVar1 :WORD,BpVar1 :WORD
EXTRN AxVar2:WORD,BxVar2:WORD,CxVar2:WORD,DxVar2:WORD,SiVar2:WORD,DiVar2:WORD,SpVar2 :WORD,BpVar2 :WORD

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

display_char MACRO char,x,y
local here,exit
mov ah,2h
mov dl,x
mov dh,y
int 10h 

mov ah,9h    
mov bh,0     
mov al,char  
mov cx,1h    
mov bl,000fh 
int 10h
jmp exit

exit:
ENDM display_char 

.MODEL Large
.STACK 64
.DATA   
mes_level DB "Select Level (press 1 or 2):",'$'
mes_level2 DB "Chosen level",'$'
mes_forb_char1 DB "Enter a forbidden char of player 1:",'$' 
mes_forb_char2 DB "Enter a forbidden char of player 2:",'$'
mes_char1 DB "player 1 choose forbidden char:",'$'
mes_char2 DB "player 2 choose forbidden char:",'$'  
mes_enter DB "press enter",'$'
;;;;;;;;;
mes_initial1 DB "initial values for player 1 registers",'$'
mes_initial2 DB "initial values for player 2 registers",'$'
mes_ax DB "AX ",'$'
mes_bx DB "BX ",'$'
mes_cx DB "CX ",'$' 
mes_dx DB "DX ",'$'
mes_si DB "SI ",'$'
mes_di DB "DI ",'$'
mes_sp DB "SP ",'$'
mes_bp DB "BP ",'$'
;;;;;;;;;;;
digit db '$'
number dw 0
chosen_level DB ?      ;1 or 2
forbiddin_char1 DB ?   ;0-9 , a-z
forbiddin_char2 DB ?
.CODE

select_level PROC far

    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
    ;set the cursor in the top left
    mov bh,0h 
    mov ah,2
    mov dh,0
    mov dl,0
    int 10h

    display_string_main mes_level,1h,1h

    back: mov ah,7h 
          int 21h 
          cmp al,31h
          jz level1
          cmp al,32h
          jz level2
    jmp back
    level1: mov chosen_level,1h 
       jmp level_end
       level2:mov chosen_level,2h
    level_end:  
      
   ; display_string_main mes_enter,1h,3h

; back2: mov ah,0
;        int 16h
;        cmp al,13
;        jnz back2
    
    ret
select_level ENDP    

show_level PROC far

    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h

    mov bh,0h 
    mov ah,2
    mov dh,0
    mov dl,0
    int 10h

    display_string_main mes_level2,1h,1h       ; player secondry
    add chosen_level,30h
    display_char chosen_level,18h,1h
    sub chosen_level,30h 
    
    display_string_main mes_enter,1h,3h

back3: mov ah,0
       int 16h
       cmp al,13
       jnz back3
    ret
show_level ENDP 
;initial values for registers in level 2
initial_reg1 PROC FAR

   ;Clear screen
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
    
display_string_main mes_initial1,1h,1h  
 
;ax
display_string_main mes_ax,1h,3h     
call ConvertStrTo4Digit     
mov ax,number 
mov AxVar1,ax 

;bx   
display_string_main mes_bx,1h,5h     
call ConvertStrTo4Digit     
mov ax,number  
mov BxVar1,ax
      
;cx    
display_string_main mes_cx,1h,7h     
call ConvertStrTo4Digit     
mov ax,number   
mov CxVar1,ax   
         
 ;dx   
display_string_main mes_dx,1h,9h     
call ConvertStrTo4Digit     
mov ax,number 
mov DxVar1,ax
      
;si    
display_string_main mes_si,1h,0bh     
call ConvertStrTo4Digit     
mov ax,number 
mov SiVar1,ax
       
;di    
display_string_main mes_di,1h,0dh     
call ConvertStrTo4Digit     
mov ax,number 
mov DiVar1,ax
       
;sp    
display_string_main mes_sp,1h,0fh     
call ConvertStrTo4Digit     
mov ax,number   
mov SpVar1,ax
         
    
;bp    
display_string_main mes_bp,1h,11h     
call ConvertStrTo4Digit     
mov ax,number 
mov BpVar1,ax
        
   ret
initial_reg1 ENDP 

initial_reg2 PROC  
   
    ;Clear screen
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h
    
display_string_main mes_initial2,1h,1h  
 
;ax
display_string_main mes_ax,1h,3h     
call ConvertStrTo4Digit     
mov ax,number 
mov AxVar2,ax 

;bx   
display_string_main mes_bx,1h,5h     
call ConvertStrTo4Digit     
mov ax,number  
mov BxVar2,ax
      
;cx    
display_string_main mes_cx,1h,7h     
call ConvertStrTo4Digit     
mov ax,number   
mov CxVar2,ax   
         
 ;dx   
display_string_main mes_dx,1h,9h     
call ConvertStrTo4Digit     
mov ax,number 
mov DxVar2,ax
      
;si    
display_string_main mes_si,1h,0bh     
call ConvertStrTo4Digit     
mov ax,number 
mov SiVar2,ax
       
;di    
display_string_main mes_di,1h,0dh     
call ConvertStrTo4Digit     
mov ax,number 
mov DiVar2,ax
       
;sp    
display_string_main mes_sp,1h,0fh     
call ConvertStrTo4Digit     
mov ax,number   
mov SpVar2,ax
         
    
;bp    
display_string_main mes_bp,1h,11h     
call ConvertStrTo4Digit     
mov ax,number 
mov BpVar2,ax
        
   ret
initial_reg2 ENDP 

ConvertStrTo4Digit proc 
    mov ax,@data
    mov ds,ax 

    firstDigit:
    mov ah,1
    int 21H  

    ToLower1:
    cmp al, 41h               ;41h is the lower bound ascii for capital letters
    jl  AddToResult1
    cmp al, 5Ah               ;5Ah is the upper bound ascii for capital letters
    jg AddToResult1
    add al, 20h               ;add 20h to make the char lower case
    AddToResult1:

    mov digit,al
    cmp digit,39h ;'9'
    jg alpha
    sub digit,30h    
    mov dl,digit
    mov ax,1000h 
    mov dh,0
    mul dx ;dxax = ax*dl       
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

    ToLower2:
    cmp al, 41h               ;41h is the lower bound ascii for capital letters
    jl  AddToResult2
    cmp al, 5Ah               ;5Ah is the upper bound ascii for capital letters
    jg AddToResult2
    add al, 20h               ;add 20h to make the char lower case
    AddToResult2:

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

    ToLower3:
    cmp al, 41h               ;41h is the lower bound ascii for capital letters
    jl  AddToResult3
    cmp al, 5Ah               ;5Ah is the upper bound ascii for capital letters
    jg AddToResult3
    add al, 20h               ;add 20h to make the char lower case
    AddToResult3:

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

    ToLower4:
    cmp al, 41h               ;41h is the lower bound ascii for capital letters
    jl  AddToResult4
    cmp al, 5Ah               ;5Ah is the upper bound ascii for capital letters
    jg AddToResult4
    add al, 20h               ;add 20h to make the char lower case
    AddToResult4:

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

select_forbidden_char1 PROC far  
     
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h              
    
    display_string_main mes_forb_char1,1h,1h 

    back_forb_1: mov ah,7h
      int 21h  
      
      cmp al,61h
      jae char2_1
       
      cmp al,30h 
      jae num2_1    
      jmp back_forb_1
       
      char2_1: cmp al,7Ah
      jbe char_end_1     
      jmp back_forb_1
       
      
      num2_1:cmp al,39h
      jbe num_end_1 
      jmp back_forb_1
        
      num_end_1:
      mov  forbiddin_char1,al
      char_end_1:  
      mov forbiddin_char1,al 
    
      ret    
select_forbidden_char1 ENDP  

select_forbidden_char2 PROC far 
    
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h                
    
    display_string_main mes_forb_char2,1h,1h 

    back_forb_2: mov ah,7h
      int 21h  
      
      cmp al,61h
      jae char2_2
       
      cmp al,30h 
      jae num2_2    
      jmp back_forb_2
       
      char2_2: cmp al,7Ah
      jbe char_end_2     
      jmp back_forb_2
       
      
      num2_2:cmp al,39h
      jbe num_end_2 
      jmp back_forb_2
        
      num_end_2:
      mov  forbiddin_char2,al
      char_end_2:  
      mov forbiddin_char2,al 
      
      ret    
select_forbidden_char2 ENDP  

show_forb_chars PROC far
    
    mov ax,0600h
    mov bh,07
    mov cx,0
    mov dx,184FH
    int 10h

    cmp chosen_level,2h
    jz hide_forb_chars

    
    display_string_main mes_char1,1h,1h       
    display_char forbiddin_char1,25h,1h 
    
    display_string_main mes_char2,1h,3h       
    display_char forbiddin_char2,25h,3h
    
    hide_forb_chars:

    display_string_main mes_enter,1h,10h

back6: mov ah,0 ;wait for enter
       int 16h
       cmp al,13
       jnz back6
    ret
show_forb_chars ENDP
END 