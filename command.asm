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
movCode equ 1h
addCode equ 2h
subCode equ 3h
mulCode equ 4h
divCode equ 5h

AxVar dw 0000
BxVar dw 1234h

AxCode equ 1h
BxCode equ 2h


.code
execute PROC far
    mov ax, @data
    mov ds, ax
    lea si, commandStr

    IsMov:
        GenerateInstructionCode 'm','o','v',movCode

    IsAdd:
        GenerateInstructionCode 'a','d','d',addCode
      
    Dest:
    IsAx:
        GenerateDestCode 'a','x', AxCode


    Src:
    IsBx:
        GenerateSrcCode 'b','x', BxCode

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
    ; If instruction = mov
    ;     if dest = Ax
    ;         if src = bx
    ;             mov ax, BxVar
    ;             mov AxVar, ax
    hlt

execute ENDP
end