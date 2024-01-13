include 'emu8086.inc'
org 100H

.DATA      
    MSG0 DB "MICROWAVE OVEN IS ON NOW$" ;0AH --> NEW LINE, 0DH --> CREATE
    MSG1 DB 0AH,0DH,"MICROWAVE$"
    MSG2 DB 0AH,0DH,"CONVECTION$"
    MSG3 DB 0AH,0DH,"Enter 1 for Grill ,else 0 for Reheating : $"
    MSG4 DB 0AH,0DH,"Enter 1 for Baking ,else 0 for Defrosting : $"
    MSG7 DB 0AH,0DH,"For microwave press 1, else for convection 0: $"
    MSG8 DB 0AH,0DH,"Enter temperature : $"
    ;MSG9 DB 0AH,0DH,"Enter temperature for convection: $"
    MSG10 DB 0AH,0DH,"Enter time in seconds: $"
    TENMUL DW 10
    LASTDGT DW 64H
    MICROWAVE_TEMP DW 0
    CONVECTION_TEMP DW 0
    TIME DW 0    
    TST DW 0 ;TO CHECK FOR RANGE ALLOWED.
    MESSAGE1 DB 0AH,0DH,"Out of range! Please re-enter your time:$"    
    MESSAGE2 DB 0AH,0DH,"Out of range! Please re-enter your temperature:$"
    INPUT DW 0
   
.CODE  
    ASSUME DS:DATA,CS:CODE  
START:        

    ;PRINT A WELCOME MESSAGE:    
    MOV AX,@DATA
    MOV DS,AX
    LEA DX,MSG0
    MOV AH,09H ;WRITE STRING TO STDOUT
    INT 21H                            

 
    ;INPUT MESSAGE FOR USER  
    LEA DX,MSG1
    MOV AH,09H
    INT 21H  
   
    ;INPUT MESSAGE      
    LEA DX,MSG2
    MOV AH,09H
    INT 21H
           
    START1:
    LEA DX,MSG7
    MOV AH,09H
    INT 21H

    ;GET THE MODE (MICROWAVE OR CONVECTION)
    CALL READINPUT
    MOV AX,INPUT
    CMP AX, 1
    JE MICROWAVE_MODE
    JB CONVECTION_MODE
    JA START1

MICROWAVE_MODE:
    ;RANGE TEMP: 0 --> 100 DECIMAL.
    LEA DX,MSG3
    MOV AH,09H
    INT 21H
   
    CALL READINPUT
    MOV AX,INPUT
    CMP AX, 1
    JA MICROWAVE_MODE
   
    MOV TST, 64H
           
    LEA DX,MSG8
    MOV AH,09H
    INT 21H

    ;GET THE TEMPERATURE      
    CALL READINPUT
    MOV AX,INPUT
    MOV MICROWAVE_TEMP, AX  
   
    ; Check temperature range
    CMP AX, 100
    JA REENTER_MICROWAVE_TEMP ; Jump if AX > 100
   
    ;GET THE TIME
    LEA DX,MSG10
    MOV AH,09H
    INT 21H
       
    CALL READINPUT
    MOV AX,INPUT            
    MOV TIME,AX
   
    CMP AX,100
    JA timeproc
    
    ;STORE THE INPUTS IN AX AND DL    
    MOV AX,MICROWAVE_TEMP
    MOV DX,TIME            

    ;PRINT THE INPUTS
    MOV AH, 02H ; WRITE CHARACTER TO STDOUT
    MOV DL, 0DH ; CARRIAGE RETURN
    INT 21H
    MOV DL, 0AH ; LINE FEED
    INT 21H
   
   
    time1 proc      
    PRINT 'WAIT FOR 20 SECONDS YOUR FOOD IS COOKING ...'
   
   
    MOV AH, 0 ; Set video mode
    MOV AL, 13H
    INT 10H
   
    MOV AH, 0CH ; Set pixel color
    MOV AL, 15
    MOV CX, 30
    MOV DX, 50
    INT 10H
     
    PRINT 'COOKING'
    
    
    
    
    MOV BL, 100
    FIRSTLINE:
    INT 10H
    INC CX
    DEC BL
    JNZ FIRSTLINE
   
    MOV BL, 100
    SECONDLINE:
    INT 10H
    INC DX
    DEC BL
    JNZ SECONDLINE
 
     
    MOV BL, 100
    THIRDLINE:
    INT 10H
    DEC CX
    DEC BL
    JNZ THIRDLINE
   
    MOV BL, 100
    FOURTHLINE:
    INT 10H
    DEC DX
    DEC BL
    JNZ FOURTHLINE  
    PRINTN
    PRINT 'PLEASE WAIT..... ALMOST DONE '
   
   
    CALL DELAY20SEC
   
    MOV AH, 0 ; Restore original video mode
    MOV AL, 3
    INT 10H
   
    MOV AH, 2 ; Set cursor position
    MOV BH, 0 ; Page number
    MOV DH, 14 ; Row
    MOV DL, 30 ; Column
    INT 10H
   
        .model small
