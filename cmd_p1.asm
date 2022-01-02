EXTRN commandStr:BYTE
EXTRN commandCode:BYTE
EXTRN isExternal:BYTE
EXTRN Instruction:BYTE
EXTRN Destination:BYTE
EXTRN Source:BYTE
EXTRN External:WORD
EXTRN commandS:BYTE


PUBLIC execute1
EXTRN m0_2:BYTE,m1_2:BYTE,m2_2:BYTE,m3_2:BYTE,m4_2:BYTE,m5_2:BYTE,m6_2 :BYTE,m7_2:BYTE,m8_2:BYTE,m9_2:BYTE,mA_2:BYTE,mB_2 :BYTE,mC_2:BYTE,mD_2:BYTE,mE_2:BYTE,mF_2:BYTE 
EXTRN AxVar2:WORD,BxVar2:WORD,CxVar2:WORD,DxVar2:WORD,SiVar2:WORD,DiVar2:WORD,SpVar2 :WORD,BpVar2 :WORD
EXTRN Carry_2:BYTE

PUBLIC CLEAR_TO_EXECUTE_1
PUBLIC DestinationValue2
;codes : External 1 
;codes : instruction 1h -> 14h
;codes : destinations (registers 40h->4F)
;        destinations (memory 70h->7F)

;codes : Source (registers 40h->4F)
;        Source (memory 70h->7F)
;        Source (Emmidiate 50)

.286
.model large
.stack 64
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
shrCode equ 0Ah  
shlCode equ 0Bh  
clcCode equ 0Ch   
rorCode equ 0Dh   
rclCode equ 0Eh ;mul  
rcrCode equ 0Fh ;div 
rolCode equ 10h   
pushCode equ 11h
popCode equ 12h   
incCode equ 13h
decCode equ 14h  


;16 bit registers codes general
AxCode equ 40h
BxCode equ 41h
CxCode equ 42h
DxCode equ 43h

;8 bit registers codes 
alCode equ 30h
ahCode equ 31h

blCode equ 32h
bhCode equ 33h

clCode equ 34h
chCode equ 35h

dlCode equ 36h
dhCode equ 37h

;16 bit pointer-index
SiCode equ 44h
DiCode equ 45h
SpCode equ 46h
BpCode equ 47h


;emidiate value code
EmidiateCode equ 50h
;---------------------------Memory Opcodes----------------------------

MemoOpcode DB 70h,71h,72h,73h,74h,75h,76h,77h,78h,79h,7Ah,7Bh,7Ch,7Dh,7Eh,7Fh

;----------------Numbers to Translate Emmidiate Values-----------------

NumberTrans DB 0,1,2,3,4,5,6,7,8,9,0ah,0bh,0ch,0dh,0eh,0fh

;--------------------------------E-R-R-O-R-S---------------------------
err_SIZE_MISMATCH db 0
err_MEMO_TO_MEMO db 0
err_INVALID_REG_NAME db 0
err_PUSHING_8_BITS db 0
err_INCORRECT_ADDRESSING db 0
CLEAR_TO_EXECUTE_1 db 1
;-------------------Variables to discover command string---------------
L1 db ?
L2 db ?
L3 db ?
L4 db ?

CodeToCheck db 0
ToCheck DB 0

Memo_Dest_Valid db 0
Memo_Source_Valid db 0
REG_VALID DB 0
InstrusctionValid db 0
NoSecondOperand db 0
MemoLocation db 0


tempSI dw 0
DestinationValue2 dw 0
SourceValue2 dw 0
countdigit db 0
is8bitreg_temp db 0
is8bitreg_dest db 0
is8bitreg_src db 0


v1 db ?
v2 db ?
varName dw ?
destORsource db 0
flag db 0

