;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |9.2|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

; FSM (FSA) - Finite State Machines (Finite State Automata)
; Konečné automaty - tvoří je pětice (S, Σ, σ, s, F)
;  S - množina stavů - Všechny hodnoty kterých může náš automat nabývat.
;  Σ - abeceda - Množina vstupních symbolů, to jak interagujeme s automatem.
;  σ - přechodová funkce/tabulka - Funkce S ⨉ Σ → S (pro deterministický automat).
;      Určuje následující stav při záznamu nějákého vstupního symbolu
;  s - počáteční stav
;  F - množína finálních stavů (ukončení běhu automatu) - Pokud automat dojde do tohoto stavu,
;      říkáme že vstup "přijal"

; Všimněte si - toto odpovídá struktuře našich big-bang programů!

; ---------------------------------------- Sample problem ----------------------------------------
; Vyrobme si FSM sloužící jako "keypad zámek" (elektronický zámek na číselnou kombinaci).
; Cílem je zadat správnou kombinaci, např. 1276, která "otevře" sejf. Otevřený sejf následně
; klávesou 'c' zase uzavřeme. Ukončíme stiskem klávesy 'e'.

; ------------------------------------------------------------------------------------------------

; M4Num-String je String
; který má maximálně 4 charaktery,
; všechny jsou číselné

; M3Num-String je String
; který má maximálně 3 charaktery,
; všechny jsou číselné

; 1Num-String je 1String s
; který splňuje (string-numeric? s)

; WS je jedno z
; - M4Num-String
; - 'open
; - 'wrong
; - 'end
; interpretace: Udává momentální zadaný kód, nebo speciální stav sejfu

(define OPEN-COMBINATION "1276")
(define OPEN-IMG (bitmap/file "safe-open.png"))
(define CLOSE-IMG (bitmap/file "safe-close.png"))
(define WRONG-IMG (bitmap/file "safe-wrong.png"))

; M3Num-String 1Num-String -> WS
; Určí nový stav na základě (string-append s n)
(define (check-lock s n)
  (cond [(string=? (string-append s n) OPEN-COMBINATION) 'open]
        [(= (string-length (string-append s n)) (string-length OPEN-COMBINATION)) 'wrong]
        [else (string-append s n)]))

; WS KeyEvent -> WS
; Přiřadí nový stav na základě stisku klávesy
(define (safe-key-handler s k)
  (cond [(key=? k "e") 'end]
        [(and (key=? k "c") (eq? s 'open)) ""]
        [(and (string-numeric? k) (eq? s 'wrong)) k]
        [(and (string-numeric? k) (string? s)) (check-lock s k)]
        [else s]))

; WS -> Image
; Vykreslí sejf na základě stavu
(define (draw-safe s)
  (cond [(eq? s 'open) OPEN-IMG]
        [(eq? s 'wrong) WRONG-IMG]
        [(eq? s 'end) (overlay (text "END" 32 "red") CLOSE-IMG)]
        [else (overlay (text (replicate (string-length s) "*") 32 "red") CLOSE-IMG)]))

; WS -> Boolean
; Predikát porovnání s 'end
(define (safe-end? s)
  (eq? s 'end))

; WS -> WS
; big-bang pro sejf
(define (safe-main s)
(big-bang s
  [to-draw draw-safe]
  [on-key safe-key-handler]
  [stop-when safe-end? draw-safe]))

; ------------------------------------------------------------------------------------------------

; Určete jednotlivé prvky FSM (S, Σ, σ, ...) v programu sejfu!


; --------------------------------------- Sample problem 2 ---------------------------------------
; Vyrobme FSM pro regex pattern  a (b|c)* d na vstupu. Program začíná s bílým 200 ⨉ 200 čtvercem,
; dokud uživatel zadává vstup podle regexu, čtverec bude mít žlutou barvu, dokončením vstupu se
; obarví na zeleno, při chybném vstupu se stane červeným.

; ------------------------------------------------------------------------------------------------

(define SQUARE-SIZE 200)

; State je jedno z
; - 'initial
; - 'bcd
; - 'final
; - 'error

; FSM-WS je
; (make-fsm State String)
(define-struct fsm-ws [state input])
(define IN (make-fsm-ws 'initial ""))

; KeyEvent -> FSM-WS
; Určí nový stav po stisknutí první klávesy
(define (handle-initial k)
  (if (key=? k "a")
      (make-fsm-ws 'bcd k)
      (make-fsm-ws 'error k)))

; FSM-WS State KeyEvent -> FSM-WS
; Vytvoří nový stav nastavením State jako "ns" a připojením "k"
; do předchozího inputu "s"
(define (state/append s ns k)
  (make-fsm-ws ns (string-append (fsm-ws-input s) k)))

; FSM-WS KeyEvent -> FSM-WS
; Určí nový stav po stisknutí klávesy při momentálním stavu s 'bcd
(define (handle-bcd s k)
  (cond [(or (key=? k "b")
             (key=? k "c")) (state/append s 'bcd k)]
        [(key=? k "d") (state/append s 'final k)]
        [else (state/append s 'error k)]))

; FSM-WS -> Image
; Vytvoří obrázek s textem momentálního vstupu
(define (state->textimg s)
  (text (fsm-ws-input s) 20 "black"))

; FSM-WS -> Image
; Vytvoří obrázek pro koncový stav FSM
(define (draw-end s)
  (overlay (state->textimg s)
           (if (eq? (fsm-ws-state s) 'error) (square SQUARE-SIZE "solid" "red")
               (square SQUARE-SIZE "solid" "green"))))

; FSM-WS -> Image
; Vytvoří obrázek pro stav FSM
(define (draw-state s)
  (overlay (state->textimg s)
           (if (eq? (fsm-ws-state s) 'initial) (square SQUARE-SIZE "solid" "white")
               (square SQUARE-SIZE "solid" "yellow"))))

; FSM-WS KeyEvent -> FSM-WS
; KeyHandler pro FSM
(define (fsm-key-handler s k)
  (cond [(eq? (fsm-ws-state s) 'initial) (handle-initial k)]
        [(eq? (fsm-ws-state s) 'bcd) (handle-bcd s k)]
        ; Přeskočíme klávesy šipek
        [(< 1 (string-length k)) s]))

; FSM-WS -> Boolean
; Predikát pro finální stav FSM
(define (fsm-end? s)
  (or (eq? (fsm-ws-state s) 'error) (eq? (fsm-ws-state s) 'final)))

; FSM-WS -> FSM-WS
; Program FSM
(define (fsm-main s)
  (big-bang s
    [on-key fsm-key-handler]
    [to-draw draw-state]
    [stop-when fsm-end? draw-end]))

; ------------------------------------------------------------------------------------------------

; Procvičovací úloha:
; Přepište FSM pro sejf, aby přešel do stavu 'wrong už ve chvíli, kdy
; se zadá první číslice, která "nesedí" (tedy při správném kódu 1276, pokud
; uživatel zadá 1 - 3, FSM přejde do stavu 'wrong
