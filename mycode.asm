; multi-segment executable file template.
INCLUDE 'EMU8086.INC' ;it is library from it we can do println
.MODEL SMALL          ;to make the data segment don't ytada5l m3 code segment
.STACK 100H
.DATA

KEY DB 2BH,7EH,15H,16H,28H,0AEH,0D2H,0A6H,0ABH,0F7H,15H,88H,09H,0CFH,4FH,3CH ;the first cipher key
ARR DB 32H,43H,0F6H,0A8H,88H,5AH,30H,8DH,31H,31H,98H,0A2H,0E0H,37H,07H,34H
STAT DB 16 DUP(0)

TMP2 DB 32 DUP(0)
MATRIX DB 02H,03H,01H,01H,01H,02H,03H,01H,01H,01H,02H,03H,03H,01H,01H,02H
TMP DB 32 DUP(?)
SBOX DB 63H,7CH,77H,7BH,0F2H,6BH,6FH,0C5H,30H,01H,67H,2BH,0FEH,0D6H
DB 0ABH,76H,0CAH,82H,0C9H,7DH,0FAH,59H,47H,0F0H,0ADH,0D4H,0A2H,0AFH
DB 9CH,0AFH,72H,0C0H,0B7H,0FDH,93H,26H,36H,3FH,0F7H,0CCH,34H,0A5H,0E5H
DB 0F1H,71H,0D8H,31H,15H,04H,0C7H,23H,0C3H,18H,96H,05H,9AH,07H,12H,80H,0E2H,0EBH,27H,0B2H,75H,09H,83H,2CH,1AH,1BH,6EH,5AH,0A0H,52H,3BH,0D6H,0B3H,29H,0E3H,2FH,84H,53H,0D1H,00H,0EDH,20H,0FCH,0B1H,5BH,6AH,0CBH,0BEH,39H,4AH,4CH,58H,0CFH,0D0H,0EFH,0AAH,0FBH,43H,4DH,33H,85H,45H,0F9H,02H,7FH,50H,3CH,9FH,0A8H,51H,0A3H,40H,8FH,92H,9DH,38H,0F5H,0BCH,0B6H,0DAH,21H,10H,0FFH,0F3H,0D2H
DB 0CDH,0CH,13H,0ECH,5FH,97H,44H,17H,0C4H,0A7H,7EH,3DH,64H,5DH,19H,73H,60H,81H,4FH,0DCH,22H,2AH,90H,88H,46H,0EEH,0B8H,14H,0DEH,5EH,0BH,0DBH,0E0H,32H,3AH,0AH,49H,06H,24H,5CH,0C2H,0D3H,0ACH,62H,91H,95H,0E4H,79H,0E7H,0C8H,37H,6DH,8DH,0D5H,4EH,0A9H,6CH,56H,0F4H,0EAH,65H,7AH,0AEH,08H,0BAH,78H,25H,2EH,1CH,0A6H,0B4H,0C6H,0E8H,0DDH,74H,1FH,4BH,0BBH,8BH,8AH,70H,3EH,0B5H,66H,84H,03H,0F6H,0EH,61H,35H,57H,0B9H,86H,0C1H,1BH,9EH,0E1H,0F8H,98H,11H,69H,0D9H,8EH,94H,9BH,1EH,87H,0E9H,0CEH,55H,28H,0DFH,8CH,0A1H,89H,0DH,0BFH,0E6H,42H,68H,41H,99H,2DH,0FH,0B0H,54H,0BBH,16H

OTHERCOL DB 4 DUP(?) 

RES4 DB 4 DUP(?)
RCON DB 01H,02H,04H,08H,10H,20H,40H,80H,1BH,36H

.CODE 
MOV AX,@DATA
MOV DS,AX
XOR AX,AX
XOR CX,CX
MOV DX,0

;CALL READ
CALL COPY
CALL ADDROUNDKEY
MAIN:

CALL SUBBYTES
CALL SHIFTROWS
CALL COPY2
CALL MIXCOLUMNS
CALL COPY
CALL KEYSCHEDULE
CALL ADDROUNDKEY

