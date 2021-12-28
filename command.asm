GenerateDestCode MACRO l1,l2,code
    LOCAL notValid
    cmp [si], l1
    jnz notValid
    inc si
    cmp [si], l2
    jnz notValid
    inc si
    cmp [si], ','
    jnz notValid
    inc si
    mov Destination, code
    jmp Src
    notValid:
ENDM GenerateDestCode

GenerateSrcCode MACRO l1,l2,code
    LOCAL notValid
    cmp [si], l1
    jnz notValid
    inc si
    cmp [si], l2
    jnz notValid
    inc si
    mov Source, code
    jmp Src
    notValid:
ENDM GenerateSrcCode

EXTRN commandStr:BYTE
EXTRN commandCode:BYTE
EXTRN isExternal:BYTE
EXTRN Instruction:BYTE
EXTRN Destination:BYTE
EXTRN Source:BYTE
EXTRN External:WORD
EXTRN commandS:BYTE

PUBLIC execute
.model small
.data
;instruction codes 
movCode equ 1h
addCode equ 2h
adcCode equ 3h
subCode equ 4h
sbbCode equ 5h
xorCode equ 6h
andCode equ 7h 
orCode equ  8h     
nopCode equ 9h       
shrCode equ 10h  
shlCode equ 11h  
clcCode equ 12h   
rorCode equ 13h   
rclCode equ 14h   
rcrCode equ 15h  
rolCode equ 16h   
pushCode equ 17h
popCode equ 18h   
incCode equ 19h
decCode equ 20h  


;mulCode equ 4h
;divCode equ 5h

;8 bit register variables
AlVar db 21h
AhVar db 22h

BlVar db 23h
BhVar db 24h

ClVar db 25h
ChVar db 26h

DlVar db 27h
DhVar db 28h




;16 bit registers variables
AxVar dw 0fh
BxVar dw 1h
CxVar dw 0ch
DxVar dw 4h



SiVar dw 1h
DiVar dw 1h
SpVar dw 0ch
BpVar dw 4h

;16 bit registers codes 
AxCode equ 40h
BxCode equ 41h
CxCode equ 42h
DxCode equ 43h

;8 bit registers codes 
alCode equ 44h
ahCode equ 45h

blCode equ 46h
bhCode equ 47h

clCode equ 48h
chCode equ 49h

dlCode equ 50h
dhCode equ 51h




;---------------------------Memory Opcodes----------------------------

MemoOpcode DB 70h,71h,72h,73h,74h,75h,76h,77h,78h,79h,7Ah,7Bh,7Ch,7Dh,7Eh,7Fh

;-------------------Variables to discover command string---------------
L1 db ?
L2 db ?
L3 db ?
L4 db ?
CodeToCheck db ?

InstrusctionValid db 0
MemoLocation db ?


tempSI dw ?