.stack 100h

;.code
;main proc
    mov ax, 0B800h  ; Video memory segment
    mov es, ax
    
    mov ax, 0  ; Clear AX register
    int 10h     ; Call BIOS video services
    
    mov al, 7   ; Set ASCII code for beep sound
    mov ah, 0Eh ; Display character function
    mov cx, 1   ; Repeat count
    mov bx, 7   ; Attribute (white on black)
    int 10h     ; Call BIOS video services
    
    ;mov ax, 4C00h  ; Exit program
    ;int 21h
;main endp

    PRINTN
    PRINT '-------DONE--------'
    PRINTN
    PRINT 'YOUR FOOD IS READY'
    time1 endp    
    
    

    
         
    ; Terminate the program
    MOV AH, 4CH
    INT 21H   
    
timeproc PROC
     ; Display warning message
    LEA DX, MESSAGE1
    MOV AH, 09H
    INT 21H
    ; Prompt user to re-enter microwave temperature
    LEA DX, MSG10
    MOV AH, 09H
    INT 21H

    ; Get the temperature again
    CALL READINPUT
    MOV AX, INPUT
    MOV TIME, AX
   
    CMP AX, 100
    JA timeproc ; Jump if AX > 100
   
   
     call time1  

timeproc endp

CONVECTION_MODE:

    LEA DX,MSG4
    MOV AH,09H
    INT 21H
   
    CALL READINPUT
    MOV AX,INPUT
    ;RANGE TEMP: 0 --> 100 DECIMAL.
    CMP AX, 1
    JA CONVECTION_MODE
    
    MOV TST, 64H
           
    LEA DX,MSG8
    MOV AH,09H
    INT 21H

    ;GET THE TEMPERATURE      
    CALL READINPUT
    MOV AX,INPUT
    MOV MICROWAVE_TEMP, AX  
   
    ; Check temperature range
    CMP AX, 100
    JA REENTER_MICROWAVE_TEMP ; Jump if AX > 100
   
    ;GET THE TIME
    LEA DX,MSG10
    MOV AH,09H
    INT 21H
       
    CALL READINPUT
    MOV AX,INPUT
    MOV TIME,AX    
    CMP AX,100
    JA timeproc 

   
    ;STORE THE INPUTS IN AX AND DL    
    MOV AX,MICROWAVE_TEMP
    MOV DX,TIME            

    ;PRINT THE INPUTS
    MOV AH, 02H ; WRITE CHARACTER TO STDOUT
    MOV DL, 0DH ; CARRIAGE RETURN
    INT 21H
    MOV DL, 0AH ; LINE FEED
    INT 21H
   
    call time1

    ; Terminate the program
    MOV AH, 4CH
    INT 21H

;TEMPERATURE_WARNING:
 ;   ; Display warning message
 ;   LEA DX, MESSAGE2
 ;   MOV AH, 09H
 ;   INT 21H

    ; Prompt user to re-enter temperature
 ;   CMP AX, 1
 ;   JE REENTER_MICROWAVE_TEMP
 ;   JMP REENTER_CONVECTION_TEMP

