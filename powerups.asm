PUBLIC changeForbidden1
PUBLIC forbidden1
PUBLIC changeForbidden2
PUBLIC forbidden2

.model small
.data
forbidden1 db 0
forbidden2 db 0
.code

changeForbidden1 PROC far
MOV AX,@DATA
MOV DS,AX
MOV AH,01H
INT 21h
MOV forbidden1,AL
RET
changeForbidden1 ENDP

changeForbidden2 PROC far
MOV AX,@DATA
MOV DS,AX
MOV AH,01H
INT 21h
MOV forbidden2,AL
RET
changeForbidden2 ENDP
END