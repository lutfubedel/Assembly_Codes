
PORTA EQU  110   ; Klayveden giris yapmaya yarayan sanal giris portu 
PORTB EQU  199   ; Sanal cikis portu, display


ORG 100

start:
 
MOV BX, 0200h
        
MOV WORD PTR [BX],0FE5Ch     ; 0120h   ;carpanin 16-0 biti
MOV WORD PTR [BX+2],0148Fh   ; 0122h   ;carpanin 32-16 biti
MOV WORD PTR [BX+4],01FF1h   ; 0124h   ;carpilanin 16-0 biti
MOV WORD PTR [BX+6],03AC5h   ; 0126h   ;carpilanin 32-16 biti

MOV WORD PTR [BX+10],0000h   ; 0130h   ;sonucun 16-00 biti  
MOV WORD PTR [BX+12],0000h   ; 0132h   ;sonucun 32-16 biti 
MOV WORD PTR [BX+14],0000h   ; 0134h   ;sonucun 48-32 biti
MOV WORD PTR [BX+16],0000h   ; 0136h   ;sonucun 64-48 biti 


MOV SI,20h       ;dongu sayaci      

tekrar:

MOV CX, [BX]                ; carpanin 16-0 bitini DI'ye aktar
AND CX, 01h                 ; carpanin LSB'si disindaki diger tum bitleri 0 yap
XOR CX, 01h                 ; carpanin LSB biti 0 olup olmadigini kontrol et

JZ topla_kaydir             ; eger LSB 1 ise topla_kaydir'a atla
CLC                         ; carry flagi sifirla


devam:

MOV AX,[BX+16]
RCR AX,1        ;carpimin 64-48 bitini bir saga kaydir
MOV [BX+16],AX

MOV AX,[BX+14]      
RCR AX,1        ;carpimin 48-32 bitini bir saga kaydir
MOV [BX+14],AX

MOV AX,[BX+12]
RCR AX,1        ;carpimin 32-16 bitini bir saga kaydir
MOV [BX+12],AX	

MOV AX,[BX+10]
RCR AX,1        ;carpimin 16-00 bitini bir saga kaydir
MOV [BX+10],AX	  

MOV AX,[BX+2]
SHR AX,1        ;carpani bir bit saga kaydir
MOV [BX+2],AX 

MOV AX,[BX]
RCR AX,1        ;carpani carry ile bir bit saga kaydir
MOV [BX],AX 

   		

DEC SI                    ; dongu degiskenini azalt
CMP SI, 0                 ; dongu degiskeni sifir mi diye kontrol et
JNZ tekrar                ; sifir degilse donguye don
JMP son                   ; carpma islemi bittiyse display port kismina atla 


topla_kaydir: 

MOV DX, [BX+4]            ; DX'e çcarpilanin 16-0 bitini kopyala
ADD [BX+14], DX           ; carpimin 48-32 bitine ekle
MOV DX, [BX+6]            ; DX'e çcarpilanin 32-16 bitini kopyala
ADC [BX+16], DX           ; carpimin 64-48 bitine carry ile ekle
JMP devam                 ; devam et


son:  
    input1:
        MOV DX,PORTA        ; sanal giris portundan veri al
        IN  AX,DX           ; AX'e porttan alinan veriyi yukle
        CMP AX,1            ; giris 1 mi diye kontrol et
        JNZ input2          ; giris 1 degilse input2 kismina atla
        
        MOV AX,[BX+10]      ; sonucun 16-0 bitini AX'e yukle
        JMP print           ; cikti islemi icin print kismina atla
        
    input2:
        CMP AX,2            ; giris 2 mi diye kontrol et
        JNZ input3          ; giris 2 degilse input3 kismina atla
        MOV AX,[BX+12]      ; sonucun 32-16 bitini AX'e yukle
        JMP print           ; cikti islemi icin print kismina atla
        
    input3:
        CMP AX,3            ; giris 3 mu diye kontrol et
        JNZ input4          ; giris 3 degilse input4 kismina atla
        MOV AX,[BX+14]      ; sonucun 48-32 bitini AX'e yukle
        JMP print           ; cikti islemi icin print kismina atla  
        
    input4:
        MOV AX,[BX+16]      ; sonucun 64-48 bitini AX'e yukle
        
    print:
        MOV DX,PORTB        ; sanal cikis portuna veri gonder
        OUT DX,AX           ; AX'teki degeri cikis portuna yazdir
        JMP son             ; Donguyu tekrar baslat
        
        HLT                 ; bitir