.code
execute PROC far
    mov ax, @data
    mov ds, ax
    ; lea si, commandStr
    mov InstrusctionValid, 0
    IsMov:
        mov L1, 'm'
        mov L2, 'o'
        mov L3, 'v'
        mov CodeToCheck, movCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest

    IsAdd:
        mov L1, 'a'
        mov L2, 'd'
        mov L3, 'd'
        mov CodeToCheck, addCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest
    IsAdc:
        mov L1, 'a'
        mov L2, 'd'
        mov L3, 'c'
        mov CodeToCheck, adcCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest

    IsSub:
        mov L1, 's'
        mov L2, 'u'
        mov L3, 'b'
        mov CodeToCheck, subCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest

    IsSbb:
        mov L1, 's'
        mov L2, 'b'
        mov L3, 'b'
        mov CodeToCheck, sbbCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest

    IsXor:
        mov L1, 'x'
        mov L2, 'o'
        mov L3, 'r'
        mov CodeToCheck, xorCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest
    IsAnd:
        mov L1, 'a'
        mov L2, 'n'
        mov L3, 'd'
        mov CodeToCheck, andCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest
    IsOr: 
        mov L1, 'o'
        mov L2, 'r'
        mov CodeToCheck, orCode
        CALL GenerateInstructionCode2
        cmp InstrusctionValid, 1
        jz Dest
    IsNop:
        mov L1, 'n'
        mov L2, 'o'
        mov L3, 'p'
        mov CodeToCheck, nopCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest
    IsShr:
        mov L1, 's'
        mov L2, 'h'
        mov L3, 'r'
        mov CodeToCheck, shrCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest
    IsShl:
        mov L1, 's'
        mov L2, 'h'
        mov L3, 'l'
        mov CodeToCheck, shlCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest
    IsClc:
        mov L1, 'c'
        mov L2, 'l'
        mov L3, 'c'
        mov CodeToCheck, clcCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest

    ; IsRor:
    ; GenerateInstructionCode 'r','o','r',rorCode

    ; IsRcl:
    ; GenerateInstructionCode 'r','c','l',rclCode

    ; IsRcr:
    ; GenerateInstructionCode 'r','c','r',rcrCode

    ; IsRol:
    ; GenerateInstructionCode 'r','o','l',rolCode

    ; IsPush:
    ; GenerateInstructionCode4 'p','u','s','h',pushCode 

    ;  IsPop:
    ; GenerateInstructionCode 'p','o','p',popCode 

    ; IsInc:
    ; GenerateInstructionCode 'i','n','c',incCode

    ; IsDec:
    ; GenerateInstructionCode 'd','e','c',decCode


    ;IsMul:
    ; GenerateInstructionCode 'm','u','l',mulCode

    ;IsDiv:
    ;GenerateInstructionCode 'd','i','v',divCode

    Dest: ;is destination
    push si
    CALL GenerateDestCodeiFNotreg
    pop si
    ; IsAxd:
    ;     GenerateDestCode 'a','x', AxCode

    ; IsBxd:
    ;     GenerateDestCode 'b','x', BxCode

    ; IsCxd:
    ;     GenerateDestCode 'c','x', CxCode

    ; IsDxd:
    ;     GenerateDestCode 'd','x', DxCode


    ; IsAld:
    ;     GenerateDestCode 'a','l', alCode
    
    ; IsAhd:
    ;     GenerateDestCode 'a','h', ahCode


    ; IsBld:
    ;     GenerateDestCode 'b','l', blCode
    
    ; IsBhd:
    ;     GenerateDestCode 'b','h', bhCode

    
    ; IsCld:
    ;     GenerateDestCode 'c','l', clCode
    
    ; IsChd:
    ;     GenerateDestCode 'c','h', chCode



    ; IsDld:
    ;     GenerateDestCode 'd','l', dlCode
    
    ; IsDhd:
    ;     GenerateDestCode 'd','h', dhCode



    ; Src:  ;is sorce

    ; IsAxs:
    ;     GenerateSrcCode 'a','x', AxCode

    ; IsBxs:
    ;     GenerateSrcCode 'b','x', BxCode

    ; IsCxs:
    ;     GenerateSrcCode 'c','x', CxCode

    ; IsDxs:
    ;     GenerateSrcCode 'd','x', DxCode


    ; IsAls:
    ;     GenerateSrcCode 'a','l', alCode
    
    ; IsAhs:
    ;     GenerateSrcCode 'a','h', ahCode


    ; IsBls:
    ;     GenerateSrcCode 'b','l', blCode
    
    ; IsBhs:
    ;     GenerateSrcCode 'b','h', bhCode

    
    ; IsCls:
    ;     GenerateSrcCode 'c','l', clCode
    
    ; IsChs:
    ;     GenerateSrcCode 'c','h', chCode



    ; IsDls:
    ;     GenerateSrcCode 'd','l', dlCode
    
    ; IsDhs:
    ;     GenerateSrcCode 'd','h', dhCode

    ; Exe:
    ; lea si, commandCode
    ; isExt:

    ; inc si
    ; instruction_E:
    ;     isMov_E:
    ;         cmp [si], movCode
    ;         jnz Exit_isMov_E
    ;         add si, 2
    ;         dest_Mov:
    ;             isAx_Dest_Mov:
    ;                 cmp [si], AxCode
    ;                 jnz Exit_isAx_dest_Mov
    ;                 add si, 2
    ;                 jmp src_Mov
    ;             Exit_isAx_dest_Mov:
    ;         Exit_Dest_Mov:

    ;         src_Mov:
    ;             isBx_src_Mov:
    ;                 cmp [si], BxCode
    ;                 jnz Exit_isBx_Src_Mov
    ;                 add si, 2
    ;                 mov ax, BxVar
    ;                 mov AxVar, ax
    ;             Exit_isBx_Src_Mov:
    ;         Exit_src_Mov:
    ;     Exit_isMov_E:
    ; If instruction = mov
    ;     if dest = Ax
    ;         if src = bx
    ;             mov ax, BxVar
    ;             mov AxVar, ax
    ret
