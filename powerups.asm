PUBLIC changeForbidden
PUBLIC forbidden
.model small
.data
forbidden db ?
.code

changeForbidden PROC far
MOV AX,@DATA
MOV DS,AX
MOV AH,01H
INT 21h
MOV forbidden,AL
RET
changeForbidden ENDP
END