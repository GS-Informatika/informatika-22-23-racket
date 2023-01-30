;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |6.4|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
; Další práce s listy

; Problém - dostaneme seznam naměřených teplot, našim úkolem je
;  určit jejich průměr

(define ABSOLUTE0 -273.15)
; Celsius je Number větší než ABSOLUTE0

; List-of-temperatures je
; - '()
; - (cons Celsius List-of-temperatures)

; List-of-temperatures -> Number
; Určí průměr teplot
(define (average temps)
  (/ (sum temps) (how-many temps)))

; List-of-temperatures -> Number
; Určí součet teplot
(define (sum temps)
  ...)

; List-of-temperatures -> Number
; Určí kolik teplot je zaznamenaných v listu temps
(define (how-many temps)
  ...)

; Nastává problém - vstup '() ! Neumíme spočítat průměr z 0 pozorování!
; Potřebujeme upravit datový typ! Požadujeme, aby list nebyl prázdný!

; NEList-of-temperatures je
; - ??? (doplňte!)
; - (const Celsius NEList-of-temperatures)

; Otázka - bude sum a how-many fungovat i pro NEList? Proč?


; Pomocí rekurze ale také můžeme vytvářet listy!
(make-list 3 "ABC") ; vytvoří 3 kopie stringu "ABC"
; Zkusme vytvořit podobnou funkci sami

; Zpět k přirozeným číslům!

; NaturalNumber Any -> List-of-any
; Vytvoří list s n kopiemi a
#|
(check-expect (copy 0 "a") '())
(check-expect (copy 2 "a") (cons "a" (cons "a" '())))
(check-expect (copy 2 (make-posn 1 2)) (cons (make-posn 1 2) (cons (make-posn 1 2) '())))
(define (copy n a)
  '())
|#

; Potřebujeme rekurzivně volat (cons a ...) pomocí funkce copy, než narazíme na base-case, kde předáme '()
; Co je base case!?
; Určete - jedná se o iteraci? Zdůvodněte!

; Nadesignujme nyní funkci row, která vytvoří n kopií obrázku img vedle sebe (v řádku)

(define TSQR (square 10 "outline" "black"))
; Number Image -> Image
; Vytvoří n kopií obrázku vedle sebe
(check-expect (row 0 TSQR) empty-image)
(check-expect (row 1 TSQR) TSQR)
(check-expect (row 4 TSQR) (beside TSQR TSQR TSQR TSQR))
(define (row n img)
  (if (zero? n) empty-image
      (beside img (row (sub1 n) img))))


;;; Procvičovací úlohy
;; Nadesignujte funkci col, aby vytvářela n kopií obrázku img pod sebe (ve sloupci).
;; Nezapomeňte sepsat hlavičku, účel a testy!

(define (col n img)
  ...)


;; Spojte funkce col a row a nadesignujte
;; 1) Funkci grid (Number Number Image -> Image), která vytvoří a x b mřížku obrázků img
;; 2) Funkci place-pts (Image List-of-posn -> Image) která vloží do obrázku z argumentu
;;    na každou souřadnici v listu posn struktur červenou tečku (circle 6 "solid" "red")