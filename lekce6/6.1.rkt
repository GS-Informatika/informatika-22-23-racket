;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |6.1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Intermezzo - více k testování funkcí

; Setkali jsme se zatím s
(check-expect (+ 1 2) 3) ; equal? porovnání
; (check-expect testovaný-výraz očekávaný-výsledek)

; Ne vždy však lze napsat test, který pracuje s přesnou hodnotou výrazu
; Proto existují další "test formy".

 ; Porovnání s několika možnými hodnotami
(check-member-of (random-next-traffic-light "red") "green" "yellow")
(define (random-next-traffic-light current)
  (cond [(string=? current "red") (if (= (random 2) 0) "green" "yellow")]
        [(string=? current "yellow") (if (= (random 2) 0) "green" "red")]
        [(string=? current "green") (if (= (random 2) 0) "red" "yellow")]))

; Test na hodnotu s tolerancí pro nepřesná čísla (inexact?)
(check-within (make-posn (sin pi) (sin (* 2 pi))) (make-posn 0 0) 0.00001)

; Test na hodnotu uvnitř intervalu
(check-range (sin (random 200)) -1 1)

; Test na error
(check-error (/ 1 0))

; Test s náhodnými čísly - zajistí, že testovaný výraz i očkávaný výraz mají (random n)
;  nahrazené za stejná náhodná čísla
(check-random (make-random-posn 5 6) (make-posn (random 5) (random 6)))
(define (make-random-posn x y)
  (if (or (< x 1) (< y 1)) (error "Očekávané kladné číslo!")
      (make-posn (random x) (random y))))

; Test na predikát - výsledek testovaného výrazu musí splňovat zadaný predikát
(check-satisfied (make-posn 4 5) posn?)