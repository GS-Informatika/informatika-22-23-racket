;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |3.1|) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Programy

; Batchové programy - vezmou veškerý vstup, provedou "výpočet" (nejen matematický!),
; vrátí výsledek.

; Interaktivní programy - čekají na uživatelské vstupy, které zpracují a vytvoří "výstup".
; Pak čekají na další uživatelský vstup.
; Provedení vstupu uživatelem říkáme "event" (událost) - např. kliknutí myší, odeslání formuláře, ...
; Interaktivní programy také nazýváme "event-driven programy". Main funkce takového programu pak
; zajišťuje volání funkcí v závislosti na typu eventu (dispatching a event handlery).

; Zaměříme se na interakci skrze GUI.

; Zjednodušeně:
; Po spuštění interaktivníhol programu dojde k notifikaci OS o "eventech" které chceme dostávat, když
; uživatel provede nějákou akci kterou "posloucháme" (máme na ni handler) tak OS informuje náš program.


; Začněme Batchovými programy

; 2htdp/batch-io teachpack
; budeme psát programy které přečtou vstup ze souboru (nebo více souborů)
; a vytvoří výstup do souboru (nebo více souborů)

; funkce write-file - zapíše string do souboru, vrátí jméno souboru jako string
(write-file "ukazka1.txt" "12345, text")

; funkce read-file - přečte celý soubor jako string
(read-file "ukazka1.txt")
; Co se stane, když tento kód pustíme několikrát?

; stdin a stdout - standardní vstup a výstup - speciální "tokeny",
; říkají že nechceme pracovat se soubory, ale se vstupem který určí OS
; Běžně je to přímý uživatelský vstup stringu a výstp do konzole / interakční oblasti
; Později si ukážeme piping, který nám umožní spojovat stdin a stdout různých procesů
; Poznámka - EOF znamená END OF FILE - speciální "znak", který říká "toto je konec souboru".
; Funkce read-file čte dokud nenarazí na tento "znak"!

;(write-file 'stdout (read-file 'stdin))

; Napišme funkce na převod jednotek teploty
; Pro převod K->°C platí
; x K = (x - 273.15) °C
; Pro převod °C->F platí
; x °C = (x * 9/5 + 32) F

; Jak budou vypadat inverzní vztahy? Jak bude vypadat převod K->F a zpět?
; Zkuste dopsat všechny funkce!

(define (K->C k)
  (- k 273.15))

(define (C->K c)
  ...)

(define (C->F c)
  (+ 32 (* 9/5 c)))

(define (F->C f)
  ...)

(define (K->F k)
  ...)

(define (F->K f)
  ...)

; Jak pak bude vypadat takový batch program na převod jednotek?
; Začněme jednoduše - program, který převede °C->F
(define (convert/C->F in out)
  (write-file out
              (string-append
               (number->string (C->F (string->number
                                      (read-file in))))
               "\n")))

; Zkuste popsat všechny kroky tohoto programu

; Zkusme dát uživateli možnosti volby inverzních vztahů
#|
(define (read-input in-file)
  (string->number (read-file (if (string=? "stdin" in-file)
                                 'stdin
                                 in-file))))

(define (write-output out-file result)
  (write-file (if (string=? "stdout" out-file)
                  'stdout
                  out-file)
              (string-append (number->string result)
                             "\n")))

(define (valid-unit? unit)
  (or (string=? unit "K") (string=? unit "C") (string=? unit "F")))

(define (string2=? a1 a2 b1 b2)
  (and (string=? a1 a2) (string=? b1 b2)))

(define (get-result in-unit out-unit number)
  ; Kam by bylo vhodné přesunout první a druhou podmínku pro lepší UX (user experience - jak je program příjemný pro uživatele)?
  (cond [(not (valid-unit? in-unit)) (error (string-append in-unit " není validní jednotka"))]
        [(not (valid-unit? out-unit)) (error (string-append out-unit " není validní jednotka"))]
        [(string=? in-unit out-unit) number]
        [(string2=? "K" in-unit "C" out-unit) (K->C number)]
        [(string2=? "C" in-unit "K" out-unit) (C->K number)]
        [(string2=? "C" in-unit "F" out-unit) (C->F number)]
        [(string2=? "F" in-unit "C" out-unit) (F->C number)]
        [(string2=? "K" in-unit "F" out-unit) (K->F number)]
        [(string2=? "F" in-unit "K" out-unit) (F->K number)]
        [else (error)]))
        ; Později se naučíme, jak využít koncept funkcí vyššího řádu (higher order functions) a datových struktur,
        ; abychom podobný kód napsali jednodušeji

; main
(write-file 'stdout "\nVstupní jednotka (C | K | F)\n")
(define in-unit (read-file 'stdin))
(write-file 'stdout "\nVýstupní jednotka (C | K | F)\n")
(define out-unit (read-file 'stdin))
(write-file 'stdout "\nVstupní soubor (stdin | <string>)\n")
(define in-file (read-file 'stdin))
(write-file 'stdout "\nVýstupní soubor (stdout | <string>)\n")
(define out-file (read-file 'stdin))

(write-output out-file
              (get-result in-unit
                          out-unit
                          (read-input in-file)))
|#



;;; Procvičovací úlohy

;; Napište funkci, která bere za argument momentální stav semaforu ("red" "orange" "green") a vrátí následující.
(define RED "red")
(define ORANGE "orange")
(define GREEN "green")

(define (traffic-light-next state)
  ...)


;; Napište funkci, která převádí kilometry na míle.
;; Napište batch program (tzn. funkci main), který za argument bude brát vstupní soubor a výstupní soubor
;; a provede převod kilometry -> míle.
;; Zkuste využít podmínku if a proveďte (error ...) který vypíše že vstup není číslo.

(define (km->mile ...)
  ...)

(define (main-km->mile  ...)
  ...)


;; Napište batch program, který nahradí všechna upper-case písmena (velká písmena - A, B, C, D, ...) na vstupu 
;; lower-case písmeny (malá písmena - a, b, c, d ...)
(define (main-to-lower in out)
  ...)