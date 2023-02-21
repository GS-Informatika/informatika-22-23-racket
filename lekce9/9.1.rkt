;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |9.1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/web-io)
; Quotes a Symboly

; Již jsme si ukázali funkci
(list 1 2 3 4)
; nicméně už od pozdních 50. let minulého století LISP-ové jazyky
; mají mnohem silnější nástroj pro tvorbu listů - quotation (quotace/kvotace) a
; anti-quotation

; V běžných programovacích jazycích se s tímto konceptem setkáváme běžně,
; např. PHP bylo celé postavené kolem tohoto konceptu, moderní javascript/typescript frameworky
; jej znovu-objevují ve formě jsx expressions

; -------------- Quote --------------
; quote je klíčové slovo pro "složenou větu"
(quote (1 2 3 4))
; nebo standardněji
'(1 2 3 4)

; Další příklady
'("a" "b" "c")

'(#t "test" 255)

; Zatím se (quote ...) zdá to samé jako (list ...)
; Zkusme ale
'(("a" 1)
  ("b" 2)
  ("c" 3))

; Můžeme jednoduše konstruovat vnořené listy!

; -------- Jak Quote Funguje? --------

; Quote má v určitém smyslu rekurzivní strukturu
;(quote ((1 2) (3 4))) ; se přeloží na
;(list (quote (1 2)) (quote (3 4)))

; Rekurzivní struktura ale znamená, že
;'(1 2 3)
; je vlastně
;(list '1 '2 '3)
; a stejně quote funguje na základní datové typy!

; Důležité - O listech stále přemýšlejte ve smyslu cons!
; To že máme "hezký" konstruktor nemění samotnou strukturu listu!


; -------- Quasiquote a Unquote, Symboly --------

; Zkusme experiment! Co očekáváte jako výsledek následujícího quote?
(define x 42)
;'(40 41 x 43 44)

; Vidíme hodnotu, se kterou jsme se nikdy dříve nesetkali
; (setkali jsme se ale s podobnou - vzpomeňte si na 'stdin a 'stdout v batch-io)!
; Jedná se o tzv. symbol.

;'(1 (+ 2 1) 3)

; Symbol nemá žádnou spojitost s funkcí, i když může nést "stejné jméno".
; V některých případech ale chceme uvnitř quote vyhodnotit nějáký výraz.
; K tomu slouží quasiquote a unquote
;(quasiquote (1 2 3))
;`(1 2 3)
; Quasiquote se chová na první pohled stejně jako quote
; Uvnitř quasiquote ale můžeme provést unquote
;(quasiquote (1 2 (unquote (+ 1 2)) 4))
;`(1 2 ,(+ 1 2) 4)

; -------- Konstrukce HTML pomocí quasiquote a unquote --------

(define (my-web-page author title)
  `(html
    (head
     (title ,title) ; unquote proměnné title - doplní se z argumentu funkce
     (meta ((http-equiv "content-type")
            (content "text-html"))))
    (body
     (h1 ,title) ; další unquote proměnné
     (p "Autor stránky: " ,author ".")))) ; a další unquote!

;(show-in-browser (my-web-page "Dan" "Webovka!"))

; -------- Unquote - splicing --------

(define (make-row l)
  (if (empty? l) '()
      (cons (number->string (first l)) (make-row (rest l)))))

;`(tr ,(make-row '(3 4 5)))

; Co když ale chceme aby výsledkem bylo
;'(tr "3" "4" "5") ; tedy nechceme nested (vnořený) list?

; unquote-splicing toto řeší - vnořený list "vloží" do vnějšího!
;`(tr ,@(make-row '(3 4 5)))
;`(tr "a" ,@(make-row '(3 4 5)) ,@(make-row '(6 7 8)))

; -----------------------------------------------------------------------

; Procvičovací úloha:
; Přepište definici make-row, aby vytvářela list HTML prvků td.
; Napište funkci make-table, která bude mít argumenty
; - list stringů head
; - list listů čísel content
; a vytvoří reprezentaci HTML tabulky.
; Pro referenci použíjte například https://www.w3schools.com/html/html_tables.asp
; Použíjte funkci show-in-browser
; a ujistěte se, že vámi vytvořená tabulka se zobrazuje správně!
