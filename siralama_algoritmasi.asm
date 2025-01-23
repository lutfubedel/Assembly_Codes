
org 100h          

; BX registerine veri dizisinin baslangic adresi verilir.

MOV BX, 0200h                                             

MOV BYTE PTR [BX], 66h   
MOV BYTE PTR [BX+1], 55h 
MOV BYTE PTR [BX+2], 54h 
MOV BYTE PTR [BX+3], 11h 
MOV BYTE PTR [BX+4], 87h 
MOV BYTE PTR [BX+5], 33h 
MOV BYTE PTR [BX+6], 75h 
MOV BYTE PTR [BX+7], 05h
MOV BYTE PTR [BX+8], 5Fh 
MOV BYTE PTR [BX+9], 23h 


;Donguleri kontrol etmek icin kullanilacak olan parametreler SI ve DI registeri icerisinde tutulur.

MOV SI, 0  ; Dis donguyu kontrol eder.       
MOV DI, 1  ; Ic donguyu kontrol eder.    

J1:    
    
    MOV DX, [BX+SI]    ; [BX+SI]'deki deger DX registeri'na yuklenir.
    MOV AL, [BX+DI]    ; [BX+DI]'deki deger AL registeri'na yuklenir.
    
    MOV DH, 00h        ; DX'in yuksek baytini sifirla 
    MOV AH, 00h        ; AX'in yuksek baytini sifirla 
    
    CMP AL, DL         ; AL ve DL'yi karsilastir.
    JBE J2             ; Eger AL <= DL ise bir degisiklik yapmadan devam et.
       
       
    ; Eger siralama yanlissa elemanlari degistir.
    MOV [BX + SI], AL  ; Daha buyuk olan degeri [BX+SI]'ye yaz.
    MOV [BX + DI], DL  ; Daha kucuk olan degeri [BX+DI]'ye yaz.
    
    ; Dizide bir sonraki elemani kontrol et.
    INC DI             ; DI'yi bir artir.
    CMP DI, 10         ; DI'nin dizinin sonuna ulasip ulasmadigini kontrol et.
    JNZ J1             ; Eger ulasmadiysa dongunun basina don.

J2:
    ; Ayni dongude bir sonraki deger ile karsilastirmaya devam et.
    INC DI             ; DI'yi bir artir.
    CMP DI, 10         ; DI'nin dizinin sonuna ulasip ulasmadigini kontrol et.
    JNZ J1             ; Eger ulasmadiysa J1 dongusune geri don.

    ; Siralamanin bir sonraki dongusune basla.
    INC SI             ; SI'yi bir artir (bir sonraki dongunun baslangici).
    MOV DI, SI+1       ; DI'yi SI'nin bir sonrasina ayarla.
    
    CMP SI, 10         ; SI'nin dizinin sonuna ulasip ulasmadigini kontrol et.
    JNZ J1             ; Eger ulasmadiysa siralamaya devam et.

    
    HLT                ; Programi sonlandir.
