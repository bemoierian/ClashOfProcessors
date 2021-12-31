EXTRN commandStr:BYTE
EXTRN commandCode:BYTE
EXTRN isExternal:BYTE
EXTRN Instruction:BYTE
EXTRN Destination:BYTE
EXTRN Source:BYTE
EXTRN External:WORD
EXTRN commandS:BYTE


PUBLIC execute
EXTRN AxVar1:WORD,BxVar1:WORD,CxVar1:WORD,DxVar1:WORD,SiVar1:WORD,DiVar1:WORD,SpVar1 :WORD,BpVar1 :WORD
EXTRN m0_1:BYTE,m1_1:BYTE,m2_1:BYTE,m3_1:BYTE,m4_1:BYTE,m5_1:BYTE,m6_1 :BYTE,m7_1:BYTE,m8_1:BYTE,m9_1:BYTE,mA_1:BYTE,mB_1 :BYTE,mC_1:BYTE,mD_1:BYTE,mE_1:BYTE,mF_1 :BYTE



;codes : External 1 
;codes : instruction 1h -> 14h
;codes : destinations (registers 40h->4F)
;        destinations (memory 70h->7F)

;codes : Source (registers 40h->4F)
;        Source (memory 70h->7F)
;        Source (Emmidiate 50)

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
rclCode equ 0Eh   
rcrCode equ 0Fh  
rolCode equ 10h   
pushCode equ 11h
popCode equ 12h   
incCode equ 13h
decCode equ 14h  

; ;16 bit registers variables
; AxVar dw 01h
; BxVar dw 03h
; CxVar dw 30ch
; DxVar dw 4h

; ;8 bit register variables
; ;AlVar db 21h
; ;AhVar db 22h

; ;BlVar db 23h
; ;BhVar db 24h

; ;ClVar db 25h
; ;ChVar db 26h

; ;DlVar db 27h
; ;DhVar db 28h
; ;16 bit pointer-registers 

; SiVar dw 1h
; DiVar dw 1h
; SpVar dw 0Eh ;must point at 10h at begin
; BpVar dw 4h

; ;Memory Locations
; loc0 db 1h
; loc1 db 2h
; loc2 db 3h
; loc3 db 4h
; loc4 db 5h
; loc5 db 6h
; loc6 db 7h
; loc7 db 8h
; loc8 db 9h
; loc9 db 10h
; locA db 11h
; locB db 12h
; locC db 1fh
; locD db 1eh
; locE db 0ch
; locF db 0dh


;16 bit registers codes general
AxCode equ 40h
BxCode equ 41h
CxCode equ 42h
DxCode equ 43h

;8 bit registers codes 
; alCode equ 44h
; ahCode equ 45h

; blCode equ 46h
; bhCode equ 47h

; clCode equ 48h
; chCode equ 49h

; dlCode equ 4Ah
; dhCode equ 4Bh

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

;-------------------Variables to discover command string---------------
L1 db ?
L2 db ?
L3 db ?
L4 db ?

CodeToCheck db ?
ToCheck DB ?

Memo_Dest_Valid db 1
Memo_Source_Valid db 1
REG_VALID DB 0
InstrusctionValid db 0
NoSecondOperand db 0
MemoLocation db ?


tempSI dw ?
DestinationValue dw ?
SourceValue dw ? 


v1 db ?
v2 db ?
varName dw ?
destORsource db ?
flag db 0
.code
execute PROC far
    mov ax, @data
    mov ds, ax
    

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
    push si
    CALL GenerateDestCodeiFNotreg
    
    cmp Memo_Dest_Valid,1
    jz Src
    pop si
    call GetDst_Src_Code
    MOV AL,ToCheck
    mov Destination,AL

    Src:  ;is source
    mov DestinationValue,bx
    MOV REG_VALID,0
    cmp NoSecondOperand,1
    jz exe
    
    inc si
    
    cmp [si], ','
    ;jnz close

    inc si
    mov tempSI,SI
    push si
    CALL GenerateSrcCodeiFNotreg

    cmp Memo_Source_Valid,1
    jz Exe
    pop si
    IsEmmidiate:
    
    call GetDst_Src_Code

    MOV AL,ToCheck
    mov Source,AL
    cmp REG_VALID,1
    jz exe
    ;if emmidiate value
    call GenerateSrcEmValue
    ;--    
    
    