execute ENDP

GenerateInstructionCode PROC
    lea si, commandS
    MOV AL, L1
    cmp [si], AL
    jnz notValid
    inc si

    MOV AL, L2
    cmp [si], AL
    jnz notValid
    inc si

    MOV AL, L3
    cmp [si], AL
    jnz notValid
    inc si

    MOV InstrusctionValid, 1
    MOV AL, CodeToCheck
    mov Instruction, AL
    notValid:
    RET
GenerateInstructionCode ENDP


GenerateInstructionCode2 PROC
    lea si, commandS
    MOV AL, L1
    cmp [si], AL
    jnz notValid2
    inc si

    MOV AL, L2
    cmp [si], AL
    jnz notValid2
    inc si

    MOV AL, CodeToCheck
    mov Instruction, AL
    MOV InstrusctionValid, 1
    notValid2:
    RET
GenerateInstructionCode2   ENDP


GenerateInstructionCode4 PROC
    lea si, commandS
    MOV AL, L1
    cmp [si], AL
    jnz notValid4
    inc si

    MOV AL, L2
    cmp [si], AL
    jnz notValid4
    inc si
    
    MOV AL, L3
    cmp [si], AL
    jnz notValid4
    inc si

    MOV AL, L4
    cmp [si], AL
    jnz notValid4
    inc si

    MOV AL, CodeToCheck
    mov Instruction, AL
    MOV InstrusctionValid, 1
    notValid4:
    RET
GenerateInstructionCode4 ENDP

GenerateDestCodeiFNotreg PROC
    MOV AL, '['
    cmp [si], AL
    JNZ NOTMEMO
    INC SI

    MOV AL, 30H
    cmp [si], AL
    JL ERROR1
    MOV AL, 39H
    cmp [si], AL
    jg NOTDIGIT


    MOV AL, '0'
    cmp [si], AL
    JNZ TAKECURRNUM
    takeNumTillClosed:
        mov al, [si]
        mov MemoLocation, al
        INC SI
        MOV AL, ']'
        cmp [si], AL
        JZ ISMEMO
        INC SI
        mov al, [si]
        mov MemoLocation, al
        jmp ISMEMO

    TAKECURRNUM:
    mov al, [si]
    Mov MemoLocation, al
    JMP ISMEMO

    NOTDIGIT:
    ERROR1:

    ISMEMO:
    
    sub MemoLocation, 30h
    mov al, MemoLocation
    XLAT
    mov Destination, 70h
    NOTMEMO:
    RET
GenerateDestCodeiFNotreg ENDP