REENTER_MICROWAVE_TEMP:
; Display warning message
    LEA DX, MESSAGE2
    MOV AH, 09H
    INT 21H
    ; Prompt user to re-enter microwave temperature
    LEA DX, MSG8
    MOV AH, 09H
    INT 21H

    ; Get the temperature again
    CALL READINPUT
    MOV AX, INPUT
    MOV MICROWAVE_TEMP, AX
   
    CMP AX, 100
    JA REENTER_MICROWAVE_TEMP ; Jump if AX > 100
   
   
    ; Prompt user to enter time again
    LEA DX, MSG10
    MOV AH, 09H
    INT 21H

    ; Get the time again
    CALL READINPUT
    MOV AX, INPUT
    MOV TIME, AX
    CMP AX,100
    
    JA timeproc   
     call time1
    RET

DELAY20SEC PROC
    MOV CX, TIME ; Set the loop counter to 20 (20 seconds)
    MOV DX, 0 ; Set DX to 0 to indicate 1-second delay
   
DELAY_LOOP:
    MOV AX, 0 ; Reset AX to 0
    MOV AH, 86H ; Set AH to 86H for INT 15h
   
    INT 15H ; BIOS wait function, waits for CX seconds before returning
   
    DEC CX ; Decrement CX (loop counter)
    JNZ DELAY_LOOP ; If CX is not zero, continue the delay loop  
   
   
 
    RET
   
    ;JMP MICROWAVE_MODE


;READ THE INPUT
READINPUT PROC NEAR
BGN:    
    MOV INPUT, 0  
READ:
    MOV AH,01H ;READ 1 CHARACTER
    INT 21H
   
    CMP AL, 0DH ;CHECK IF ENTER KEY IS PRESSED
    JE OK  
    CMP AL, 08H ;CHECK IF BACKSPACE IS PRESSED
    JE DELETE
    CMP AL, 30H ;CHECK THAT THE INPUT IS 0-->9
    JB INVALID
    CMP AL,39H
    JA INVALID
    JMP H
   
DELETE:
    MOV DL, 20H ;SPACE
    MOV AH,02H  ;WRITE CHARACTER TO STDOUT
    INT 21H
    MOV DL, 08H ;BACKSPACE
    MOV AH,02H
    INT 21H    
    MOV AX, INPUT
    MOV DX, 0000H ;DOUBLE WORD BY WORD DIVISION
    DIV TENMUL ;PUT RESULT IN AX
    MOV INPUT, AX
    JMP INVALID
   
H:    
    SUB AL,30H ;CONVERT FROM ASCII TO HEX
    MOV AH,00H
    MOV BX,AX
    MOV AX,INPUT
    CMP AX,TST
    JB  CONTINUE ;IF THE LAST INPUT < TST (1999H=6553 (CASE 1) OR 01H (CASE 2)): NO PROBLEM
    JE  CHECKLAST ;IF = TST , WE HAVE TO CHECK THE CURRENT INPUT DIGIT
    JMP OUTRANGE ;IF > TST, OUT OF ALLOWED RANGE, IT WILL BE MULTUPLIED BY 10 THEN ADD THE NEXT DIGIT, SO IT IS SURELY OUT OF RANGE
CHECKLAST:
    CMP BX,LASTDGT ;WHEN LAST INPUT = TST (6553*10 = 65530 OR 1*10=10), MAX NEW DIGIT MUST BE LESS THAN OR EQUAL TO 5 IN BOTH CASES  
    JB  CONTINUE
    JMP OUTRANGE  ;STARTING FROM 65536 OR 16 --> OUT OF ALLOWED RANGE
CONTINUE:
    MUL TENMUL
    ADD AX,BX
    MOV INPUT,AX ;STORE CURRENT INPUT IN INPUT  
INVALID:
    JMP READ
OUTRANGE:
    ;PRINT OUT OF RANGE TRY AGAIN
    LEA DX,MESSAGE2
    MOV AH,09H  
    INT 21H
    JMP BGN  
OK:
    RET  
   
   
READINPUT ENDP