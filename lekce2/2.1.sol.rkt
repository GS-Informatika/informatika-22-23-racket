;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 2.1.sol) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
;;; Procvičovací příklady
;; Napište funkci distance měřící (Euklidovskou) vzdálenost (x, y) od počátku (0, 0) souřadného systému. Využíjte znalost Pythagorovy věty.
(define (distance/origin x y)
  (sqrt (+ (sqr x) (sqr y))))


;; Vytvořte funkci string-first, která z *neprázdného* stringu vrátí první znak.
; Ukázka:
; (string-first "test") = "t"
; (string-first "7ABC") = "7"
(define (string-first str)
  (substring str 0 1))


;; Vytvořte funkci image-area, která spočítá celkový počet pixelů daného obrázku.
; Ukázka:
; (image-area (square 10 "outline" "red")) = 100
(define (image-area img)
  (* (image-width img) (image-height img)))


;; Napište funkci string-delete, která odstraní n-tý znak ze stringu s. Ošetřete možnost prázdného strignu. Očekávejte, že číslo na vstupu n je 0 <= n < (string-length s).
; Ukázka:
; (string-delete 0 "abc") = "bc"
; (string-delete 2 "cadr") = "car")
(define (string-delete n str)
  (string-append (substring str 0 n) (substring str (add1 n))))