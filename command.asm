GenerateInstructionCode MACRO l1,l2,l3,code
    LOCAL notValid
    lea si, commandStr
    cmp [si], l1
    jnz notValid
    inc si
    cmp [si], l2
    jnz notValid
    inc si
    cmp [si], l3
    jnz notValid
    inc si
    cmp [si], ' '
    jnz notValid
    inc si 
    mov Instruction, code
    jmp dest
    notValid:
ENDM GenerateInstructionCode
GenerateInstructionCode2 MACRO l1,l2,code
    LOCAL notValid2
    lea si, commandStr
    cmp [si], l1
    jnz notValid2
    inc si
    cmp [si], l2
    jnz notValid2
    inc si
    cmp [si], ' '
    jnz notValid2
    inc si
    mov Instruction, code
    jmp dest
    notValid2:
ENDM GenerateInstructionCode2


GenerateInstructionCode4 MACRO l1,l2,l3,l4,code
    LOCAL notValid4
    lea si, commandStr
    cmp [si], l1
    jnz notValid4
    inc si
    cmp [si], l2
    jnz notValid4
    inc si
    cmp [si], l3
    jnz notValid4
    inc si
    cmp [si], l4
    jnz notValid4
    inc si
    cmp [si], ' '
    jnz notValid4
    inc si
    mov Instruction, code
    jmp dest
    notValid4:
ENDM GenerateInstructionCode4

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
EXTRN Instruction:WORD
EXTRN Destination:WORD
EXTRN Source:WORD
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

.code
execute PROC far
    mov ax, @data
    mov ds, ax
    lea si, commandStr

    IsMov:
        GenerateInstructionCode 'm','o','v',movCode

    IsAdd:
        GenerateInstructionCode 'a','d','d',addCode

    IsAdc:
        GenerateInstructionCode 'a','d','c',adcCode

    IsSub:
        GenerateInstructionCode 's','u','b',subCode

    IsSbb:
        GenerateInstructionCode 's','b','b',sbbCode

    IsXor:
        GenerateInstructionCode 'x','o','r',xorCode

    IsAnd:
        GenerateInstructionCode 'a','n','d',andCode

    IsOr: 
        GenerateInstructionCode2 'o','r',orCode

    IsNop:
        GenerateInstructionCode 'n','o','p',nopCode

    IsShr:
        GenerateInstructionCode 's','h','r',shrCode

    IsShl:
        GenerateInstructionCode 's','h','l',shlCode

    IsClc:
        GenerateInstructionCode 'c','l','c',clcCode

    IsRor:
        GenerateInstructionCode 'r','o','r',rorCode

    IsRcl:
        GenerateInstructionCode 'r','c','l',rclCode

    IsRcr:
        GenerateInstructionCode 'r','c','r',rcrCode

    IsRol:
        GenerateInstructionCode 'r','o','l',rolCode

    IsPush:
        GenerateInstructionCode4 'p','u','s','h',pushCode 

    IsPop:
        GenerateInstructionCode 'p','o','p',popCode 

    IsInc:
        GenerateInstructionCode 'i','n','c',incCode

    IsDec:
        GenerateInstructionCode 'd','e','c',decCode


    ;IsMul:
    ; GenerateInstructionCode 'm','u','l',mulCode

    ;IsDiv:
    ;GenerateInstructionCode 'd','i','v',divCode

    Dest: ;is destination
    IsAxd:
        GenerateDestCode 'a','x', AxCode

    IsBxd:
        GenerateDestCode 'b','x', BxCode

    IsCxd:
        GenerateDestCode 'c','x', CxCode

    IsDxd:
        GenerateDestCode 'd','x', DxCode


    IsAld:
        GenerateDestCode 'a','l', alCode
    
    IsAhd:
        GenerateDestCode 'a','h', ahCode


    IsBld:
        GenerateDestCode 'b','l', blCode
    
    IsBhd:
        GenerateDestCode 'b','h', bhCode

    
    IsCld:
        GenerateDestCode 'c','l', clCode
    
    IsChd:
        GenerateDestCode 'c','h', chCode



    IsDld:
        GenerateDestCode 'd','l', dlCode
    
    IsDhd:
        GenerateDestCode 'd','h', dhCode



    Src:  ;is sorce
    IsAxs:
        GenerateSrcCode 'a','x', AxCode

    IsBxs:
        GenerateSrcCode 'b','x', BxCode

    IsCxs:
        GenerateSrcCode 'c','x', CxCode

    IsDxs:
        GenerateSrcCode 'd','x', DxCode


    IsAls:
        GenerateSrcCode 'a','l', alCode
    
    IsAhs:
        GenerateSrcCode 'a','h', ahCode


    IsBls:
        GenerateSrcCode 'b','l', blCode
    
    IsBhs:
        GenerateSrcCode 'b','h', bhCode

    
    IsCls:
        GenerateSrcCode 'c','l', clCode
    
    IsChs:
        GenerateSrcCode 'c','h', chCode

    IsDls:
        GenerateSrcCode 'd','l', dlCode
    
    IsDhs:
        GenerateSrcCode 'd','h', dhCode








   

   











    Exe:
    lea si, commandCode
    isExt:

    inc si
    instruction_E:
        isMov_E:
            cmp [si], movCode
            jnz Exit_isMov_E
            add si, 2
            dest_Mov:
                isAx_Dest_Mov:
                    cmp [si], AxCode
                    jnz Exit_isAx_dest_Mov
                    add si, 2
                    jmp src_Mov
                Exit_isAx_dest_Mov:
            Exit_Dest_Mov:

            src_Mov:
                isBx_src_Mov:
                    cmp [si], BxCode
                    jnz Exit_isBx_Src_Mov
                    add si, 2
                    mov ax, BxVar
                    mov AxVar, ax
                Exit_isBx_Src_Mov:
            Exit_src_Mov:
        Exit_isMov_E:
    ret
execute ENDP
end