GenerateDestCodeiFNotreg PROC
    mov tempSI,si
    
    MOV AL, '['
    cmp [si], AL
    JNZ NOTMEMO
    INC SI

    MOV AL, 30H
    cmp [si], AL
    JL ERROR1
    MOV AL, 39H
    cmp [si], AL
    jg NOTDIGIT


    MOV AL, '0'
    cmp [si], AL
    JNZ TAKECURRNUM
    takeNumTillClosed:
        mov al, [si]
        mov MemoLocation, al
        INC SI
        MOV AL, ']'
        cmp [si], AL 
        JZ ISMEMO
        mov al, [si]
        mov MemoLocation, al
        jmp ISMEMO

    TAKECURRNUM:
    mov al, [si]
    Mov MemoLocation, al
    ;JMP ENDMEMO

    

    ISMEMO:
    cmp MemoLocation,39h
    jg charNum
    sub MemoLocation, 30h
    jmp ctn
    
    charNum:
    sub MemoLocation, 57h
    
    ctn:
    mov al, MemoLocation
    
    mov BX,offset MemoOpcode 
    XLAT
    mov Destination, al
    cmp [si], ']'
    jnz ENDMEMO
      dec si
    jmp ENDMEMO
    NOTDIGIT:
    cmp [si],'b'
    jnz isSi
        inc si
        cmp [si],'x'
        jnz ERROR1            
            mov ax,BxVar
            mov ah,0
            mov MemoLocation,al
            
            inc si
            cmp [si],']'
            jnz RegIndirect1
            
            
            mov BX,offset MemoOpcode 
            XLAT
            mov Destination, al
            cmp [si], ']'
            jnz ENDMEMO
              dec si
            jmp ENDMEMO
            
            RegIndirect1:
            cmp [si],'+'
            jnz ERROR1
            inc si
            
            cmp [si],39h
            jg AF1
            sub [si], 30h
            jmp cont1
            AF1:
            sub [si], 57h
            cont1:
            mov al, [si]
            
            add MemoLocation,al
            mov al,MemoLocation
            
            
            mov BX,offset MemoOpcode 
            XLAT
            mov Destination, al
            JMP ENDMEMO
    isSi:
    cmp [si],'s'
    jnz isDi
        inc si
        cmp [si],'i'
        jnz ERROR1
            mov ax,SiVar
            mov ah,0
            mov MemoLocation,al
            
            inc si
            cmp [si],']'
            jnz RegIndirect2
            
            
            mov BX,offset MemoOpcode 
            XLAT
            mov Destination, al
            jnz ENDMEMO
              dec si
            jmp ENDMEMO
            
            RegIndirect2:
            cmp [si],'+'
            jnz ERROR1
            inc si
            
            cmp [si],39h
            jg AF2
            sub [si], 30h
            jmp cont2
            AF2:
            sub [si], 57h
            cont2:
            mov al, [si]
            
            add MemoLocation,al
            mov al,MemoLocation
            
            
            mov BX,offset MemoOpcode 
            XLAT
            mov Destination, al
            JMP ENDMEMO  
    isDi:
    cmp [si],'d'
    jnz ERROR1
        inc si
        cmp [si],'i'
        jnz ERROR1
            mov ax,DiVar
            mov ah,0
            mov MemoLocation,al
            
            inc si
            cmp [si],']'
            jnz RegIndirect3
            
            mov BX,offset MemoOpcode 
            XLAT
            mov Destination, al
            jnz ENDMEMO
              dec si
            jmp ENDMEMO
            
            RegIndirect3:
            cmp [si],'+'
            jnz ERROR1
            inc si
            
            cmp [si],39h
            jg AF3
            sub [si], 30h
            jmp cont3
            AF3:
            sub [si], 57h
            cont3:
            mov al, [si]
            
            add MemoLocation,al
            mov al,MemoLocation
            
            
            mov BX,offset MemoOpcode 
            XLAT
            mov Destination, al
            JMP ENDMEMO
            
    NOTMEMO:         
    ERROR1:
    mov si,tempSI ; to save si location if the operation failed        
   
    ENDMEMO:
    RET
GenerateDestCodeiFNotreg ENDP






