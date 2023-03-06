;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |11.1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Abstrakce - recept

; Pro výuku je vhodné začít na konkrétních případech a až pak přejít k obecné problematice
; (abstrakce výuky!)

; 1. Porovnejme podobné věci - identifikace v čem se liší?

; [List-of Number] -> [List-of Number]
; převede list hodnot teploty °C
; na list stupňů Farenheit
(define (cf* l)
  (cond
    [(empty? l) '()]
    [else
     (cons
       (C2F (first l))
       (cf* (rest l)))]))

; Inventory -> [List-of String]
; Vrátí list věcí v inventáři
(define (names i)
  (cond
    [(empty? i) '()]
    [else
     (cons
       (IR-name (first i))
       (names (rest i)))]))

; Number -> Number
; Převede °C -> °F
(define (C2F c)
  (+ (* 9/5 c) 32))


; IR je struktura:
;   (make-IR String Number)
(define-struct IR
  [name price])

; Inventory je jedno z: 
; – '()
; – (cons IR Inventory)


; 2. Abstrahujeme - rozšíříme parametry, provedeme změny na podobných místech

(define (map1 k g)
  (cond
    [(empty? k) '()]
    [else
     (cons
       (g (first k))
       (map1 (rest k) g))]))

; Nyní je funkce g aplikována na každý prvek listu k!

; 3. Testujeme - definujeme původní funkce pomocí abstrahované
; a provádíme testy (viz. předchozí lekce!)

; 4. Signatura! Potřebujeme doplnit hlavičku abstrahované funkce map1!
; Musíme se podívat na podobnost hlavičky původních funkcí a nových parametrů

; [T1 T2] [List-of T1] [T1 -> T2] -> [List-of T2]



; Single point of control
; Místo kopírování a úpravy kódu vytvořit abstrakci!
	

;   V rámci designu funkcí a programů jsme si také ukázali jak tvořit "templates"
; Ty můžeme použít!

; Funkce procházející listy - template
(define (fun-for-l l)
  (cond
    [(empty? l) ...]
    [else (... (first l) ...
           ... (fun-for-l (rest l)) ...)]))

; -> Abstrakce

; [X Y] [List-of X] Y [X Y -> Y] -> Y
(define (reduce l base combine)
  (cond
    [(empty? l) base]
    [else (combine (first l)
                   (reduce (rest l) base combine))]))

; Konkretizace

; [List-of Number] -> Number
(define (sum lon)
  (reduce lon 0 +))

; [List-of Number] -> Number
(define (product lon)
  (reduce lon 1 *))
