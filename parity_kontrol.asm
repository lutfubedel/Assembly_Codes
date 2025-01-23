
PORTA EQU  110   ; Klayveden giris yapmaya yarayan sanal giris portu 
PORTB EQU  199   ; Sanal cikis portu, display

org 100h

MOV WORD PTR [0200h],   0FE5Ch  ;1111 1110 | 0101 1100 | 0001 0100 | 1000 1111    --> 00h 
MOV WORD PTR [0202h],   0148Fh  
                                                                             
MOV WORD PTR [0204h],   01FF1h  ;0001 1111 | 1111 0001 | 0011 1010 | 1100 0101    --> 00h
MOV WORD PTR [0206h],   03AC5h

MOV WORD PTR [0208h],   01AC8h  ;0001 1010 | 1100 1000 | 1110 1000 | 0101 0111    --> 01h
MOV WORD PTR [020Ah],   0E857h

MOV WORD PTR [020Ch],   03584h  ;0011 0101 | 1000 0100 | 0001 0001 | 0001 0001    --> 00h
MOV WORD PTR [020Eh],   01111h

MOV WORD PTR [0210h],   0BBEEh  ;1011 1011 | 1110 1110 | 0010 0010 | 0010 0011    --> 01h
MOV WORD PTR [0212h],   02223h        

MOV WORD PTR [0214h],   03434h  ;0011 0100 | 0011 0100 | 1000 0111 | 0100 0101    --> 01h
MOV WORD PTR [0216h],   08745h

MOV WORD PTR [0218h],   0BEBEh  ;1011 1110 | 1011 1110 | 1111 1111 | 1111 1111    --> 00h
MOV WORD PTR [021Ah],   0FFFFh

MOV WORD PTR [021Ch],   0DDDDh  ;1101 1101 | 1101 1101 | 1010 1010 | 1010 1010    --> 00h
MOV WORD PTR [021Eh],   0AAAAh

MOV WORD PTR [0220h],   01234h  ;0001 0010 | 0011 0100 | 0111 0110 | 0101 0100    --> 01h
MOV WORD PTR [0222h],   07654h

MOV WORD PTR [0224h],   0CDEFh  ;1100 1101 | 1110 1111 | 1010 1011 | 1100 1100    --> 01h
MOV WORD PTR [0226h],   0ABCch


MOV SI, 0   ; 32 bitlik kelime 16-16 olarak ikiye ayrilmisitr. SI da hangi parcanin islenecegini gosterir.      
MOV DI, 0   ; XOR islemlerin sonucunu tutan registerdir. 
MOV CL, 0   ; 16 bitin ilk 8 bitinin parity flag degerini tutar.
MOV DL, 0   ; Sonuclarin hafizada kacinci siraya yazilacagini tutar.
MOV AL, 0   ; Parity flagin degerini tutar.
MOV AH, 0   ;
MOV CH, 0   ; 16 bitin son 8 bitinin parity flag degerini tutar. 
MOV DH, 0   ; Kacinci kelimenin islendigini tutar.

start:

    ; 0200h'dan baslayarak SI ve DH registerlarindaki degerlerle birlikte istenilen veri hafizadan BX registerine kopyalanir.       

    MOV BX, 0200h   
    ADD BX, SI        
    ADD BL, DH         
    MOV BX, [BX]
    
    ; Alinan kelimenin ilk 8 biti 0 ile XOR'lanir. Bu islem sonucu degistirmezken bayraklari degistirir.
    ; Degisen bayraklar AX registerine cekilir ve parity bitinin degeri CL registerine kopyalanir.    
    
    XOR BL,0
    
    PUSHF             
    POP AX            

    SHR AX, 2         
    AND AL, 1
    MOV CL,AL  
    
    ; Alinan kelimenin son 8 biti 0 ile XOR'lanir. Bu islem sonucu degistirmezken bayraklari degistirir.
    ; Degisen bayraklar AX registerine cekilir ve parity bitinin degeri CH registerine kopyalanir.
    
    XOR BH,0
    
    PUSHF             
    POP AX            

    SHR AX, 2         
    AND AL, 1 
    MOV CH,AL
    
    
    ; Ilk 8 ve son 8 bittin gelen parity degerleri XOR'lanarak tek bir deger haline getirilir ve DI registerinde tutulur.
    
    XOR CL,CH
    MOV CH, 0
    XOR DI, CX
    
    ; 32 bitlik kelimenin son 16 bitini taramak icin SI registeri 2 arttirilir.
    
    MOV AX, 0
    INC SI
    INC SI
    
    ; Eger SI registerinin degeri 4 degil ise 32 bitin tamami taranmamistir yeni SI degeri ile basa donulur
    
    CMP SI, 4
    JNZ start
    
    
    ;0300h konumundan baslayarak DL registerindeki degere gore sonuclar sirayla hafizaya kaydedilir. 
       
    MOV BX, 0300h 
    ADD BL, DL
    MOV [BX], DI
    
    ;Bi sonraki sonucun adresi icin DL bir arttirilir ve BX registerine bir sonraki kelimeyi almak iciin DH 4 arttirilir.
    
    INC DL
    
    INC DH  
    INC DH
    INC DH
    INC DH
    
    ; Son olarak SI ve DI registerleri sifirlanir.
    ; DH registerinin degeri 40 degilse yani 10 kelimenin tamami taranmamissa yeni degerlerle en basa geri doner 
    
    MOV SI, 0 
    MOV DI, 0
    CMP DH, 40
    JNZ start


son:
    ; Kullanilacak registerlerin icerisi temizlenir
    
    MOV AX, 0               
    MOV DX, 0
    MOV SI, 0
    
    MOV DX, PORTA          ; Giris portunun adresini DX'e yukle
    IN  AL, DX             ; Giris portundan gelen veriyi AL'e al
    MOV SI, 0300h          ; Hafiza taban adresini SI'ye yukle
    ADD SI, AX             ; SI'ye AX'teki degeri ekle (0300h + AX)
    MOV AL, [SI]           ; Hafizadan 0300h + AX adresindeki veriyi AL'e yukle
    MOV DX, PORTB          ; Cikis portunun adresini DX'e yükle
    OUT DX, AL             ; AL'deki veriyi cikis portuna yaz
    JMP son                ; Sonsuz dongu ile tekrar basa don
                            




  
ret