var db 0
.code
execute1 PROC far
    mov ax, @data
    mov ds, ax
    call resetALLvars
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

    IsRor:
        mov L1, 'r'
        mov L2, 'o'
        mov L3, 'r'
        mov CodeToCheck, rorCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest

    IsRcl:
        mov L1, 'r'
        mov L2, 'c'
        mov L3, 'l'
        mov CodeToCheck, rclCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest


    IsRcr:
        mov L1, 'r'
        mov L2, 'c'
        mov L3, 'r'
        mov CodeToCheck, rcrCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest


    IsRol:
        mov L1, 'r'
        mov L2, 'o'
        mov L3, 'l'
        mov CodeToCheck, rolCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest


    IsPush:
        mov L1, 'p'
        mov L2, 'u'
        mov L3, 's'
        mov L4 ,'h'
        mov CodeToCheck, pushCode
        CALL GenerateInstructionCode4
        cmp InstrusctionValid, 1
        jz Dest


    IsPop:
        mov L1, 'p'
        mov L2, 'o'
        mov L3, 'p'
        mov CodeToCheck, popCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest

    IsInc:
        mov L1, 'i'
        mov L2, 'n'
        mov L3, 'c'
        mov CodeToCheck, incCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest


    IsDec:
        mov L1, 'd'
        mov L2, 'e'
        mov L3, 'c'
        mov CodeToCheck, decCode
        CALL GenerateInstructionCode
        cmp InstrusctionValid, 1
        jz Dest


    Dest: ;is destination
    CALL GenerateDestCodeiFNotreg
    ;print value of the destination
    cmp Memo_Dest_Valid,1
    jz Src

    call GetDst_Src_Code
    MOV AL,ToCheck
    mov Destination,AL
    mov DestinationValue2,bx

    Src:  ;is source
    mov al,is8bitreg_temp
    mov is8bitreg_dest,al
    mov is8bitreg_temp,0
    MOV REG_VALID,0 
    cmp NoSecondOperand,1
    jz exe
    
    inc si
    cmp [si], ','
    ;jnz close

    inc si
    mov tempSI,SI
    CALL GenerateSrcCodeiFNotreg
    cmp Memo_Source_Valid,1
    jz Exe

    call GetDst_Src_Code
    cmp REG_VALID,1
    jnz IsEmmidiate
    MOV AL,ToCheck
    mov Source,AL
    mov SourceValue2,bx
    jmp exe

    IsEmmidiate:
    ;if emmidiate value
    call GenerateSrcEmValue
    ;--
    Exe:
    mov al,is8bitreg_temp
    mov is8bitreg_src,al
    mov is8bitreg_temp,0    
;------------------------------------------------------EXECUTE----------------------------------------------------------
    FinalCommand:
    call Check_Errors
    cmp CLEAR_TO_EXECUTE_1,1
    jnz close ; force quite if there is an error of any type
    call ExcuteCommand ; command is cleare to be executed !
    close:
    ret
execute1 ENDP

resetALLvars proc
mov err_SIZE_MISMATCH,0
mov err_MEMO_TO_MEMO,0
mov err_INVALID_REG_NAME,0
mov err_PUSHING_8_BITS ,0
mov err_INCORRECT_ADDRESSING,0
mov CLEAR_TO_EXECUTE_1,1
mov is8bitreg_temp,0
mov is8bitreg_dest,0
mov is8bitreg_src,0
mov isExternal,0
mov Instruction,0
mov Destination,0
mov Source,0
mov External,0
;mov commandS,' '
mov CodeToCheck,0
mov ToCheck,0
mov destORsource,0
mov Memo_Dest_Valid,0
mov Memo_Source_Valid,0
mov REG_VALID,0
mov InstrusctionValid,0
mov NoSecondOperand,0
mov MemoLocation,0
mov DestinationValue2,0
mov SourceValue2,0
mov flag,0
mov countdigit,0
ret
resetALLvars endp

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
    mov NoSecondOperand,1
    notValid4:
    RET
GenerateInstructionCode4 ENDP


