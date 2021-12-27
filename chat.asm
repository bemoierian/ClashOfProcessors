public CHAT

.model small
.stack 64
.data

line db 80 dup('-'),10,13,'$'
msgS db 'Sending',10,13,'$'
msgR db 'Recieving',10,13,'$'
valueS db ?
valueR db ?
cursorS dw ?
cursorR dw ?

keyPressed db ?
.code

CHAT proc far
    mov ax, @data
    mov ds, ax
    ;clr scrn
    mov ah, 06h
    mov bh, 07h
    mov cx, 0000
    mov dx, 184Fh
    int 10h
    ;----------top------------
    mov bh, 0
    mov ah,2
    mov dl, 0
    mov dh, 0
    int 10h

    mov ah, 9
    mov dx, offset msgS
    int 21h
    
    mov bh, 0
    mov ah, 3
    int 10h
    mov cursorS, dx
    ;------middle--------------
    mov bh, 0
    mov ah,2
    mov dh, 13
    mov dl, 0
    int 10h

    mov ah, 9
    mov dx, offset line
    int 21h

    mov ah, 9
    mov dx, offset msgR
    int 21h

    mov bh, 0
    mov ah, 3
    int 10h
    mov cursorR, dx
    ;---------------Config-----------------
    mov dx,3fbh 			; Line Control Register
    mov al,10000000b		;Set Divisor Latch Access Bit
    out dx,al			;Out it
    ;Set LSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f8h			
    mov al,0ch			
    out dx,al
    ;Set MSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f9h
    mov al,00h
    out dx,al
    ;Set port configuration
    mov dx,3fbh
    mov al,00011011b

    out dx,al
    mov dx , 3FDH	

          myloop:
            mov ah, 1
            int 16h
            ; pushf
            ; cmp ah, 3Bh ;compare with F1 to exit the chatting mode
            ;   jz exit
            ; popf
            jz receive
            ;sending
            mov ah, 0
            int 16h
            mov valueS, al
            mov dx , 3FDH
            AGAIN:
                In al , dx 			;Read Line Status
                AND al , 00100000b
                JZ AGAIN
            ;If empty put the VALUE in Transmit data register
            mov dx , 3F8H		; Transmit data register
            mov  al,valueS
            out dx , al
            ;set crsr
            mov bh, 0
            mov ah,2
            mov dx,cursorS
            int 10h
            ;prnt
            mov ah,2
            mov dh, 0
            mov dl, valueS
            int 21h

            ;update crsr
            mov bh, 0
            mov ah,3
            int 10h
            mov cursorS, dx
            receive:
            ;receiving
              mov dx , 3FDH		; Line Status Register
	        
                in al , dx 
                AND al , 1
                JZ myloop

 ;If Ready read the VALUE in Receive data registerd
  		    mov dx , 03F8H
  		    in al , dx 
  		    mov valueR , al

             ;set crsr
            mov bh, 0
            mov ah,2
            mov dx,cursorR
            int 10h
            mov ah,2
            mov dh, 0
            mov dl, valueR
            int 21h

             ;update crsr
            mov bh, 0
            mov ah,3
            int 10h
            mov cursorR, dx
            jmp myLoop
           
    exit:
    popf
    ret
CHAT endp
end 