;-------------------------------------EXECUTE----------------------------------------------
    Exe:
    mov SourceValue,bx
    
    
    FinalCommand:
    call ExcuteCommand
                        
    close:
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
        ;jnz IsAld
        ret
    ; IsAld:
    ;     mov L1,'a'
    ;     mov L2,'l'
    ;     mov ToCheck,alCode
    ;     call GenerateCode
    ;     cmp REG_VALID,1
    ;     jnz IsAhd
    ;     ret
    
    ; IsAhd:
    ;     mov L1,'a'
    ;     mov L2,'h'
    ;     mov ToCheck,ahCode
    ;     call GenerateCode
    ;     cmp REG_VALID,1
    ;     jnz IsBld
    ;     ret


    ; IsBld:
    ;     mov L1,'b'
    ;     mov L2,'l'
    ;     mov ToCheck,blCode
    ;     call GenerateCode
    ;     cmp REG_VALID,1
    ;     jnz IsBhd
    ;     ret
    
    ; IsBhd:
    ;     mov L1,'b'
    ;     mov L2,'h'
    ;     mov ToCheck,bhCode
    ;     call GenerateCode
    ;     cmp REG_VALID,1
    ;     jnz IsCld
    ;     ret
    ; IsCld:
    ;     mov L1,'c'
    ;     mov L2,'l'
    ;     mov ToCheck,clCode
    ;     call GenerateCode
    ;     cmp REG_VALID,1
    ;     jnz IsChd
    ;     ret
    ; IsChd:
    ;     mov L1,'c'
    ;     mov L2,'h'
    ;     mov ToCheck,chCode
    ;     call GenerateCode
    ;     cmp REG_VALID,1
    ;     jnz IsDld
    ;     ret


    ; IsDld:
    ;     mov L1,'d'
    ;     mov L2,'l'
    ;     mov ToCheck,dlCode
    ;     call GenerateCode
    ;     cmp REG_VALID,1
    ;     jnz IsDhd
    ;     ret
    
    ; IsDhd:
    ;     mov L1,'d'
    ;     mov L2,'h'
    ;     mov ToCheck,dhCode
    ;     call GenerateCode
    ;     cmp REG_VALID,1
    ;     ret
    
GetDst_Src_Code endp 

GenerateDestCodeiFNotreg PROC far
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
    inc si
    cmp [si], ']'
    jnz NOTDIGIT
    jmp calclocdst
    NOTDIGIT:
            mov v1,'b'
            mov v2,'x' 
            mov ax,BxVar1
            mov varName,ax
            call CheckDirectAddressing
            cmp flag,1
            Jz calclocdst
    isSi:
            mov v1,'s'
            mov v2,'i' 
            mov ax,SiVar1
            mov varName,ax
            call CheckDirectAddressing
            cmp flag,1
            Jz calclocdst 
    isDi:
            mov v1,'d'
            mov v2,'i' 
            mov ax,DiVar1
            mov varName,ax
            call CheckDirectAddressing
            cmp flag,1
            Jz calclocdst
            jnz ENDMEMO 
    calclocdst:
    mov al, destORsource
    mov Destination,al
    mov BX,offset m0_1
    mov ah,0
    mov al,MemoLocation
    add BX,ax
    mov DestinationValue,BX
    jmp ENDMEMO
    
            
    NOTMEMO: 
    mov Memo_Dest_Valid,0
    JMP ENDMEMO 
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
    jmp calclocsrc
    
    NOTDIGIT2:
            mov v1,'b'
            mov v2,'x' 
            mov ax,BxVar1
            mov varName,ax
            call CheckDirectAddressing
            
            cmp flag,1
            Jz calclocsrc
    isSisrc:
            mov v1,'s'
            mov v2,'i' 
            mov ax,SiVar1
            mov varName,ax
            call CheckDirectAddressing
            cmp flag,1
            Jz calclocsrc 
    isDisrc:
            mov v1,'d'
            mov v2,'i' 
            mov ax,DiVar1
            mov varName,ax
            call CheckDirectAddressing
            cmp flag,1
            Jz calclocsrc
            jnz ENDMEMO2 
    calclocsrc:
    mov al, destORsource
    mov source,al
    mov BX,offset m0_1
    mov ah,0
    mov al,MemoLocation
    add BX,ax
    mov SourceValue,BX
    ;print value of the destination
    jmp ENDMEMO2
        
    NOTMEMO2:
    mov Memo_Source_Valid,0   
    JMP ENDMEMO2      
    ERROR2:
    mov si,tempSI ; to save si location if the operation failed        
    ENDMEMO2:
    RET
GenerateSrcCodeiFNotreg ENDP

CheckDirectAddressing proc
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
            
            ;jmp calcloc
            mov flag,1
            ret 
            
            RegIndirect1:
            mov bl,'+'
            cmp [si],bl
            jnz ERROR1
            inc si
            
            
            cmp [si],39h
            jge AF1
                sub [si], 57h
            
            jmp cont1
            AF1:
            
            sub [si], 30h
            cont1:
            mov al, [si]
            
            

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
    ;inc si
    MOV AL,ToCheck     
    ;mov Destination,AL ---
    MOV REG_VALID,1
    mov ah,0
    mov bl,10h
    div bl
    mov dl,ah
    mov dh,0
    ;mov the address of the destLocation to the destination
    mov bx,offset AxVar1
    mov ax,2
    mul dx ;multiply dx by 2
    add bx,ax
    ;inc bx
    ;inc bx ;inc only one time if it is a 

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
        jmp notValidEVAL; if value is not starting by 0 it is wrong
        
        loopOnNumber:
            ;mov bl,[si]
            cmp [si],60h ;cmp with a
            Jnc numb
                sub [si],57h
    ;lea bx ,External
    ;mov al ,[si]
    ;mov var,al
    ;call printpeter
                jmp continueOperating
            numb:
                sub [si],30h
                
            continueOperating:

            lea bx,External
            mov ax, [bx] 
            mov bx,10h
            mul bx
            lea di,External
            mov [di], ax
            mov al,[si] 
            mov ah,0
            add External,ax

            inc si
            cmp [si],'$$'
            jnz loopOnNumber
    
        numberComplete:
    

        MOV REG_VALID,1
        mov isExternal,1
        mov Source,EmidiateCode
    notValidEVAL:
    
    
    RET
