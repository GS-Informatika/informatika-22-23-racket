;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |10.1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; ------------------- ABSTRAKCE -------------------

;   Spousta funkcí a definic, se kterými jsme se setkali, vypadá velmi podobně.
; Např. definice listu čísel a stringů se vlastně liší jen datovým typem.
; Funkce (list-contains? l) je vlastně úplně stejná jak pro list čísel, tak
; pro list stringů, případně pro list libovolného datového typu!

;   Tyto podobnosti jsou ale problematické - v kódu běžně vedou na repetici,
; kdy programátor zkopíruje existující kód a případně jej lehce upraví pro
; požadovaný účel

;   Jaký je rozdíl mezi těmito funkcemi?

; List-of-Strings -> Boolean
(define (contains-string? l str)
  (cond [(empty? l) #f]
        [(string=? (first l) str) #t]
        [else (contains-string? (rest l) str)]))

; List-of-Numbers -> Boolean
(define (contains-number? l str)
  (cond [(empty? l) #f]
        [(= (first l) str) #t]
        [else (contains-number? (rest l) str)]))

;   Kopírování kódu sebou nese velký problém - kopírují se chyby!
; Dále je složitější přizpůsobit takový kód změnám požadavků!

;   Programátoři se snaží redukovat podobnosti jak jen to programovací
; jazyk dovolí. Nejprve si tedy děláme "draft" programu, ve kterém se
; snažíme najít podobnosti a následně draft upravit tak, abychom se jich
; zbavili. Toho dosáhneme pomocí abstrakce.

; ------- ABSTRAKCE FUNKCÍ -------

;   Zkuste vymyslet - jak provést abstrakci následujících funkcí?

; List-of-Strings -> Boolean
(define (contains-10-letter-string? l)
  (cond [(empty? l) #f]
        [(= (length (first l)) 10) #t]
        [else (contains-10-letter-string? (rest l))]))

; List-of-Strings -> Boolean
(define (contains-8-letter-string? l)
  (cond [(empty? l) #f]
        [(= (length (first l)) 8) #t]
        [else (contains-8-letter-string? (rest l))]))

;   Programátoři jsou líní!

;   Popište rozdíly mezi funkcemi. Navrhněte abstrakci.

; List-of-Numbers -> List-of-Numbers
(define (add5/list l)
  (cond [(empty? l) '()]
        [else (cons (+ (first l) 5)
                    (add5/list (rest l)))]))

; List-of-Numbers -> List-of-Numbers
(define (add8/list l)
  (cond [(empty? l) '()]
        [else (cons (+ (first l) 8)
                    (add5/list (rest l)))]))

; List-of-Numbers -> List-of-Numbers
(define (multiply5/list l)
  (cond [(empty? l) '()]
        [else (cons (* (first l) 5)
                    (add5/list (rest l)))]))

;   Pro první dvě funkce je abstrakce stejná jako v předchozích případech.
; Pro abstrakci nad všmi třemi funkcemi najednou ale musíme zajít trochu dále.


; Operation je jedno z
; - 'multiply
; - 'add

; List-of-Numbers Operation Number -> List-of-Numbers
(define (operation/list op l num)
  (cond [(empty? l) '()]
        [(eq? op 'multiply) (cons (* (first l) num)
                                  (operation/list op
                                                  (rest l)
                                                  num))]
        [(eq? op 'add) (cons (+ (first l) num)
                             (operation/list op
                                             (rest l)
                                             num))]))

;   Zdá se ale, že jsme jen "přesunuli" opakování dovnitř funkce!
; Toto tedy není ten nejlepší přístup!

;   Zkusme to ještě jednou! Definujme funkci ve tvaru
(define (operation/list.v2 op l num)
  (cond [(empty? l) '()]
        [else (cons (op (first l) num)
                    (operation/list.v2 op (rest l) num))]))

;   STOP! Zkuste vysvětlit, jaký datový typ má parametr op!?
; Všimněte si jak jej používáme! Má tato definice smysl?

;   V rámci BSL/BSL+ tato definice není sémanticky správná.
; My se ale nyní přesuneme do ISL (Intermediate Student Language)
; ve které je toto povoleno.

;   Podívejme se ještě na jeden příklad - chceme filtrovat listy
; podle čísla (vybrat sub-list menších/větších čísel než je nějáké číslo
; v parametru)
; Jak by takové funkce na filtrování (larger l t) a (smaller l t) vypadaly?

;   Abstrakce takových funkcí bude vypadat takto
(define (extract P l t)
  (cond [(empty? l) '()]
        [(P (first l) t) (cons (first l)
                               (extract P (rest l) t))]
        [else (extract P (rest l) t)]))

;   Tato funkce "filtruje list" na základě predikátu P.
; Jaký datový typ má predikát P?

; ---- Procvičovací úloha ----
; Napište testy pro funkce (operation/list.v1 op l num) a (extract P l t).



; ----------------------------


;   Pomocí (extract P l t) nyní můžeme definovat specifičtější funkce které jsme požadovali
; velmi jednoduše

; List-of-Numbers Number -> List-of-Numbers
(define (smaller l t)
  (extract < l t))

; List-of-Numbers Number -> List-of-Numbers
(define (larger l t)
  (extract > l t))

;   Podstatné ale není to, že můžeme nyní tyto funkce definovat "na jeden řádek",
; ale že můžeme definovat mnohem více "specializovaných" funkcí

; List-of-Numbers Number -> List-of-Numbers
(define (equal l t)
  (extract = l t))

; List-of-Numbers Number -> List-of-Numbers
(define (equal-or-larger l t)
  (extract >= l t))

;   Zároveň nemusíme jako "predikát" používat jen předdefinované funkce!

; Number Number -> Boolean
; Vrátí, jestli je (x*x) > c.
(define (sqr>? x c)
  (> (* x x) c))

; List-of-Numbers Number -> List-of-Numbers
(define (sqr-larger l t)
  (extract sqr>? l t))

;   Abstrahované funkce jsou ve výsledku užitečnější, než specializované!

;   Vyzkoušejte (příklad):
; Infimum a supremum jsou funkce na množinách, které vybírají nejmenší a největší prvek celé množiny.

; NE-List-of-Numbers -> Number
; Nalezne nejmenší číslo v neprázdném listu
(define (inf l)
  (cond [(empty? (rest l)) (first l)]
        [else (if (< (first l)
                     (inf (rest l)))
                  (first l)
                  (inf (rest l)))]))


; NE-List-of-Numbers -> Number
; Nalezne největší číslo v neprázdném listu
(define (sup l)
  (cond [(empty? (rest l)) (first l)]
        [else (if (> (first l)
                     (sup (rest l)))
                  (first l)
                  (sup (rest l)))]))

;   Definujte funkci (pick-one P l) která bude abstrahovat tyto dvě funkce
; Vyzkoušejte. Zkuste popsat, jak dlouho se výraz evaluuje v závislosti na
; délce listu. Dokážete říct proč se funkce takhle chová?

;   Přepište původní funkce za použití funkcí (min x y) a (max x y).
; Abstrahujte takto přepsané funkce do (pick-one.v2 P l).
; Proč jsou tyto funkce "rychlejší"?

; -----------------------------------------------------------------------------

;   Efektivně jsme povýšili funkce na "first class citizens" (občany první třídy)
; Můžeme definovat funkci a následně ji použít jako argument jiné funkce!
