;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |6.2|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; ----Programování s daty o libovolné velikosti----

; Seznamy (listy) a definice odkazující sama na sebe

; Se seznamy se setkáváme neustále - nákupní seznam, seznam pozvaných na party,
; wish-listy ... (zkuste rozmyslet další!)

; Takové seznamy chceme reprezentovat i v BSL - formou Listu

; Tvorba listů:
; 1) Empty list (prázdný list/seznam)
'()

; Jedná se o konstantu, stejně jako #true nebo 5

; 2) Do listu pak přidáváme prvky pomocí "cons" - tato operace vytvoří nový list!
(cons "Merkur" '())
(cons "Venuše" (cons "Merkur" '()))
(define first-three-planets (cons "Země" (cons "Venuše" (cons "Merkur" '()))))
(define first-four-planets (cons "Mars" first-three-planets))
first-four-planets

;;; Procvičovací úlohy

;; Vytvořte listy, které reprezentují
;; 1) list všech planet sluneční soustavy

;; 2) list skládající se z vaší nejoblíbenější muziky

;; 3) list míst, kam se chcete v životě podívat

; -------------------------------------------------------------------------------
#|
; List nemusí obsahovat pouze data jediného datového typu
(cons "Racket"
      (cons 6
            (cons #true
            '())))

; Zkusme zavést datovou definici pro takový list

; 3TUPLE je list 3 prvků:
;   (cons String (cons Number (cons Boolean '())))
; interpretace: Programovací jazyk, počet lekcí které jsme v něm absolvovali a
;    pravdivostní hodnota určující, jestli máme nainstalované vývojové prostředí


; Taková definice ale nevyjadřuje zásadní věc - list reprezentuje data o libovolné velikosti
; Pro výše uvedený případ je vhodnější (define-struct prog-lang [...]) !

; Zkusme zavést definici dat, která jsou o libovolné velikosti

; List-jmen je jedno z:
; - '()
; -  (cons String List-jmen)
; interpretace: List jmen pozvaných lidí

; Taková definice referuje (odkazuje) sama na sebe!

;; Rozmyslete, jak následující listy sedí do této definice
(cons "Jan Novák" (cons "Karel Novotný" (cons "Jana Mladá" '())))
(cons "Bořivoj Ježek" (cons "Viktor Hanák" '()))
'()
|#
; ------------------------------------------------------------------

; Hlubší pohled - co je '() a co je (cons ...)?

; '() je nový "druh" konstantní hodnoty
; Jedná se o speciální hodnotu, která má i vlastní predikát
(empty? '())
(empty? (cons "a" '()))
(empty? #f)

; cons na první pohled vypadá jako konstruktor pro strukturu
(define-struct pair [left right])
;(make-pair "a" (make-pair "b" '())) ; Odpovídá cons pro list
;(make-pair "a" "b") ; Toto s cons udělat nemůžeme!
;(cons "a" "b") ; Error!

; Cons je tedy "checked function" - funkce, která pomocí typových predikátů kontroluje
; argumenty
; Dokážete napsat hlavičku funkce cons? Zaveďte pro to datový typ List a použíjte typ
;  Any, který znamená "lze dosadit jakýkoliv typ"

; cons má také predikát
;(cons? '())
;(cons? (cons "a" '()))

; Stejně jako u struktur, i zde potřebujeme selektory - data z listů potřebujeme dostat!
;(first (cons "Země" (cons "Venuše" (cons "Merkur" '()))))
;(rest (cons "Země" (cons "Venuše" (cons "Merkur" '()))))


;;; Procvičovací úloha - checked funkce
;; Napište checked funkce pro práci s obrázky. Nezapomeňte příslušný (require ...)!
;; 1) Funkce, která obrázek 2x zvětší
;; 2) Funkce, která obrázek otočí o x stupňů proti směru hodinových ručiček
;; Tyto funkce vyhodí (error "Argument není obrázek") v případě, že vstup nebude obrázek,
;; případně další errory týkající se typu argumentů