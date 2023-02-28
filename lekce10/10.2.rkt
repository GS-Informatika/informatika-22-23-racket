;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |10.2|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; ------- ABSTRAKCE DATOVÝCH DEFINIC -------

;   V minulých lekcích viděli spoustu repetetivních definic funkcí,
; které jsme nyní vyřešili abstrakcí funkcí. Dále jsme také viděli
; mnoho velmi podobných definic dat. Pro ně budeme postupovat stejně.

; Porovnejte následující definice dat

; List-of-Numbers je jedno z:
; - '()
; - (cons Number List-of-Numbers)


; List-of-Strings je jedno z:
; - '()
; - (cons String List-of-Strings)


;   Kde se definice liší?

;   U datových definic ale nemáme "parametry" (argumenty) jako u funkcí!
; Zatím...

; [List-of T] je jedno z:
; - '()
; - (cons T [List-of T])

;   Takové definici říkáme "parametrická datová definice"
; Nyní můžeme dvě předchozí definice (a spoustu dalších)
; psát jako [List-of Number], [List-of String], [List-of Boolean], ...

;   Funkce které s těmito listy pracují pak můžeme anotovat právě těmito parametrickými
; datovými typy.

; [NE-List-of T] je jedno z:
; - (cons T '())
; - (cons T [NE-List-of T])

; [NE-List-of Number] -> Number
(define (find-max l)
  (cond [(empty? (rest l)) (first l)]
        [else (max (first l) (find-max (rest l)))]))

; [Pair L R] je struktura:
;   (make-pair L R)
; interpretace: dvojice hodnot L a R
(define-struct pair [left right])

; -------------------------------------------------------------------
;   Procvičování: Napište funkce pracující nad konkrétními realizacemi
; parametrického typu [Pair L R] (tedy funkce, kde za L a R dosadíte
; konkrétní typy). 




; -------------------------------------------------------------------

;   Stejně jako u dunkcí, i u datových typů můžeme "vnořovat" parametry.

;   [List-of [Pair L R]] je zápis takového "vnořeného" parametrického typu.
; Dosaďte postupně do definic datových typů a určete, co obsahují hodnoty
; tohoto typu!

;   Funkce mohou pracovat i nad "generickými" (tj. nekonkretizovanými)
; parametrickými datovými typy. Takové funkce jsou většinou výsledkem
; abstrakce.

;   Nejprve zapíšeme které parametry budeme používat v naší definici,
; dále zapíšeme signaturu

; [T] [List-of T] [T -> Boolean] -> T
(define (filterP l P)
  (cond [(empty? l) '()]
        [(P (first l)) (cons (first l) (filterP (rest l) P))]
        [else (filterP (rest l) P)]))

;   Funkce P má datový typ (T -> Boolean).
; Při konkrétním použití funkce pak musíme dbát na stejnost všech výskytů typu T.
; Tedy pokud funkci filterP použijeme např. na [List-of Number], pak
; funkce P musí mít signaturu (Number -> Boolean) a výsledkem bude Number.
; Pokud ji použijeme na [List-of String], za funkci P zase musíme doplňit
; funkci která bere String a vrací Boolean, tedy (String -> Boolean) a výsledkem
; pak bude Boolean.

; Je dobré si uvědomit, že signatura funkce je vlastně definice datového typu dané funkce!

; Další ukázka:

; [T1 T2] [T1 -> T2] [List-of T1] -> T2
(define (mapL f l)
  (cond [(empty? l) '()]
        [else (cons (f (first l)) (mapL f (rest l)))]))

;   Určete, jaké parametry má tato definice. Vymyslete nějákou konkrétní realizaci
; této hodnoty (tj. napište nějákou konkretizaci funkce a napište její signaturu)