GenerateSrcEmValue ENDP

ExcuteCommand proc far
    is_mov_exe:
    cmp Instruction,movCode ;mov
    jnz is_add_exe
        call ExecuteHelper
        mov [bx],cx
        ret
    
    is_add_exe:
    cmp Instruction,addCode ;add
    jnz is_adc_exe
        call ExecuteHelper
        add [bx],cx
        ret
        
    is_adc_exe:
    cmp Instruction,adcCode ;adc
    jnz is_sub_exe
        call ExecuteHelper
        adc [bx],cx
        ret
        
    is_sub_exe:
    cmp Instruction,subCode ;sub
    jnz is_sbb_exe
        call ExecuteHelper
        sub [bx],cx
        ret    
        
        
    is_sbb_exe:
    cmp Instruction,sbbCode ;sbb
    jnz is_xor_exe
        call ExecuteHelper
        sbb [bx],cx
        ret     
        
        
    is_xor_exe:
    cmp Instruction,xorCode ;xor
    jnz is_and_exe
        call ExecuteHelper
        xor [bx],cx
        ret     
        
    is_and_exe:
    cmp Instruction,andCode ;and
    jnz is_or_exe
        call ExecuteHelper
        and [bx],cx
        ret
    
    
    is_or_exe:
    cmp Instruction,orCode ;or    
    jnz is_nop_exe
        call ExecuteHelper
        or [bx],cx
        ret
    
    is_nop_exe:
    cmp Instruction,nopCode ;nop    ;nop di eh????????
    jnz is_shr_exe
        nop 
        ret
    is_shr_exe:
    cmp Instruction,shrCode ;shr    
    jnz is_shl_exe
        call ExecuteHelper
        mov ax,[bx]
        shr ax,cl  ; chech here if source is cx
        ret
        
    is_shl_exe:
    cmp Instruction,shlCode ;shl    
    jnz is_clc_exe
        call ExecuteHelper
        mov ax,[bx]
        shl ax,cl  ; chech here if source is cx
        ret
        
    is_clc_exe:
    ;cmp Instruction,clcCode ;clc    
    ;jnz is_ror_exe
    ;     mov cx,SourceValue  ; chech here if source is cx
    ;     clc DestinationValue,cx

    is_ror_exe:
    cmp Instruction,rorCode ;ror    
    jnz is_rcl_exe
        mov cx,SourceValue  ; chech here if source is cx
        ror DestinationValue,cl
        ret
    is_rcl_exe:
    cmp Instruction,rclCode ;rcl    
    jnz is_rcr_exe
        mov cx,SourceValue  ; chech here if source is cx
        rcl DestinationValue,cl
        ret
    is_rcr_exe:
    cmp Instruction,rcrCode ;rcr   
    jnz is_push_exe
        mov cx,SourceValue  
        rcr DestinationValue,cl
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
        mov bx,DestinationValue   
        add [bx],1
        ret
    is_dec_exe:
    cmp Instruction,decCode ;dec   
    jnz close 
        mov bx,DestinationValue   
        sub [bx],1;
        ret
ExcuteCommand endp

    
ExecuteHelper PROC
        cmp isExternal,1 ;if it is an external input
        jnz notemmidiatesource
            mov cx,External
            jmp finish_exe
        notemmidiatesource:  ;else
            mov al,source
            mov ah,0
            mov bl,10h
            div bl
            cmp al,7h;check if memory
            jnz notmemory1
                mov bx,SourceValue
                ;mov ch,0
                mov cx,[bx]
                jmp finish_exe
            notmemory1: 
            mov bx,SourceValue
            mov cx,[bx]
            
        finish_exe:
        mov bx,DestinationValue
        ret
ExecuteHelper ENDP



Pushexe proc
    lea si,mF_1
    mov ax,10h
    sub ax,SpVar1
    sub si,ax
    
    cmp Destination,DxCode
    jge bit16_check1
        dec si
        dec Spvar1
    bit16_check1:
    cmp Destination,SiCode
    jl is8bit
        dec si
        dec Spvar1
    is8bit:
    mov bx,DestinationValue
    mov cx,[bx]
    mov [si],cx
    
    dec Spvar1
    ret
Pushexe endp

Popexe proc
    lea si,mF_1
    mov ax,0fh
    sub ax,SpVar1
    sub si,ax
    
    mov bx,DestinationValue
    mov cx,[si]
    mov [bx],cx
    
    cmp Destination,DxCode
    jge bit16_check1_pop
        inc si
        inc Spvar1
    bit16_check1_pop:
    cmp Destination,SiCode
    jl is8bit_pop
        inc si
        inc Spvar1
    is8bit_pop:
    
    
    inc Spvar1
    ret
Popexe endp
end 