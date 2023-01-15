;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |4.1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; informace --reprezentace--> vstupní data --program--> výstupní data --interpretace--> informace

; Příklad - program Number -> Number

(define (number-program number)
  (if (< (- number 60) 0)
      20
      (- number 40)))
  

; Jaký má význam číslo na výstupu? Jaký má význam číslo na vstupu?

; Co znamená například 42 v doméně programu?
; Počet pixelů od hodního okraje obrázku - doména obrázků.
; Počet pixelů o které se pohne objekt za 1 tick (viz. minulá lekce) v simulaci,
;   hře nebo podobném interaktivním programu - doména simulace.
; Teplota na Celsiově, Fahrenheitově nebo Kelvinově stupnici - doména fyziky.
; Výška židle v doméně katalogu IKEA.
; Počet znaků "e" ve stringu v doméně textu.

; Znalost významu je důležitá pro kohokoliv, kdo čte náš program!
; Komentářem můžeme zaznamenat význam.
; Definujeme "data", pro jejich definici používáme existující datové typy.
; Brzy se setkáme s kompozitními typy!

; TeplotaC je 'Number'.
; interpretace: reprezentuje teplotu v °C.

; TeplotaK je 'Number'.
; interprezace: reprezentuje teplotu v Kelvinech

; V procesu designu je třeba vědět jak reprezentovat vstupní informaci a jak interpretovat výstupní informaci.

; 1. Zapíšeme jak reprezentujeme informaci jako data.

; 2. Zapíšeme signaturu funkce, účel funkce a hlavičku funkce
;    Signatura nám říká jaký vstup a jaký výstup má funkce, např.
;      "String -> Number" - argument je jeden string, výstupem je číslo.
;      "TeplotaC -> String" - argument je TeplotaC, výstup je string.
;      "Color Color Number -> Image" - argumenty jsou dvě barvy a jedno číslo. Jaký je výstup?
;      Tato signatura odpovídá úkolu z minulé lekce!
;    Účel funkce je komentář, který stručně popisuje co je výsledkem aplikace funkce - "co tato funkce počítá?"
;    Hlavička (header, stub) je pak "náznak" funkce, např.
#|
(define (area-of-square n)
  10)
|#
;      Napíšeme funkci, pojmenujeme parametry, vrátíme data která odpovídají výstupu.

; 3. Funkcionální příklady - ilustrujte účel na ukázkách!

; Number -> Number
; Vypočte obsah čtverce o straně len
; input: 2, expect: 4
; input: 7, expect: 49
#|
(define (area-of-square len) 0)
|#

; 4. Podívejte se, co máte dané (argumenty funkce, kontext programu - globální proměnné)
#|
(define (area-of-square len)
  (... len ..))
|#
; Tečky (...) nám říkají, že funkci nemáme dopsanou - jedná se o vzor (template).
; Postupem času budeme objevovat a vytvářet nové formy dat, zjistíme že templates jsou užitečné!

; 5. Psaní kódu!
#|
; Number -> Number
; Vypočte obsah čtverce o straně len
; input: 2, expect: 4
; input: 7, expect 49
(define (area-of-square len)
  (sqr len))
|#

; 6. Otestujme funkci!
#|
(area-of-square 2)
(area-of-square 7)
|#


; Pro psaní funkcí a programů potřebujeme určitý domain knowledge (znalost domény)
; Spolupráce s ostatními doménami
; Znalost jazyků a knihoven - co použít pro problém o kterém slyšíte poprvé!?


; Testování
; Ruční testování většinou není jednoduché. V rozsáhlém projektu budete mít stovky, nebo tisíce funkcí.
; Testovat po každé změně všechny funkce kterých se změna mohla dotknout by bylo příliš náročné.
; AUTOMATIZACE!

#|
; Number -> Number
; Vypočte obsah čtverce o straně len

(check-expect (area-of-square 2) 4)
(check-expect (area-of-square 7) 49)

(define (area-of-square len)
  (sqr len))
|#

; Bonusový úkol: Vyzkoušejte check-expect na data typu Image.


;;; Procvičovací úlohy
;;   Tyto procvičovací úlohy jsou skoro stejné s těmi, které byly v 2. lekci.
;;   Tentokrát ale proveďte všechny kroky designu. Výsledné funkce tedy budou obsahovat i signaturu a účel.

; Nadesignujte funkci 'string-first', která vrátí první písmeno neprázdného stringu.
;   Neošetřujte prázdné stringy.


; Nadesignujte funkci 'string-last', která vrátí poslední písmeno neprázdného stringu.


; Nadesignujte funkci 'image-area', která vrátí počet pixelů v obrázku.


; Nadesignujte funkci 'string-rest', která vrátí string bez prvního znaku.