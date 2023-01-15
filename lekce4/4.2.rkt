;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |4.2|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)
; WorldState: data reprezentující momentální world (cw - momentální svět, momentální stav)

; WorldState -> Image
; big-bang v případě potřeby volá tuto funkci pro převod stavu na renderovaný obrázek
(define (render cw)
  ...)

; WorldState -> WorldState
; big-bang každý tick vytvoří nový stav z momentálního stavu voláním této funkce
(define (tick-handler cw)
  ...)

; WorldState String -> WorldState
; Při každém stisknutí klávesy big-bang zavolá tuto funkci pro vytvoření nového stavu,
; argument ke reprezentuje klávesu
(define (key-handler cw ke)
  ...)

; WorldState Number Number String -> WorldState
; big-bang zavolá tuto funkci pro každou akci, kterou uživatel provede myší,
; pro vytvoření nového stavu, argumenty x a y jsou souřadnice myši, me je typ eventu
(define (mouse-handler cw x y me)
  ...)

; WorldState -> Boolean
; big-bang tuto funkci evaluuje po každém eventu,
; pokud vrátí #t big-bang program dále nepracuje
(define (end? cw)
  ...)


;;; Procvičovací úkoly

; Vytvořte jednoduchý big-bang program. Doplňte templaty handlerů.
; Upravte jejich účel, aby odpovídal tělu funkcí. Pokud zavedete vlastní
; funkce, ujistěte se že mají signaturu a účel. Zkuste navrhnout testy pro
; vámi definované a nadesignované funkce!