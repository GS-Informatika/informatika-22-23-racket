;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |7.1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/batch-io)
; Listy listů, listy v souborech

; V dřívější lekci jsme si ukázali (read-file) pro čtení dat ze souboru.
; (read-file) reprezentuje textové soubory jako string.

; Jaké další reprezentace v rámci našich datových struktur vás napadnou?

(define file-in "input.txt")

(define r1 (read-file file-in))
(define r2 (read-lines file-in))
(define r3 (read-words file-in))
(define r4 (read-words/line file-in))

; Porovnejme!

; Definujme funkci která nám vrátí list s počtem slov na každém řádku!
; Jaký datový typ se bude hodit?

(define (words-on-line lls)
  (cond [(empty? lls) '()]
        [else
         (cons (length (first lls))
               (words-on-line (rest lls)))]))

;(words-on-line r4)


; Další funkce pro práci s listy

; "list" konstruktor -> (list exp-1 ...+)

(list 1 2 3 4 5)

(define 1strings (explode "abcd"))

(implode 1strings)