GenerateSrcCodeiFNotreg PROC
    MOV AL, '['
    cmp [si], AL
    JNZ NOTMEMO2
    INC SI

    MOV AL, 30H
    cmp [si], AL
    JL ERROR2
    MOV AL, 39H
    cmp [si], AL
    jg NOTDIGIT2


    MOV AL, '0'
    cmp [si], AL
    JNZ TAKECURRNUM2
    takeNumTillClosed2:
        mov al, [si]
        mov MemoLocation, al
        INC SI
        MOV AL, ']'
        cmp [si], AL
        JZ ISMEMO2 
        mov al, [si]
        mov MemoLocation, al
        jmp ISMEMO2

    TAKECURRNUM2:
    mov al, [si]
    Mov MemoLocation, al
    ;JMP ENDMEMO2

    

    ISMEMO2:
    cmp MemoLocation,39h
    jg charNum2
    sub MemoLocation, 30h
    jmp ctn2
    
    charNum2:
    sub MemoLocation, 57h
    
    ctn2:
    mov al, MemoLocation
    
    mov BX,offset MemoOpcode 
    XLAT
    mov Source, al
    jmp ENDMEMO2
    
    NOTDIGIT2:
    cmp [si],'b'
    jnz isSi2
        inc si
        cmp [si],'x'
        jnz ERROR2            
            mov ax,BxVar
            mov ah,0
            mov MemoLocation,al
            
            inc si
            cmp [si],']'
            jnz RegIndirect1
            
            
            mov BX,offset MemoOpcode 
            XLAT
            mov Source, al
            JMP ENDMEMO2
            
            RegIndirect12:
            cmp [si],'+'
            jnz ERROR2
            inc si
            
            cmp [si],39h
            jg AF12
            sub [si], 30h
            jmp cont12
            AF12:
            sub [si], 57h
            cont12:
            mov al, [si]
            
            add MemoLocation,al
            mov al,MemoLocation
            
            
            mov BX,offset MemoOpcode 
            XLAT
            mov Source, al
            JMP ENDMEMO2
    isSi2:
    cmp [si],'s'
    jnz isDi2
        inc si
        cmp [si],'i'
        jnz ERROR2
            mov ax,SiVar
            mov ah,0
            mov MemoLocation,al
            
            inc si
            cmp [si],']'
            jnz RegIndirect22
            
            
            mov BX,offset MemoOpcode 
            XLAT
            mov Source, al
            JMP ENDMEMO2
            
            RegIndirect22:
            cmp [si],'+'
            jnz ERROR2
            inc si
            
            cmp [si],39h
            jg AF22
            sub [si], 30h
            jmp cont22
            AF22:
            sub [si], 57h
            cont22:
            mov al, [si]
            
            add MemoLocation,al
            mov al,MemoLocation
            
            
            mov BX,offset MemoOpcode 
            XLAT
            mov Source, al
            JMP ENDMEMO2  
    isDi2:
    cmp [si],'d'
    jnz ERROR2
        inc si
        cmp [si],'i'
        jnz ERROR2
            mov ax,DiVar
            mov ah,0
            mov MemoLocation,al
            
            inc si
            cmp [si],']'
            jnz RegIndirect32
            
            mov BX,offset MemoOpcode 
            XLAT
            mov Source, al
            JMP ENDMEMO2
            
            RegIndirect32:
            cmp [si],'+'
            jnz ERROR2
            inc si
            
            cmp [si],39h
            jg AF32
            sub [si], 30h
            jmp cont32
            AF32:
            sub [si], 57h
            cont32:
            mov al, [si]
            
            add MemoLocation,al
            mov al,MemoLocation
            
            
            mov BX,offset MemoOpcode 
            XLAT
            mov Source, al
            JMP ENDMEMO2
            
    NOTMEMO2:         
    ERROR2:
    mov si,tempSI ; to save si location if the operation failed        
    ENDMEMO2:
    RET
GenerateSrcCodeiFNotreg ENDP

end