GetDst_Src_Code proc far
    IsAxd:
        mov tempSI,SI
        mov L1,'a'
        mov L2,'x'
        mov ToCheck,AxCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsBxd
        ret
    IsBxd:
        mov L1,'b'
        mov L2,'x'
        mov ToCheck,BxCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsCxd
        ret

    IsCxd:
        mov L1,'c'
        mov L2,'x'
        mov ToCheck,CxCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsDxd
        ret

    IsDxd:
        mov L1,'d'
        mov L2,'x'
        mov ToCheck,DxCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsSid
        ret
        
    IsSid:
        mov L1,'s'
        mov L2,'i'
        mov ToCheck,SiCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsDid
        ret
    IsDid:
        mov L1,'d'
        mov L2,'i'
        mov ToCheck,DiCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsSpd
        ret
    IsSpd:
        mov L1,'s'
        mov L2,'p'
        mov ToCheck,SpCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsBpd
        ret
    IsBpd:
        mov L1,'b'
        mov L2,'p'
        mov ToCheck,BpCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsAld
        ret
    IsAld:
        mov L1,'a'
        mov L2,'l'
        mov ToCheck,alCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsAhd
        ret
    
    IsAhd:
        mov L1,'a'
        mov L2,'h'
        mov ToCheck,ahCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsBld
        ret


    IsBld:
        mov L1,'b'
        mov L2,'l'
        mov ToCheck,blCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsBhd
        ret
    
    IsBhd:
        mov L1,'b'
        mov L2,'h'
        mov ToCheck,bhCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsCld
        ret
    IsCld:
        mov L1,'c'
        mov L2,'l'
        mov ToCheck,clCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsChd
        ret
    IsChd:
        mov L1,'c'
        mov L2,'h'
        mov ToCheck,chCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsDld
        ret


    IsDld:
        mov L1,'d'
        mov L2,'l'
        mov ToCheck,dlCode
        call GenerateCode
        cmp REG_VALID,1
        jnz IsDhd
        ret
    
    IsDhd:
        mov L1,'d'
        mov L2,'h'
        mov ToCheck,dhCode
        call GenerateCode
        cmp REG_VALID,1
        ret
    
GetDst_Src_Code endp 

GenerateDestCodeiFNotreg PROC far
    mov tempSI,si
    MOV AL, '['
    cmp [si], AL
    JNZ NOTMEMO
    INC SI

    MOV AL, [si]
    cmp al, 39h
    jg NOTDIGIT


    MOV AL, [si]
    cmp al, '0'
    JNZ TAKECURRNUM
    takeNumTillClosed:
        mov al, [si]
        mov MemoLocation, al
        INC SI
        MOV AL, [si]
        dec si
        cmp al, ']'
        JZ ISMEMO
        inc si
        mov al, [si]
        mov MemoLocation, al
        jmp ISMEMO

    TAKECURRNUM:
    mov al, [si]
    Mov MemoLocation, al
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
    mov destORsource, al
            
    inc si
    jmp calclocdst

    NOTDIGIT:
            mov v1,'b'
            mov v2,'x' 
            mov ax,BxVar2
            mov varName,ax
            call CheckDirectAddressing
            cmp flag,1
            Jz calclocdst
    isSi:
            mov v1,'s'
            mov v2,'i' 
            mov ax,SiVar2
            mov varName,ax
            call CheckDirectAddressing
            cmp flag,1
            Jz calclocdst 
    isDi:
            mov v1,'d'
            mov v2,'i' 
            mov ax,DiVar2
            mov varName,ax
            call CheckDirectAddressing
            cmp flag,1
            Jz calclocdst
            ;here to handle wrong addressing error
            mov err_INCORRECT_ADDRESSING,1
            jnz ENDMEMO 
    calclocdst:
    mov al, destORsource
    mov Destination,al
    mov BX,offset m0_2
    mov ah,0
    mov al,MemoLocation
    add BX,ax
    mov DestinationValue2,BX
    mov Memo_Dest_Valid,1
    jmp ENDMEMO
    
            
    NOTMEMO: 
    mov Memo_Dest_Valid,0
    mov si,tempSI ; to save si location if the operation failed        
    JMP ENDMEMO 
    ERROR1:
    ENDMEMO:
    RET
GenerateDestCodeiFNotreg ENDP


