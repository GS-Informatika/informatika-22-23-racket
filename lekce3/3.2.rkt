;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |3.2|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
; Nyní se budeme věnovat interaktivním programům, které tvoří většinu programů se kterými se lidé
; setkávají a interagují s nimi pomocí klávesnice a myši (případně dotykové obrazovky).
; Interaktivní programy také mohou reagovat na eventy které vygeneroval pročítač, například "tikání" hodin
; (clock ticks - např. každých n sekund příjde event "uběho n sekund) nebo síťový event (přišla odpověď ze serveru)

; Jaké další eventy vás napadají? Přemýšlejte napři i o chytrých hodinkách, mobilních telefonech, IoT (chytrá domácnost)

; Máme spousty hardware, chceme využívat spousty hardware!
; Na HW se jako první software běžně instaluje nějáký operační systém.
; OS zajišťuje běh procesů, rozdělování paměti a komunikaci s periferiemi (klávesnice, myš, reproduktory, monitor...)

; Pro design interaktivních programů potřebujeme přemýšlet nad tím, jak implementovat funkce které budou
; "konzumovat" eventy od OS a budou provádět příslušné operace.
; DrRacket si můžeme představovat jako "malý operační systém" (který běží jako program v rámci operačního systému na vašem počítači)
; a BSL je jeho programovací jazyk (reálně je spouštěn na tzv. virtuálním stroji, který interpretuje naše "příkazy", rozděluje paměť a podobně)

; S jednoduchým interaktivním programem jsme se již setkali v předchozích lekcích! Víte který to byl?

; BSL obsahuje 2htdp/universe teachpack, který má "big-bang" - dispatcher, který dokáže jednotlivým funkcím posílat OS eventy.

; Big-bang si také drží přehled o "stavu" programu (na nás bude abychom určili jak takový stav vypadá a jaký je počáteční stav!)

; Big-bangu musíme vždy poskytnout funkci to-draw, která "vykreslí" momentální stav.

; Každý event-handler pak má přístup k momentálnímu stavu a k informacím o eventu a musí vyprodukovat nový stav.

; Big-bang expression je vlastně popis toho, jak náš program interaguje s okolním světem. Někdy budeme big-bang programům říkat "world programy".



; Začněme velmi pomalu
; Kromě universe budeme potřebovat i 2htdp/image teachpack
(define (number->square s)
  (square s "solid" "black"))
; Počáteční stav = 100
; to-draw handler = number->square funkce - všimněte si, že používáme pouze jméno!
(big-bang 100
  [to-draw number->square])
  ;[on-tick sub1]
  ;[stop-when zero?])

; big-bang neustále kontroluje hodnotu svého stavu a volá funkci specifikovanou v to-draw,
; tato funkce musí brát za svůj argument právě stav. Pokud tedy bude naším stavem string, pak musí brát string!

; Přidejme event handler pro reset stavu při stisknutí klávesy
#|
(define (reset state key-event)
  100)

(big-bang 100
  [to-draw number->square]
  [on-tick sub1]
  [stop-when zero?]
  [on-key reset])
|#

; Pojďme se kouknout do dokumentace, co všechno big-bang umí!
#|
(define WIDTH 500)
(define HEIGHT 500)
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define SPRITE (square 5 "solid" "red"))

(define (render-sprite state)
  (place-image SPRITE (real-part state) (imag-part state) BACKGROUND))

(define (key-or=? a1 b1 b2)
  (or (key=? a1 b1) (key=? a1 b2)))

(define (loop-h x)
  ; (make-rectangular x y) = x+yi - komplexní číslo!
  (cond [(> (imag-part x) HEIGHT) (- x (make-rectangular 0 HEIGHT))]
        [(< (imag-part x) 0) (+ (make-rectangular 0 HEIGHT) x)]
        [else x]))

(define (handle-pad-events pos pad-ev)
  (cond
    [(key-or=? pad-ev "up" "w") (loop-h (- pos 0+5i))]
    [(key-or=? pad-ev "down" "s") (loop-h (+ pos 0+5i))]
    [(key-or=? pad-ev "left" "a") (- pos 5)]
    [(key-or=? pad-ev "right" "d") (+ pos 5)]
    [else pos]))

(big-bang 100+100i
  [to-draw render-sprite]
  [on-pad handle-pad-events])
|#

; big-bang tedy vždy při eventu vezme "momentální stav", aplikuje příslušný "event handler" a vrátí "nový stav".
; Nový stav pak pošle do "stop-when funkce", která vrátí #t nebo #f, pokud se vyhodnotí jako #f, tak také do  "to-draw funkce", která jej vykreslí.
; Pokud stop-when funkce vrátí #t, zastaví se další vyhodnocování.

; Pojďme napsat ještě jeden big-bang program, tentokrát "parametrizovaný"!

#|
(define BACKGROUND (empty-scene 100 100))
(define DOT (circle 3 "solid" "red"))

(define (main y)
  (big-bang y
    [on-tick sub1]
    [stop-when zero?]
    [to-draw place-dot-at]
    [on-key stop]))

(define (place-dot-at y)
  (place-image DOT 50 y BACKGROUND))

(define (stop y ke)
  0)
|#

; Bonusová otázka - někteří z vás si už určitě všimli, že NELZE volat funkci PŘED TÍM než ji definujeme
; (vyzkoušejte!). Proč zde mohu funkce "place-dot-at" a "stop" napsat v "big-bang" ještě před jejich definicí?

; Zkusme nejříve evaluovat např. (place-dot-at 89) a (stop 89 "q") - ověříme funkčnost.
; Jak tedy bude main reagovat, když stiskneme klávesu!?
; Otestujte
;(main 90)

; Nyní se můžeme začít pořádně věnovat designu programů!