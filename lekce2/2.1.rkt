;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |2.1|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; Práce s obrázky - pokračování
;(circle 12 "solid" "red")
;(circle 15 "outline" "green")

;(rectangle 70 30 "solid" "grey")

#|
(overlay (circle 5 "solid" "red")
         (rectangle 20 20 "solid" "blue"))

(overlay (rectangle 20 20 "solid" "blue")
         (circle 5 "solid" "red"))
; Proč vidíme pouze modrý čtverec? Zamyslete se nad strukturou této operace!
|#

#|
(place-image (circle 5 "solid" "green")
             50 80
             (empty-scene 100 100))
|#

#|
(place-image (circle 5 "outline" "white") 15 15
             (place-image (circle 10 "solid" "black") 15 15
                          (rectangle 30 30 "solid" "yellow")))
|#

;;; Opakování - vytvořte funkci, která vloží obrázek do výšky x*x



; Datový typ Boolean
#|
#true ; Kladná pravdivostní hodnota
#t
#false ; Záporná pravdivostní hodnota
#f
|#

; S booleany jsme se již setkali
#|
(string->number "abc") ; vrací #f

(define val 5)
(cond [(= val 4) "val = 4"]
      [(= val 5) "val = 5"])
|#

; Unární operace - jediná zajímavá je not
#|
(not #f)
(not #t)
|#

; Pravdivostní tabulka - všechny možnosti pro binární operaci na booleanech
#|
(define (value-table v11 v12 v21 v22)
  (string-append (boolean->string v11) " | " (boolean->string v12) "\n"
                 (boolean->string v21) " | " (boolean->string v22)))

(define (truth-table op)
  (cond [(string=? op "and") (value-table (and #t #t) (and #t #f) (and #f #t) (and #f #f))]
        [(string=? op "or") (value-table (or #t #t) (or #t #f) (or #f #t) (or #f #f))]
        [(string=? op "<=>") (value-table (eq? #t #t) (eq? #t #f) (eq? #f #t) (eq? #f #f))]))

; rozšiřme o operaci xor a imply
(define (xor a b)
  (not (equal? a b)))

(define (imply a b)
  (cond [a b]
        [else #t]))

;(truth-table "and")
;(truth-table "or")
;(truth-table "<=>")
|#



; Aritmetika čísel podruhé
; + - * / již známe. Co dál?

;;; Úkol - prozkoumejme co dělají následující operace
;(abs _)
;(add1 _)
;(ceiling _)
;(cos _)
;(denominator _)
;(exact->inexact _)
;(expt _ _)
;(floor _)
;(gcd _ _)
;(max _ _)
;(numerator _)
;(quotient _ _)
;(random _)
;(remainder _ _)
;(sqr _)



; Aritmetika stringů - opakování
;(string-append "a" "b") ; == "ab"

; Další funkce na textových řetězcích
#|
(string-length "abcd")
(string->number "42")
(string-ith "abcd" 2)
; Všimněte si, že se jedná o funkce s různými datovými typyv argumentech a výsledcích

;;; Úkol - najděte v dokumentaci funkci substring a vyzkoušejte si práci s ní.
;;; Vytvořte funkci, která pro stringy delší než 4 písmena právě první 4 písmena, pro kratší stringy vrátí #f.
|#



; Jak vytvořit boolean?
#|
(define x 2)
(define inverse-of-x (/ 1 x)) ; Co když x = 0?

; Výraz if - podmínění
;(define inverse-of-x (if (= x 0) #f (/ 1 x)))
|#
; Funkce (= _ _) nám vytvořila boolean. Jaké podobné funkce existují?
; S některými jsme se již setkali!

; Vytvořme funkci, která klasifikuje obrázek jako "vysoký" (výška > šířka) nebo "široký" (výška < šířka)
#|
; Pro testování použíjme
(define test-rectangle (rectangle 70 80 "solid" "red"))
(define (high? image)
  (cond [(> (image-height image) (image-width image)) #t]
        [else #f]))

(high? test-rectangle)
(high? (rotate 90 test-rectangle))
|#

; Typové predikáty
;(* (+ (string-length 42) 1) pi) ; Chceme zabránit tomuto chování
; Jak zjistíme datový typ?
;(number? 4)
;(number? pi)
;(number? #true)
;(string? "abc")
;(rational? pi) ; Zkuste uhodnout proč!?



; Algebra
#|
; Použíjme stepper pro pozorování průběhu evaluace našich funkcí!
(define (f x)
  (* x 10))

(+ (f 20) 70)
(* (f 10) (+ (f 5) 12))
|#

;;; Procvičovací příklady
;; Napište funkci distance měřící (Euklidovskou) vzdálenost (x, y) od počátku (0, 0) souřadného systému. Využíjte znalost Pythagorovy věty.



;; Vytvořte funkci string-first, která z *neprázdného* stringu vrátí první znak.
; Ukázka:
; (string-first "test") = "t"
; (string-first "7ABC") = "7"



;; Vytvořte funkci image-area, která spočítá celkový počet pixelů daného obrázku.
; Ukázka:
; (image-area (square 10 "outline" "red")) = 100



;; Napište funkci string-delete, která odstraní n-tý znak ze stringu s. Ošetřete možnost prázdného strignu. Očekávejte, že číslo na vstupu n je 0 <= n < (string-length s).
; Ukázka:
; (string-delete 0 "abc") = "bc"
; (string-delete 2 "cadr") = "car")