GenerateSrcCodeiFNotreg PROC far
    mov tempsi,si
    MOV AL, '['
    cmp [si], AL
    JNZ NOTMEMO2
    INC SI

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
        MOV AL, [si]
        dec si
        cmp al, ']'
        JZ ISMEMO2 
        mov al, [si]
        mov MemoLocation, al
        jmp ISMEMO2

    TAKECURRNUM2:
    mov al, [si]
    Mov MemoLocation, al
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
    mov destORsource, al
    jmp calclocsrc
    
    NOTDIGIT2:
            mov v1,'b'
            mov v2,'x' 
            mov ax,BxVar2
            mov varName,ax
            call CheckDirectAddressing
            
            cmp flag,1
            Jz calclocsrc
    isSisrc:
            mov v1,'s'
            mov v2,'i' 
            mov ax,SiVar2
            mov varName,ax
            call CheckDirectAddressing
            cmp flag,1
            Jz calclocsrc 
    isDisrc:
            mov v1,'d'
            mov v2,'i' 
            mov ax,DiVar2
            mov varName,ax
            call CheckDirectAddressing
            cmp flag,1
            Jz calclocsrc
            ;here to handle wrong addressing error
            mov err_INCORRECT_ADDRESSING,1
            jnz ENDMEMO2 
    calclocsrc:
    mov al, destORsource
    mov Source,al
    mov BX,offset m0_2
    mov ah,0
    mov al,MemoLocation
    add BX,ax
    mov SourceValue2,BX
    mov Memo_Source_Valid,1
    jmp ENDMEMO2
    
    NOTMEMO2:
    mov Memo_Source_Valid,0   
    JMP ENDMEMO2      
    mov si,tempSI ; to save si location if the operation failed        
    ENDMEMO2:
    RET
GenerateSrcCodeiFNotreg ENDP

CheckDirectAddressing proc far
    mov al,v1
    cmp [si],al
    jnz chechAnotherReg
        inc si
        mov al,v2
        cmp [si],al
        jnz ERROR1 
            mov ax,varName
            mov ah,0
            mov MemoLocation,al
            
            inc si
            mov bl,']'
            cmp [si],bl
            
            jnz RegIndirect1
            
            mov BX,offset MemoOpcode 
            XLAT
            mov destORsource, al
            mov flag,1
            ret 
            
            RegIndirect1:
            mov bl,[si]
            cmp bl,'+'
            jnz ERROR1
            inc si
            
            mov bl,[si]
            cmp bl,39h
            jle AF1
                sub bl, 57h
            jmp cont1
            AF1:
            
            sub bl, 30h
            cont1:
            mov al, bl
            add MemoLocation,al
            mov al,MemoLocation
            mov BX,offset MemoOpcode 
            XLAT
            mov destORsource, al
            inc si
            ;JMP calcloc
            mov flag,1
            chechAnotherReg:
            ret
CheckDirectAddressing endp


GenerateCode PROC far
    mov SI,tempSI
    MOV AL,L1
    cmp [si],AL
    jnz notValidD
    inc si
    MOV AL,L2
    cmp [si], AL
    jnz notValidD
    ;check on 8 bit registers
    MOV AL,ToCheck     
    MOV REG_VALID,1
    mov ah,0
    mov bl,10h
    div bl
    mov dl,ah ;get the unites of the dest/src code
    mov dh,0
    ;---------
    mov bx,offset AxVar2
    mov ax,2
    ;this for low register only
    cmp L2,'l'
    jz ishigh_low
    cmp L2,'h'
    jnz not8bitregister
            ishigh_low:
            mov is8bitreg_temp,1
            mov ax,1
    not8bitregister:
    
    mul dx ;multiply dx by 2 or 1
    add bx,ax
        cmp Instruction,popCode
        jl  hasSecondOperand
            mov NoSecondOperand,1
    hasSecondOperand:   
    mov tempSI,SI 
    notValidD:
    RET
GenerateCode ENDP 

GenerateSrcEmValue PROC 
    ;assuming em val is :'movax,0A'
    cmp [si],30h ;cmp with 0
    JGE loopOnNumber
    
    cmp [si],39h ;cmp with 9
    JLE loopOnNumber
        loopOnNumber:
            mov cl,[si]
            cmp cl,'a' ;cmp with a
            Jle numb
                sub cl,57h
                jmp continueOperating
            numb:
                sub cl,30h
                
            continueOperating:

            lea bx,External
            mov ax, [bx] 
            mov bx,10h
            mul bx
            lea di,External
            mov [di], ax
            mov al,cl 
            mov ah,0
            add External,ax

            inc countdigit

            inc si
            cmp [si],'$$'
            jnz loopOnNumber
    
        numberComplete:
        MOV REG_VALID,1
        mov isExternal,1
        mov Source,EmidiateCode
    RET
