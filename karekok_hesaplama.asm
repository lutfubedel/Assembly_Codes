
org 100h

MOV BX, 1                       ; Koku alinacak sayi

tekrar: 

    CMP BX, 1                   ; Eger koku alinacak sayinin 1 olup olmadigini kontol eder
    JNE islem                   ; 1 degilse donguye gider
    MOV [0200h + BX], 1         ; 1 ise hafizadaki yerine 1 yazilir
    INC BX                      ; BX deki sayi 1 artilir
    
islem:
    CALL Kok_Bulma              ; Kok_Bulma alt fonksiyonu cagirilir
    MOV [0200h + BX], CX        ; Bulunan kok degeri hafizadaki yerine yuklenir
    INC BX                      ; BX 1 artirilir                                                
    CMP BX, 100                 ; BX 100'e esit mi diye kontrol edilir
    JNZ tekrar                  ; Degil ise tekrar kismina geri doner
    HLT 
    

Kok_Bulma PROC        ; Kok_Bulma proseduru baslar
    MOV AX, BX        ; BX degerini AX register'ina kopyala
    MOV DI, 2         ; DI register'ina 2 degeri ata
    DIV DI            ; AX'i 2'ye bol ve kalan AX, bolum DI'de olacak
    MOV CX, AX        ; Bolum degerini CX register'ina ata
    MOV DX ,0         ; DX register'ini sifirla
    
    MOV AX, CX        ; CX degerini AX'e kopyala
    MUL AX            ; AX'i kendisiyle çcarp, sonucu AX'e ata
    MOV SI, AX        ; Carpim sonucunu SI register'ina ata
    
dongu:                
    MOV AX, BX        ; BX degerini AX register'ina kopyala
    DIV CX            ; AX'i CX'e bol
    ADD AX, CX        ; Bolum degerine CX'i ekle
    MOV DX, 0         ; DX register'ini sifirla
    MOV DI, 2         ; DI register'ina 2 ata
    DIV DI            ; AX'i 2'ye bol
    MOV CX, AX        ; Bolum degerini CX register'ina ata
    
    MOV AX, CX        ; CX degerini AX'e kopyala
    MUL AX            ; AX'i kendisiyle çcarp, sonucu AX'e ata
    MOV SI, AX        ; Carpim sonucunu SI register'ina ata
    
    SUB SI, BX        ; SI'den BX degerini cikar
    CMP SI, 0         ; SI'nin sifirla karsilastir
    JG dongu          ; Eger SI sifirdan buyukse "dongu" etiketine geri don
    
    RET               ; Prosedurden cik

Kok_Bulma ENDP        ; Kok_Bulma proseduru sonlanir





