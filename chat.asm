public chat
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
<<<<<<< HEAD

=======
>>>>>>> 9ae9670ecdd5900b14fe68cf7e11654b0940da74
.code

chat proc far
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
    ;get the crsr and store it cursorS
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
    ;draw the line 
    mov ah, 9
    mov dx, offset line
    int 21h
    ;print recieving
    mov ah, 9
    mov dx, offset msgR
    int 21h
    ;get the crsr and store in cursorR
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
    ;mov dx , 3FDH	 ???????????????
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          myloop:
            mov ah, 1 ;check if any key pressed
            int 16h
            jz receive ;if no key pressed jump to recieve
            ;sending if a key pressed
            ;read the pressed char it won't wait because the key is al ready in the buffer
            mov ah, 0 
            int 16h
            cmp ah,3bh
            jz exit
            mov valueS, al ; move it to valueS

            mov dx , 3FDH ;line status
            ;wait till THR is empty to send
                In al , dx 			;Read Line Status
                AND al , 00100000b
                JZ receive
            ;If empty put the VALUE in Transmit data register
            mov dx , 3F8H		; Transmit data register
            mov  al,valueS
            out dx , al
            ;set crsr with the stored cursorS
            mov bh, 0
            mov ah,2
            mov dx,cursorS
            int 10h
            ;prnt
            mov ah,2
            mov dh, 0
            mov dl, valueS
            int 21h

            ;update cursorS after printing
            mov bh, 0
            mov ah,3
            int 10h
            mov cursorS, dx

            receive:
            ;receiving
              mov dx , 3FDH		; Line Status Register
                in al , dx 
                AND al , 1
                JZ myloop ;lo mafi4 7aga tst2blha jump to myloop

                ;If Ready read the VALUE in Receive data registerd
  		          mov dx , 03F8H
  		          in al , dx 
  		          mov valueR , al ;;to the recieved char in valueR

             ;set crsr
            mov bh, 0
            mov ah,2
            mov dx,cursorR
            int 10h
            ;print valueR
            mov ah,2
            mov dh, 0
            mov dl, valueR
            int 21h

             ;update cursorR with the cursor position after printing
            mov bh, 0
            mov ah,3
            int 10h
            mov cursorR, dx
            jmp myLoop
           

    exit:ret
chat endp
end