GenerateSrcEmValue ENDP

ExcuteCommand proc far
    is_mov_exe:
    cmp Instruction,movCode ;mov
    jnz is_add_exe
        call ExecuteHelper
                cmp countdigit,2
                jnc normal1
                mov [bx],cl
                ret
        normal1:
        mov [bx],cx
        ret
    
    is_add_exe:
    cmp Instruction,addCode ;add
    jnz is_adc_exe
        call ExecuteHelper
                cmp countdigit,2
                jnc normal2
                add [bx],cl
                ret
        normal2:
        add [bx],cx
        ret
        
    is_adc_exe:
    cmp Instruction,adcCode ;adc
    jnz is_sub_exe
        call ExecuteHelper
                cmp countdigit,2
                jnc normal3
                add [bx],cl
                mov al,Carry_2
                add [bx],al
                ret
        normal3:
        add [bx],cx
        mov al,Carry_2
        mov ah,0
        add [bx],ax
        ret
        
    is_sub_exe:
    cmp Instruction,subCode ;sub
    jnz is_sbb_exe
        call ExecuteHelper
                cmp countdigit,2
                jnc normal4
                sub [bx],cl
                jnc no_carry_sub1
                    mov Carry_2,1
                    jmp return1
                no_carry_sub1:
                    mov Carry_2,0
                return1:
                ret
        normal4:
        sub [bx],cx
        jnc no_carry_sub2
            mov Carry_2,1
            jmp return2
        no_carry_sub2:
            mov Carry_2,0
        return2:
        ret   
        
        
    is_sbb_exe:
    cmp Instruction,sbbCode ;sbb
    jnz is_xor_exe
        call ExecuteHelper
            cmp countdigit,2
            jnc normal5
            sub [bx],cl
            jnc no_carry_sbb1
                mov Carry_2,1
                jmp return3
            no_carry_sbb1:
                mov Carry_2,0
            return3:
            mov al,Carry_2
            sub [bx],al
            ret
        normal5:
        sub [bx],cx
        jnc no_carry_sbb2
            mov Carry_2,1
            jmp return4
        no_carry_sbb2:
            mov Carry_2,0
        return4:
        mov al,Carry_2
        mov ah,0
        sub [bx],ax
        ret   
        
        
    is_xor_exe:
    cmp Instruction,xorCode ;xor
    jnz is_and_exe
        call ExecuteHelper
                cmp countdigit,2
                jnc normal6
                xor [bx],cl
                ret
        normal6:
        xor [bx],cx
        ret  
        
    is_and_exe:
    cmp Instruction,andCode ;and
    jnz is_or_exe
        call ExecuteHelper
                cmp countdigit,2
                jnc normal7
                and [bx],cl
                ret
        normal7:
        and [bx],cx
        ret 
    
    
    is_or_exe:
    cmp Instruction,orCode ;or    
    jnz is_nop_exe
        call ExecuteHelper
                cmp countdigit,2
                jnc normal8
                or [bx],cl
                ret
        normal8:
        or [bx],cx
        ret
        
    is_nop_exe:
    cmp Instruction,nopCode ;nop    
    jnz is_shr_exe
        nop 
        ret

    is_shr_exe:
    cmp Instruction,shrCode ;shr    
    jnz is_shl_exe
        call ExecuteHelper
                cmp countdigit,2
                jnc normal9
                mov al,[bx]
                shr al,cl
                mov [bx],al
                ret
        normal9:
        mov ax,[bx]
        shr ax,cl
        mov [bx],ax
        ret
        
    is_shl_exe:
    cmp Instruction,shlCode ;shr    
    jnz is_clc_exe
        call ExecuteHelper
                cmp countdigit,2
                jnc normal10
                mov al,[bx]
                shl al,cl
                mov [bx],al
                ret
        normal10:
        mov ax,[bx]
        shl ax,cl
        mov [bx],ax
        ret 
        
    is_clc_exe:
    cmp Instruction,clcCode ;clc    
    jnz is_ror_exe
        mov Carry_2,0 ;clear the carry variable

    is_ror_exe:
    cmp Instruction,rorCode ;ror    
    jnz is_rol_exe
        call ExecuteHelper
        cmp countdigit,2
                jnc normal11
                mov al,[bx]
                ror al,cl
                mov [bx],al
                ret
        normal11:
        mov ax,[bx]
        ror ax,cl
        mov [bx],ax
        ret

    is_rol_exe:
    cmp Instruction,rolCode ;ror    
    jnz is_rcl_exe
        call ExecuteHelper
        cmp countdigit,2
                jnc normal12
                mov al,[bx]
                rol al,cl
                mov [bx],al
                ret
        normal12:
        mov ax,[bx]
        rol ax,cl
        mov [bx],ax
        ret
            
    is_rcl_exe:
    cmp Instruction,rclCode ;rcl    
    jnz is_rcr_exe
        call ExecuteHelper
        cmp countdigit,2
                jnc normal13
                mov al,[bx]
                cmp Carry_2,0
                jnz set_carry_flag1
                    clc
                    jmp rotate1
                set_carry_flag1: stc
                rotate1:
                rcl al,cl
                jc set_carry_var1
                    mov Carry_2,0
                    jmp finish_rotate_low1
                set_carry_var1:
                    mov Carry_2,1
                finish_rotate_low1:
                mov [bx],al
                ret
        normal13:
        mov ax,[bx]
        cmp Carry_2,0
        jnz set_carry_flag2
            clc
            jmp rotate2
        set_carry_flag2: stc
        rotate2:
        rcl ax,cl
        jc set_carry_var2
            mov Carry_2,0
            jmp finish_rotate_high1
        set_carry_var2:
            mov Carry_2,1
        finish_rotate_high1:
        mov [bx],ax
        ret
    
    is_rcr_exe:
    cmp Instruction,rcrCode ;rcr   
    jnz is_push_exe
        call ExecuteHelper
        cmp countdigit,2
                jnc normal14
                mov al,[bx]
                cmp Carry_2,0
                jnz set_carry_flag3
                    clc
                    jmp rotate3
                set_carry_flag3: stc
                rotate3:
                rcr al,cl
                jc set_carry_var3
                    mov Carry_2,0
                    jmp finish_rotate_low2
                set_carry_var3:
                    mov Carry_2,1
                finish_rotate_low2:
                mov [bx],al
                ret
        normal14:
        mov ax,[bx]
        cmp Carry_2,0
        jnz set_carry_flag4
            clc
            jmp rotate4
        set_carry_flag4: stc
        rotate4:
        rcr ax,cl
        jc set_carry_var4
            mov Carry_2,0
            jmp finish_rotate_high2
        set_carry_var4:
            mov Carry_2,1
        finish_rotate_high2:
        mov [bx],ax
        ret

    is_push_exe:
    cmp Instruction,pushCode ;push   
    jnz is_pop_exe  
            call Pushexe
            ret
            
    is_pop_exe:
    cmp Instruction,popCode ;pop   
    jnz is_inc_exe
        call Popexe
        ret
        
    is_inc_exe:
    cmp Instruction,incCode ;inc   
    jnz is_dec_exe
        mov bx,DestinationValue2 
        add [bx],1
        ret
    is_dec_exe:
    cmp Instruction,decCode ;dec   
    jnz close 
        mov bx,DestinationValue2   
        sub [bx],1
        ret
