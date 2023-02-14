;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |8.1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
; Opakování

; Algebraické datové typy
;   Datové typy můžeme vytvářet skládáním jednotlivých "základních typů"
; Sum type (součtové typy) - odpovídají našim enumeracím - říkáme,
;   že výsledný typ je "jedno z"
; Product type (produktový typ) - odpovídají strukturám - říkáme,
;   že výsledný typ obsahuje "vše z"

; Struktura - definuje datový typ, který obsahuje jiné hodnoty
(define-struct person [name father mother])

(define-struct unknown ())
(define UNKNOWN (make-unknown))

; Person je
; (make-person String Person Person)
; UNKNOWN
; interpretace: člověk v rodokmenu

; make-person a make-unknown jsou tzv. konstruktory
; vytváří jednotlivá data

(define p1 (make-person "Jan" UNKNOWN UNKNOWN))
(define p2 (make-person "Jana" UNKNOWN UNKNOWN))

(define p3 (make-person "Jakub" UNKNOWN UNKNOWN))
(define p4 (make-person "Honza" UNKNOWN p2))
(define p5 (make-person "Klára" UNKNOWN p2))

(define p6 (make-person "Tomáš" p3 UNKNOWN))
(define p7 (make-person "Aneta" p1 p5))

(define p8 (make-person "Richard" p6 p7))

; K datům přistupujeme přes tzv. selektory
(person-father p5)

; Person je rekurzivní datový typ s base case UNKNOWN.
; Rekurzivní datové typy běžně vedou na rekurzivní volání funkcí
(define TEXT-COLOR "black")
(define TEXT-SIZE 14)
(define FRAME-H 20)
(define FRAME-W 64)
(define H-SPACE 10)
(define V-SPACE 10)

(define BG-COLOR "transparent")

(define HSPACE-I (rectangle FRAME-W H-SPACE "solid" BG-COLOR))
(define VSPACE-I (rectangle V-SPACE FRAME-H "solid" BG-COLOR))
(define VIEW-U (overlay (text "?" TEXT-SIZE TEXT-COLOR)
                        (empty-scene FRAME-W FRAME-H BG-COLOR)))

; (make-person String Person Person) -> Image
; Vrátí obrázek do rodokmenu pro daného člověka
(define (pedigree-view-p person)
  (overlay
   (text (person-name person) TEXT-SIZE TEXT-COLOR)
   (empty-scene FRAME-W FRAME-H BG-COLOR)))

; Image Image Image -> Number
; Vrátí výšku nejvyššího ze 3 obrázků
(define (max-h img1 img2 img3)
  (max (image-height img1) (image-height img2) (image-height img3)))

; Image Image Image -> Image
; Umístí obrázky a propojí je čárami
(define (images-with-lines bottom upper1 upper2)
  (add-line
   (add-line
    (above/align "middle"
                 (beside/align "bottom"
                               VSPACE-I
                               upper1
                               VSPACE-I
                               upper2
                               VSPACE-I)
                 HSPACE-I
                 bottom)
    
    (/ (+ (image-height VSPACE-I) (image-width upper1)) 2) ;x1
    (max-h upper1 upper2 VSPACE-I) ;y1
    (/ (+ (* 2 (image-height VSPACE-I)) (image-width upper1) (image-width upper2)) 2) ;x2
    (+ (max-h upper1 upper2 VSPACE-I) (image-height HSPACE-I)) ;y2
    "red")
   
   (+ (image-height VSPACE-I) (image-width upper1) (/ (image-width upper2) 2)) ;x1
   (max-h upper1 upper2 VSPACE-I) ;y1
   (/ (+ (* 2 (image-height VSPACE-I)) (image-width upper1) (image-width upper2)) 2) ;x2
   (+ (max-h upper1 upper2 VSPACE-I) (image-height HSPACE-I)) ;y2
   "red"))

; Person -> Image
; Vytvoří rodokmen
(define (render-pedigree person)
  (cond [(unknown? person) VIEW-U]
        [(person? person)
         (images-with-lines (pedigree-view-p person)
                            (render-pedigree (person-father person))
                            (render-pedigree (person-mother person)))]))


; render-pedigree zpracovává rekurzivní data - jedná se o rekurzivní funkci!
;(render-pedigree p8)


; Dnes budeme pokrčovat ve cvičení s podobnými strukturami!
(define-struct literal [value])
(define-struct conjuction [left right])
(define-struct negation [op])

; a měli bychom implementovat rekurzivní funkce, které budou tyto struktury
; evaluovat do Booleanu


; Design pomocí kompozice
;    Ukázka rodokmenu je přímou ukázkou nejen rekurze, ale také
;    kompozice funkcí. Jedná se o rozložení velkého problému (funkce
;    render-pedigree) na menší subproblémy (pomocné funkce - auxiliary functions).
;   Tvorba pomocných funkcí umožní lepší orientaci v kódu a zároveň
;    nám dovolí používat tyto funkce na více místech!

; Kdy vytvořit pomocnou funkci?
;    1. Kompozice hodnot (tedy to, co si funkce předávají)
;       vyžaduje domain-knowledge - např. kompozice dvou obrázků
;       určitým způsobem (images-with-lines)
;    2. Kompozice vyžaduje analýzu případů
;       (render-pedigree -> cond)
;    3. Kompozice hodnot musí pracovat se sebe-referujícími
;       daty (render-pedigree)
;    4. Často je také vhodné vytvořit *obecnější* funkci,
;       (main) pak bude jejím speciálním případem!

; Pomocné funkce s rekurzí
; Sample problem - funkce na setřízení listu

; List-of-numbers -> List-of-numbers 
; Seřadí list čísel alon sestupně
(check-expect (sort> '()) '())
(check-expect (sort> (list 3 2 1)) (list 3 2 1))
(check-expect (sort> (list 1 2 3)) (list 3 2 1))
(check-expect (sort> (list 1 5 -12 21 3 5 12))
              (list 21 12 5 5 3 1 -12))
(define (sort> alon)
  (cond
    [(empty? alon) '()]
    [else
     (insert (first alon) (sort> (rest alon)))]))


; Musíme ale zadefinovat funkci insert, která vloží číslici na správné místo v setříděném seznamu!

; Number List-of-numbers -> List-of-numbers
; Vloží číslici n do setříděného seznamu alon aby byla setříděnost zachována
(check-expect (insert 5 '()) (list 5))
(check-expect (insert 12 (list 20 -5))
              (list 20 12 -5))
(define (insert n l)
  (cond
    [(empty? l) (cons n '())]
    [else (if (>= n (first l))
              (cons n l)
              (cons (first l) (insert n (rest l))))]))

; V pomocné funkci již můžeme předpokládat setříděnost seznamu!

; Dokážete odhadnou složitost algoritmu (tj. kolik kroků bude muset provést pro
; list o délce N?)
; Později si ukážeme rekurzivní implementaci seřazení která bude rychlejší!