INC DX
CMP DX,9
JNZ MAIN 
;CALL SUBBYTES
;CALL SHIFTROWS
;CALL KEYSCHEDULE
;CALL ADDROUNDKEY
;CALL WRITE
MOV AH,4CH    
INT 21H
         
         
         
         
         
    READ PROC
       PUSH DX          ;becuz I using it in another method and i don't want to affect the value of it
       XOR SI,SI
       MOV BX,0
       MOV CX,1
       PRINT "ENTER HEX NUMBER"
       MOV dl, 10     ;from here till the for for printing new line becuz Line feed in hexa represents by 10
       MOV ah, 02h
       INT 21h
       MOV dl, 13      ;carriage return in hexa represents by 13
       MOV ah, 02h
       INT 21h
       MOV AH,1         ; to get input from screen
       XOR DX,DX
       FOR1:
        INT 21H
        CMP AL,0DH    ;0D is the enter press
        JE END_FOR
        
        CMP AL,41H     ; 41 hexa is first letter in ascii code
        JGE LETTER
        
        ;DIGIT
        SUB AL,48
        JMP SHIFT
        
        LETTER:
            SUB AL,37H
            
        SHIFT:
            SHL BX,4 ;NEW SPACE TO STORE 
            OR BL,AL  ;AL recieving what I enter
            MOV DX,SI
            ADD DL,1
            SHL DL,1
            CMP CL,DL   ;to check if cl is multiple of 2 to check if I recieved 2 bytes
            JZ NEW
            
            JMP L 
            
            
            NEW:
            MOV ARR[SI],BL
            INC SI
            XOR BX,BX
            XOR AL,AL
        L:INC CX
            CMP CX,33
            JNZ FOR1
        
      END_FOR:       
      MOV ARR[SI],BL   ; the last element in 32 elements mknsh bt7t f 7tnah manual
      POP DX
      RET
      READ ENDP
    
    WRITE PROC  
        PUSH DX
        PRINTN       ;to make new line
        PRINT "YOUR ENCRYPTED MESSAGE IS "
        MOV dl, 10    ;this 8 lines to print new line
        MOV ah, 02h
        INT 21h
        MOV dl, 13
        MOV ah, 02h
        INT 21h
        XOR DX,DX
        XOR AX,AX
      
      
      XOR CH,CH
      MOV CX,1
      MOV AH,2      ;to print on the screen the content of AL
      MOV SI,0
      MOV BH,STAT[SI]
      FOR2:
        
        MOV DL,BH
        SHR DL,4
        SHL BX,4
        
        CMP DL,10      ;10 equvalent to letter '0A'
        JGE LETTER2    ;if letter jmp then finish and cum back
        
        ;DIGIT
        ADD DL,48
        INT 21H
        JMP END_OF_LOOP2
        
        LETTER2:
        ADD DL,55
        INT 21H
        
        END_OF_LOOP2:
            MOV DI,SI
            ADD DI,1
            SHL DI,1
            CMP CX,DI
            JZ NEW1
            JMP L2
            
            
            NEW1:
            INC SI
            MOV BH,STAT[SI]
            XOR DX,DX
            
            L2:
            INC CX
            CMP CX,33
            JNZ FOR2
         POP DX
         RET
      
        WRITE ENDP
    
    
    
    
    
    SHIFTROWS PROC 
        PUSH DX
        MOV CX,1
        
        
        LOOP1:
            CMP CX,4
            JZ FIN
         
            MOV SI,CX
            MOV DI,SI
            MOV BL,CL
            ADD DI,SI
            LOOP2:
                  
                  CMP BX,DI
                  JZ CINC
                  MOV BH,0
                  LOOP3:CMP BH,3
                        JZ SINC
                        MOV DL,STAT[SI]
                        MOV AX,4
                        ADD SI,AX
                        INC BH
                        MOV DH,STAT[SI]
                        MOV STAT[SI],DL
                        MOV STAT[SI-4],DH
                        JMP LOOP3
                  
             SINC:
                  SUB SI,12
                  INC BL
                  MOV BH,0 
                  JMP LOOP2
             CINC:
                INC CX
                JMP LOOP1     
        
        FIN:
            POP DX
            RET
            SHIFTROWS ENDP
    
    
    
    
    
    ADDROUNDKEY PROC 
        PUSH DX
        MOV SI,0
        LOOPB:
        CMP SI,16
        JZ FINISH1
        MOV AL,STAT[SI]
        MOV BL,KEY[SI]
        XOR AL,BL
        MOV STAT[SI],AL
        INC SI
        JMP LOOPB 
        
        
        FINISH1:
        POP DX
        RET
        ADDROUNDKEY ENDP 
    
    
    
     COPY PROC  
        PUSH DX
        MOV SI,0
       
        LOOPA:
        CMP SI,16
        JZ FINISH2 
        MOV BL,ARR[SI]
        MOV STAT[SI],BL
        INC SI  
        JMP LOOPA
       
        
        FINISH2:
        POP DX
        RET
        COPY ENDP
     
     
     
     SUBBYTES PROC 
        PUSH DX
        XOR AX,AX
        MOV CX,16
        XOR SI,SI
        LOOPC:
            MOV AL,STAT[SI]
            MOV DI,AX
            MOV BL,SBOX[DI]
       
        
            MOV STAT[SI],BL
            INC SI
            LOOP LOOPC
        POP DX
        RET
        SUBBYTES ENDP
     
     
              
     MIXCOLUMNS PROC 
        PUSH DX
        XOR SI,SI
        MOV CX,16
        XOR DX,DX
        XOR AX,AX
        XOR BX,BX
        
        
        
        
        BIGLOOP:
        XOR DI,DI
        
        SLOOP: CMP DI,16  ;to finish col by col
        JZ COUNT
        MOV DH,MATRIX[DI]
        MOV CH,AH ;circle of transition to get place to make CX empty
        MOV AH,CL
        MOV CL,CH
        MOV CH,0
        ADD CL,4     ;to check of multiple of 4 which means I finish the first cell in th result which I will save in DL
        CMP SI,CX
        JZ COUNTSI 
        SUB CL,4
        MOV CH,CL
        MOV CL,AH
        MOV AH,CH
        MOV CH,0
        
        LOOPR:
        MOV AL,STAT[SI]
        CMP DH,02H
        JZ C1
        CMP DH,03H
        JZ C2
        
        JMP F1
        C1:CALL MUL2
        JMP F1
        C2:CALL MUL3
        
        F1:
        XOR DL,AL  ;ana bgm3 fe el DL
        INC SI
        INC DI
        JMP SLOOP
       
        
        COUNTSI:
        SUB CL,4
        MOV SI,CX    ;circle of transition to get place to make CX empty
        MOV CH,CL
        MOV CL,AH
        MOV AH,CH
        MOV CH,0
       
        MOV ARR[BX],DL
        MOV DL,0
        INC BX
        JMP LOOPR
         
        COUNT:
        MOV ARR[BX],DL    
        INC BX
        ADD AH,4         ;to go to the next col
        MOV DI,0
        MOV CH,AH    ;circle of transition to get place to make CX empty
        MOV AH,CL
        MOV CL,CH
        MOV CH,0
        MOV SI,CX     ;circle of transition to get place to make CX empty
        MOV CH,CL
        MOV CL,AH
        MOV AH,CH
        MOV CH,0
        MOV AL,0
        MOV DX,0
        LOOP BIGLOOP

        
        
        
        POP DX
        RET
        MIXCOLUMNS ENDP  
       
       MUL2 PROC
       
        CMP AL,80H
        JAE XO
        SHL AL,1
        JMP FINH
        XO:
        SHL AL,1
        XOR AL,1BH
        FINH:RET 
        MUL2 ENDP
       
       MUL3 PROC
        MOV BH,AL
        CALL MUL2
        XOR AL,BH
        MOV BH,0
        RET
        MUL3 ENDP
    
    
      COPY2 PROC        ;to copy stat in the ARR
        PUSH DX
        MOV SI,0
       
        LOOPCO:
        CMP SI,16
        JZ FINISH3 
        MOV BL,STAT[SI]
        MOV ARR[SI],BL
        INC SI  
        JMP LOOPCO
       
        
        FINISH3: 
        POP DX
        RET 
        COPY2 ENDP
      


    KEYSCHEDULE PROC
        PUSH DX
        XOR AX,AX
        XOR SI,SI
        XOR BX,BX
        OPERATIONS:

            XOR AX,AX
            XOR SI,SI
            XOR BX,BX
            ROTWORD:
                MOV AL,KEY[12]
                MOV AH,KEY[13]
                MOV BL,KEY[14]
                MOV BH,KEY[15]
                MOV RES4[0],AH
                MOV RES4[1],BL
                MOV RES4[2],BH
                MOV RES4[3],AL
            SUBBYTESK: 
                XOR AX,AX
                MOV CX,4
                XOR SI,SI
                XOR DI,DI
                LOOPSUBBYTESK:
                    MOV AL,RES4[SI]
                    MOV DI,AX
                    MOV BL,SBOX[DI]
                    MOV RES4[SI],BL
                    INC SI
                    LOOP LOOPSUBBYTESK
                    
                XOR SI,SI
         
            XORING:
    
                  XOR AX,AX
                  XOR BX,BX  
                  XOR DI,DI            
                  CMP SI,0
                  JZ FIRST
                  CMP SI,4
                  JZ ENDKEYSCHEDULING
                  JNZ SECOND
              FIRST:
    

                MOV BX,SI
                MOV SI,DX
                MOV AL,RES4[0]
                XOR AL,RCON[SI]
                XOR AL,KEY[0]
                MOV KEY[0],AL
                MOV SI,BX
                XOR BX,BX
                XOR AX,AX
                MOV DI,1    
                XORFIRST:
                    MOV AL,RES4[DI]
                    MOV AH,KEY[DI] 
                    XOR AL,AH 
                    MOV KEY[DI],AL
                    INC DI
                    CMP DI,4
                    JZ  ENDSEND 
                    JNZ XORFIRST  
                    
                        
              ENDSEND:
                INC SI
                JMP XORING                    
              SECOND:
              
                    MOV AX,SI
                    SHL AX,2
                    MOV DI,AX
                    MOV CX,4             
                    XORSECOND:
                        MOV BL,KEY[DI]   ; CURRENT COL
                        MOV BH,KEY[DI-4] ; PREVIOUS COL
                        XOR BL,BH
                        MOV KEY[DI],BL
                        INC DI
                        LOOP XORSECOND
                        JMP ENDSEND 
                        
        ENDKEYSCHEDULING:
        POP DX    
        RET     
        KEYSCHEDULE ENDP    