ExcuteCommand endp



Check_Errors PROC
    ;-----------------ERROR-1------------SIZE MISMATCH
    cmp isExternal,1
    jnz next_err
        cmp Destination,dhCode
        jg next_err
            cmp countdigit,3
            jl next_err
                mov err_SIZE_MISMATCH,1
                mov CLEAR_TO_EXECUTE_1,0
                jmp not_SIZE_mismatch
    next_err:                
    mov al,is8bitreg_dest
    mov ah,is8bitreg_src
    cmp al,ah
    jz not_SIZE_mismatch
    cmp isExternal,1
    jz not_SIZE_mismatch
    ;here to handle type mismatch error
            mov err_SIZE_MISMATCH,1
            mov CLEAR_TO_EXECUTE_1,0
    not_SIZE_mismatch:
    ;-----------------ERROR-2------------MEMORY TO MEMORY OPERATION
    mov al,source
    mov ah,0
    mov bl,10h
    div bl
    mov dl,al ;dl contain the tens of the source
    mov al,Destination
    mov ah,0
    mov bl,10h
    div bl
    mov dh,al ;dh contain the tens of the destination
    cmp dh,dl
    jnz not_MEMO_ERR
            cmp dh,7
            jnz not_MEMO_ERR
            ;here to handle memory to memoty operation error
            mov err_MEMO_TO_MEMO,1
            mov CLEAR_TO_EXECUTE_1,0
    not_MEMO_ERR:
    ;-----------------ERROR-3------------PUSHING/POPING 8 BITS
    cmp Instruction,pushCode
    jnz not_PUSH_ERR
        cmp Destination,dhCode
        jg not_PUSH_ERR
            ;here to handle PUSH 8 bits
            mov err_PUSHING_8_BITS,1
            mov CLEAR_TO_EXECUTE_1,0
    not_PUSH_ERR:
    cmp Instruction,popCode
    jnz not_POP_ERR
        cmp Destination,dhCode
        jg not_POP_ERR
            ;here to handle POP 8 bits
            mov err_PUSHING_8_BITS,1
            mov CLEAR_TO_EXECUTE_1,0
    not_POP_ERR:
    ;-----------------ERROR-4------------INVALID REGISTER NAME
    cmp err_INVALID_REG_NAME,1
    JNZ not_INVALID_NAME_ERR
            mov CLEAR_TO_EXECUTE_1,0
    not_INVALID_NAME_ERR:
    ;-----------------ERROR-5------------INCORRECT ADDRESSING MODE 
    cmp err_INCORRECT_ADDRESSING,1
    JNZ not_INVALID_ADDRESSING_ERR
            mov CLEAR_TO_EXECUTE_1,0
    not_INVALID_ADDRESSING_ERR:
        ;[err_INVALID_REG_NAME] & [err_INCORRECT_ADDRESSING] is handled in funtions : 'GenerateSrcCodeiFNotreg' , 'GenerateDstCodeiFNotreg' , 'GetDst_Src_Code'
    ret
