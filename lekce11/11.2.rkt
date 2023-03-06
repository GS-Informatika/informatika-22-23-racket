;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |11.2|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Abstrakce v ISL

; List konstruktor
;(build-list 3 add1)

; List -> List
;(filter odd? '(1 2 3 4 5 6 7))

;(sort '(1 2 3 4 5 6 7 8 9) >)

;(map add1 '(1 2 3 7 8 9))

; List -> Boolean (redukce)

;(andmap odd? '(1 2 3 4 5 6))

;(ormap odd? '(1 2 3 4 5 6))

; Redukce binárním operátorem

(foldr + 0 '(1 2 3 4 5))
(foldl + 0 '(1 2 3 4 5))

; Kdy bude rozdíl ve volání foldl a foldr při použití stejné funkce, listu a výchozí hodnoty?
