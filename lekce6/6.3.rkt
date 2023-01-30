;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |6.3|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Programování s listy

; Sample problem
;  Pracujete na seznamu kontaktů pro mobilní aplikaci. Vaším úkolem je
;  napsat funkci, která bere za argument list jmen 'l' a string 's' a určí, jestli
;  se v 'l' nachází člověk s křestním jménem 's'

; List-of-names je jedno z:
; - '()
; - (cons String List-of-names)
; intepretace: list jmen lidí


; 1) Napišme hlavičku funkce a testy

; String List-of-names -> Boolean
; Určí, jestli list l obsahuje jméno s
#|
(check-expect (contains-name? "Pavel" '()) #false)
(check-expect (contains-name? "Pavel" (cons "Petr" (cons "Josef" '()))) #false)
(check-expect (contains-name? "Pavel" (cons "Pavel" '())) #true)
(check-expect (contains-name? "Pavel" (cons "Petr" (cons "Pavel" '()))) #true)
(define (contains-name? s l)
  #false)
|#

; 2) Napišme template funkce - rozmyslete, jak může vypadat list 'l' na vstupu!
; 3) Doplňme definici funkce (pomocí or)


; Dostáváme funkci, která odkazuje sama na sebe!
; Neměli bychom být překvapeni! Je to funkce, která pracuje s daty, které odkazují
; samy na sebe!

; Zkusme ještě jinou implementaci! (if)


; Která implementace je pro vás jasnější? Zkuste vysvětlit!

; Rozmysleme, jak přesně postupuje naše funkce na konkrétních datech:
(define data
  (cons "Fagan"
        (cons "Findler"
              (cons "Fisler"
                    (cons "Flanagan"
                          (cons "Flatt"
                                (cons "Felleisen"
                                      (cons "Friedman" '()))))))))
;(contains-name "Felleisen" data)

; Při návrhu sebe-odkazujících data a designu funkcí pracujících s takovými daty musíme
;  zajistity, aby
;  1) alespoň jedna klauzule v definici sebe-odkazujících dat nesmí odkazovat sama na sebe
;     (např. '() v listu) - tzv. base cases (základní případ)
;  2) taková data šla vytvořit - pokud z definice dat nedokážete vytvořit ukázková data,
;     není validní
; Zbytek designovacího zůstává stejný, ale
;  1) při psaní účelu funkce se zaměřte na to *co* funkce dělá a ne *jak* to dělá!
;  2) při psaní testů se pokuste zahrnout base cases i složitější konstrukce
;  3) při psaní template formulujte příslušný "cond" s jednotlivými větvemi (klauzulemi)
;     které odpovídají klauzulím v definici dat (např. pro list je to [(empty? ...) ...]
;     a [(cons? ...) ...]). První v cond budou base cases.

; Volání na sama sebe uvnitř funkce nazýváme *rekurze*
; (ve speciálním případě můžeme nazývat *iterace* - ukážeme si!)

; Rekurzivní definice přirozených čísel - Peano-Dedekindovy axiomy

; 1)! 0 je přirozené číslo
; 2)  Pro každé přirozené číslo x platí x = x (reflexivita)
; 3)  Pro každá přirozená čísla x a y, pro která platí x = y platí i y = x (symetrie)
; 4)  Pro každá přirozená čísla x, y a z, pro která platí x = y a y = z,
;     platí i x = z (transitivita)
; 5)  Pro všecha x a y platí že pokud x = y a x je přirozené číslo, pak i y je přirozené číslo
;     (uzavřenost nad =)
; 6)! Pro každé přirozené číslo n, existuje přirozené číslo S(n)
; 7)! Pro každá přirozená číslo m, n, pro která S(n) = S(m) platí m = n
; 8)! Neexistuje přirozené číslo n pro které S(n) = 0
; 9)! K je množina že 0 je v K a pro každé n v K platí, že S(n) je v K, pak K
;     je množina přirozených čísel (indukční axiom, "no junk" axiom)

; Převeďme na definici dat!

; NaturalNumber je jedno z:
; - 0
; - (add1 N)
; interpretace: reprezentace přirozených čísel

; add1 můžeme považovat za konstruktor, sub1 pak za selektor!

; Máme predikáty (zero? ...) a (positive? ...) !

; Pro sčítání pak platí
; 1) a + 0 = a
; 2) a + S(b) = S(a + b)
; (! implikuje a + S(b) = S(a) + b !)

; Zaveďme si funkci sčítání podle implikovaného předpisu

; Number -> Number
; a + b
(check-expect (peano-add 0 2) 2)
(check-expect (peano-add 2 0) 2)
(check-expect (peano-add 3 2) 5)
(check-expect (peano-add 6 4) 10)
(define (peano-add a b)
  (if (zero? b) a
      (peano-add (add1 a) (sub1 b))))

; A podle předpisu a + S(b) = S(a + b)

; Number -> Number
; a + b
(check-expect (peano-add2 0 2) 2)
(check-expect (peano-add2 2 0) 2)
(check-expect (peano-add2 3 2) 5)
(check-expect (peano-add2 6 4) 10)
(define (peano-add2 a b)
  (if (zero? b) a
      (add1 (peano-add2 a (sub1 b)))))

;(peano-add 5 4)
;(peano-add2 5 4)
; Zkusme rozepsat, jak budou tyto funkce postupovat
; 1) na papír / tabuli
; 2) ve stepperu

; Všimněte si rozdílu v jednotlivých krocích vyhodnocení!
; Dokážete určit který předpis vede na rychlejší algoritmus?

; (peano-add a b) je *iterace* (tail recursion)
; (peano-add2 a b) je obecná rekurze