Check_Errors ENDP


ExecuteHelper PROC
        cmp isExternal,1 ;if it is an external input
        jnz notemmidiatesource
            mov cx,External
            jmp finish_exe
        notemmidiatesource: 
            mov al,source
            mov ah,0
            mov bl,10h
            div bl
            cmp al,7h;check if memory
            jnz notmemory1
                mov bx,SourceValue2
                mov countdigit,4 ;to help in al,ah,...
                mov cx,[bx]
                jmp finish_exe
            notmemory1: 
            mov bx,SourceValue2
            mov countdigit,4
            mov cx,[bx]
        finish_exe:mov al,Destination
        mov ah,0
        mov bl,10h
        div bl
        cmp al,4     ;is a 16 bit register
        jnz checkfor8bits
            mov countdigit,3 
        checkfor8bits:
        cmp is8bitreg_dest,1
        jnz allreg
            mov countdigit,1
        allreg:
        mov bx,DestinationValue2
        ret
ExecuteHelper ENDP



Pushexe proc
    cmp Spvar2,0
    jle finishpush 
    cmp Spvar2,10H
    jg finishpush
    ; the upper operations checks if the stack pointer  is out of range
    lea si,mF_2
    mov ax,10h
    sub ax,Spvar2
    sub si,ax
    
    cmp Destination,DxCode
    jge bit16_check1
        dec si
        dec Spvar2
    bit16_check1:
    cmp Destination,SiCode
    jl is8bit
        dec si
        dec Spvar2
    is8bit:
    mov bx,DestinationValue2
    mov cx,[bx]
    mov [si],cx
    
    dec Spvar2
    finishpush:
    ret
Pushexe endp

Popexe proc
    cmp Spvar2,0eh
    jg finishpop

    lea si,mF_2
    mov ax,0fh
    sub ax,Spvar2
    sub si,ax
    
    mov bx,DestinationValue2
    mov cx,[si]
    mov [bx],cx
    mov [si],0
    
    cmp Destination,DxCode
    jge bit16_check1_pop
        inc si
        inc Spvar2
    bit16_check1_pop:
    cmp Destination,SiCode
    jl is8bit_pop
        inc si
        inc Spvar2
    is8bit_pop:
    inc Spvar2
    finishpop:
    ret
Popexe endp
end 