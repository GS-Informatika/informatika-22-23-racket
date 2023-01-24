;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |5.4|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)
; Designování se strukturami

; Ukázkový problém:
;  Nadesignujte funkci, která určí vzdálenost
;  dvou objektů ve 3D prostoru

; 1) Definice dat - vytvořme strukturu!





; 2) Využíjme tuto strukturu ve funkci!







; ---------------------------------------------------------

; Grafický textový editor

(define-struct editor [pre post])
; Editor je struktura:
;    (make-editor String String)
; interpretace: (make-editor s t) popisuje textový editor
;    kde je text (string-append s t) s kurzorem zobrazeným
;    mezi s a t

; String -> String
; Vrátí první písmeno str jako String,
; pro prázdný str vrátí opět prázdný string.
(check-expect (string-first "abcd") "a")
(check-expect (string-first "x") "x")
(check-expect (string-first "") "")
(define (string-first str)
  (if (< (string-length str) 1)
      ""
      (string-ith str 0)))

; String -> String
; Vrátí poslední písmeno str jako String,
; pro prázdný str vrátí opět prázdný string
(check-expect (string-last "") "")
(check-expect (string-last "z") "z")
(check-expect (string-last "xyzw") "w")
(define (string-last str)
  (if (< (string-length str) 1)
      ""
      (string-ith str (- (string-length str) 1))))

; String -> String
; Vrátí string bez prvního písmene. Pro prázdný string vrátí opět prázdný string.
(check-expect (string-rest "abc") "bc")
(check-expect (string-rest  "ab") "b")
(check-expect (string-rest  "a") "")
(check-expect (string-rest "") "")
(define (string-rest str)
  (if (< (string-length str) 2)
      ""
      (substring str 1)))

; String -> String
; Vrátí string bez posledního písmene.
; Pro prázdný string vrátí opět prázdný string.
(check-expect (string-remove-last "") "")
(check-expect (string-remove-last "z") "")
(check-expect (string-remove-last "xyzw") "xyz")
(define (string-remove-last str)
  (if (< (string-length str) 2)
      ""
      (substring str 0 (- (string-length str) 1))))

; Editor KeyEvent -> Editor
; Vyhodnocuje KeyEventy na nový stav editoru
(define (editor-key-handler cw ke)
  (if (> (string-length ke) 2)
      (cond [(key=? ke "left") (make-editor (string-remove-last (editor-pre cw))
                                            (string-append (string-last (editor-pre cw)) (editor-post cw)))]
            [(key=? ke "right") (make-editor (string-append (editor-pre cw) (string-first (editor-post cw)))
                                             (string-rest (editor-post cw)))]
            [else cw])
      (cond [(key=? ke "\b") (make-editor (string-remove-last (editor-pre cw)) (editor-post cw))]
            [(or (key=? ke "\t") (key=? ke "\r")) cw]
            [else (make-editor (string-append (editor-pre cw) ke) (editor-post cw))])))

; Editor -> Image
; Vykreslí momentální stav editoru
(define (editor-draw cw)
  (overlay/align "left" "center"
                 (beside (text (editor-pre cw) 16 "black")
                         (rectangle 1 20 "solid" "red")
                         (text (editor-post cw) 16 "black"))
                 (empty-scene 200 20)))

; String -> Editor
; Spustí "grafický textový editor"
(define (editor-main txt)
  (big-bang (make-editor txt "")
    [to-draw editor-draw]
    [on-key editor-key-handler]))