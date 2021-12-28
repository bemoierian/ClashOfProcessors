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
AxVar dw 29h
BxVar dw 30h
CxVar dw 31h
DxVar dw 32h




;stack variable
spVar dw 33h

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

; stack memory code

spCode equ 52h



;---------------------------Memory Opcodes----------------------------

MemoOpcode DB 70h,71h,72h,73h,74h,75h,76h,77h,78h,79h,7Ah,7Bh,7Ch,7Dh,7Eh,7Fh
;-------------------------Variables to discover command string-------------
L1 db ?
L2 db ?
L3 db ?
L4 db ?
CodeToCheck db ?

InstrusctionValid db 0
MemoLocation db ?
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
end