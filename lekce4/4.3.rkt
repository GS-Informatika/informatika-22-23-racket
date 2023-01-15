;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |4.3|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)
; Reprezentace informací
; Intervaly, enumerace a itemizace

; Nyní známe čísla (Number), textové řetězce (String), obrázky (Image)
;   a pravdivnostní hodnoty (Boolean). Programátoři často musí pracovat
;   s omezenými datovými typy. Nejprve se podíváme na restrikci typů na
;   vybrané prvky - enumeraci a intervaly.

; Enumerace a programování s podmínkami

; Opakování podmínek
#|
(cond [CondVýraz1 Výsledek1]   <---- cond clause (klauzule, podmínka)
      [CondVýraz2 Výsledek2]
      ...
      [CondVýrazN VýsledekN])
|#

; TrafficLightState je jedno z:
;   - "red"
;   - "yellow"
;   - "green"
; interpretace: reprezentuje stav semaforu podle momentální barvy

; TrafficLightState -> TrafficLightState
; Vrátí následující stav smeaforu
(define (next traffic-light-state)
  (cond [(string=? "red" traffic-light-state) "green"]
        [(string=? "gree" traffic-light-state) "yellow"]
        [(string=? "yellow" traffic-light-state) "red"]))

; Právě jste viděli první příklad ENUMERACE - TrafficLightState je enumerace,
;   nabývá jedné ze tří hodnot, je to subtyp stringu! Vymyslete další enumerace!
;   Setkali jsme se s nimi na předchozí lekci a v úkolu na big-bang!

; Můžeme také použít else - "ve všech ostatních případech proveď toto"
#|
(cond [CondVýraz1 Výsledek1] 
      [CondVýraz2 Výsledek2]
      ...
      [else VýsledekOstatníPřípady])
|#

; else musí být jako poslední!
#|
; Number Number Number -> Boolean
; Vrátí pravdivostní hodnotu min < x < max.
(define (in-range min max x)
  (cond [(< x min) #f]
        [else #t]
        [(> x max) #f]))
|#
; Otázka - kdybychom odstranili komentář s účelem funkce,
; bylo by jasné co funkce dělá jen z jejího jména? (např. uvidíme jen její aplikaci)

; Dokážeme funkci přepsat pomocí "if"? Chtěli bychom se zbavit jedné větve cond!


; Omezení datového typu kontraktem - pro nás zatím jen "slovní" kontrakt!
; Zároveň se jedná o INTERVAL.

; PositiveNumber je Number splňující positive?

; PositiveNumber -> String
; Určí úroveň hráče na základě jeho skóre s
(define (reward s)
  (cond [(<= 0 s 10) "bronzová"]
        [(and (< 10 s)
              (<= s 20)) "stříbrná"]
        [(< 20 s) "zlatá"]))

; Použití else často výhodné - nemusíme ověřovat že máme pokryté opravdu všechny podmínky!
#|
(define (reward s)
  (cond [(<= 0 s 10) "bronzová"]
        [and (< 10 s)
             (<= s 20) "stříbrná"]
        [else "zlatá"]))
|#

; Co když nemáme pokryté všechny podmínky?
(define (wrong-cond x)
  (cond [(= x 1) #t]
        [(= x 2) #f]
        [(= x 3) "THREE"]))


; Bonusový úkol - cond je "expression" (výraz) - to znamená, že se může objevit
;   i uprostřed jiného výrazu. Spusťte ve stepperu následující funkci pro hodnoty y 150 a 250.
(define (cond-inside-expr y)
  (- 200 (cond [(> y 200) 0] [else y])))


; Enumerace - konkrétně
; Pokud máme jen nekolik tvarů,
;  kterých naše reprezentace informace může nabývat,
;  je vhodné volit enumeraci.
; Explicitně deklarujeme kterých možností mohou naše data nabývat.

; 1String je String délky 1,
; včetně
; - "\\" (backslash)
; - " " (mezera)
; - "\t" (tabulátor)
; - "\r" (return)
; - "\b" (backspace)
; - "\n" (newline)
; interpretace: reprezentují některé klávesy na klávesnici a ostatní stringy délky 1.

; Otázka - Jak otestovat jestli je něco 1String?

; KeyEvent je jedno z:
; - 1String
; - "left"
; - "right"
; - ...

; Intervaly - konkrétně
; Design task - Simulace oběhu modrého tělesa kolem slunce po kruhové trajektorii.
; V dolní části obrázku bude počítadlo oběhů v zelené barvě.
; Jakmile těleso provede 5 oběhů, počítadlo bude ukazovat oranžovou barvou.
; Jakmile těleso provede 10 oběhů, počítadlo bude ukazovat červenou barvou.
; Jakmile těleso provede 15 oběhů, simulace se zastaví.

; WorldState je Number mezi:
; - 0 a REVOLUTIONS1
; - REVOLUTIONS1 a REVOLUTIONS2
; - REVOLUTIONS2 a REVOLUTION-END
; interpretace: úhel který svírá obíhající těleso s osou x souřadné soustavy,
; nenabývá vyšší hodnoty než REVOLUTIONS-END a nižší hodnoty jak 0.
; Každý násobek 2*PI odpovídá jednomu dokončenému oběhu.

(define WIDTH 160) ; velikosti scény
(define HEIGHT 160)
(define R 35) ; radius kružnice
(define DPHI 0.2) ; rychlost simulace (změna úhlu za časový krok)
(define SCENE (empty-scene WIDTH HEIGHT))
(define BODY (circle 4 "solid" "red"))
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))

(define REVOLUTIONS1 5) ; počet oběhů pro první změnu barvy textu
(define REVOLUTIONS2 10) ; pro druhou změnu barvy
(define REVOLUTIONS-END 15) ; max. počet oběhů
(define COLOR0 "green")
(define COLOR1 "orange")
(define COLOR2 "red")
(define TEXT-SIZE 24) ; velikost počítadla oběhů

; WorldState -> WorldState
; simulace oběhu tělesa po kružnici
(define (main-circular phi0)
  (big-bang phi0
    [on-tick circular-next]
    [to-draw circular-render]
    [stop-when circular-end?]))

; WorldState -> WorldState
; určí následující polohu tělesa
(check-expect (circular-next 0) DPHI)
(check-expect (circular-next -10) (+ -10 DPHI))
(define (circular-next phi)
  (+ phi DPHI))

; Number Number -> Number
; převede radiální souřadnice (r, phi) na kartézskou souřadnici x
(check-expect (radial->cart-x 0 0) 0)
(check-expect (radial->cart-x 5 0) 5)
(check-expect (radial->cart-x 0 20) 0)
(check-expect (radial->cart-x 1 pi) -1.0)
(define (radial->cart-x r phi)
  (inexact->exact (* r (cos phi))))

; Number Number -> Number
; převede radiální souřadnice (r, phi) na kratézskou souřadnici y
(check-expect (radial->cart-y 0 0) 0)
(check-expect (radial->cart-y 5 0) 0)
(check-expect (radial->cart-y 0 20) 0)
;(check-expect (radial->cart-y 1 pi) 0); <--- zde máme problém s neexaktními čísly!
;(check-within (radial->cart-y 1 pi) 0 1e-7)
(check-expect (radial->cart-y 8 (/ pi 2)) 8)
(define (radial->cart-y r phi)
  (inexact->exact (* r (sin phi))))

; Image Number Number Number Number Image -> Image
; Umístí obrázek img na obrázek background na souřadnice (center-x + x) a (center-y + y)
(define (place-center/offset img x y center-x center-y background)
  (place-image img (+ center-x x) (+ center-y y) background))

; WorldState -> Number
; Podle momentálního WorldState ws určí počet uběhlých otáček
(check-expect (revolution-count 0) 0)
(check-expect (revolution-count 1) 0)
(check-expect (revolution-count 7) 1)
(check-expect (revolution-count (* 31 pi)) 15)
(define (revolution-count ws)
  (inexact->exact (floor (/ ws (* pi 2)))))

; Number -> Image
; Podle uběhlých počtu otáček revs vytvoří obrázkovou reprezentaci textu s počtem dokončených otáček
(check-expect (revolution-text 0) (text "0" TEXT-SIZE COLOR0))
(check-expect (revolution-text REVOLUTIONS1) (text (number->string REVOLUTIONS1) TEXT-SIZE COLOR1))
(check-expect (revolution-text REVOLUTIONS2) (text (number->string REVOLUTIONS2) TEXT-SIZE COLOR2))
(define (revolution-text revs)
  (text (number->string revs)
        TEXT-SIZE
        (cond [(< revs REVOLUTIONS1) COLOR0]
              [(< revs REVOLUTIONS2) COLOR1]
              [else COLOR2])))
  
; WorldState -> Image
; umístí PLANET do polohy (R, phi) v polárních souřadnicích kolem (CENTER-X, CENTER-Y)
; spolu s textem podle počtu dokončených otáček
(define (circular-render phi)
  (overlay/align "center" "bottom"
                 (revolution-text (revolution-count phi))
                 (place-center/offset BODY
                                      (radial->cart-x R phi)
                                      (radial->cart-y R phi)
                                      CENTER-X
                                      CENTER-Y
                                      SCENE)))

; WorldState -> Boolean
; testuje jestli je počet oběhů větší nebo roven REVOLUTIONS-END
(check-expect (circular-end? (* pi 2 (sub1 REVOLUTIONS-END))) #f)
(check-expect (circular-end? (+ DPHI (* pi 2 REVOLUTIONS-END))) #t) ; Pro neexaktní čísla testujeme až "následující krok"
(check-expect (circular-end? (* pi 2 (add1 REVOLUTIONS-END))) #t)
(define (circular-end? phi)
  (>= (revolution-count phi) REVOLUTIONS-END))


; WorldState zde obsahuje interval (dokonce 3!)
; Intervaly je vhodné vizualizovat (např. načrtnout na papír), pokud možno!


; Itemizace - skládání více datových typů

; MaybeNumber je jedno z
; - #false
; - Number
; interpretace: výsledek číselného výpočtu který může selhat (v tom případě  #false)

; Jaká funkce vrací takový datový typ!?

; NonnegativeNumber je jedno z:
; - 0
; - PositiveNumber
; interpretace: nezáporná čísla

; Ukázka:

; LRCD (Launching Rocket CountDown) je jedno z:
; - "wait"
; - Number mezi COUNTDOWN a -1
; - NonnegativeNumber
; interpretace: Raketa na zemi čeká na odpočet při "wait",
; záporná čísla jsou odpočet,
; kladná čísla určují výšku rakety

(define ROCKET-X (/ WIDTH 2))
(define COUNTDOWN -30)

; LRCD -> LRCD
(define (main-rocket state)
  (big-bang state
    [on-tick rocket-tick]
    [on-key rocket-key]
    [to-draw rocket-render]))

; LRCD -> LRCD
; "wait" -> "wait", jinak přičte 1 ke countdownu nebo výšce
(check-expect (rocket-tick "wait") "wait")
(check-expect (rocket-tick -3) -2)
(check-expect (rocket-tick -1) 0) ; <-- testujeme přechod itemizovaných typů!
(check-expect (rocket-tick 5) 6)
(define (rocket-tick cw)
  (if (number? cw) (add1 cw) "wait"))

; LRCD KeyEvent -> LRCD
; Pokud je raketa ve "wait" stavu (cw), spustí při stisku mezerníku (ke = "space") odpočet
(check-expect (rocket-key "wait" "a") "wait")
(check-expect (rocket-key "wait" " ") COUNTDOWN)
(check-expect (rocket-key -3 " ") -3)
(check-expect (rocket-key 2 " ") 2)
(define (rocket-key cw ke)
  (if (and (string=? ke " ") (eq? cw "wait")) COUNTDOWN cw)) ; Rozmyslete proč zde používáme eq?

; LRCD -> Image
; Vykreslí raketu - pro jednoduchost zrecyklujeme BODY z předchozí ukázky
(check-expect (rocket-render "wait") (rocket-render -1)) ; Můžeme testovat i že render pro čekající a odpočítávající raketu jsou stejné!
(define (rocket-render cw)
  (place-image/align BODY ROCKET-X
                     (if (and (number? cw) (positive? cw)) (- HEIGHT cw) HEIGHT) ; <-- Proč musíme testovat and number? positive?
                     "center" "bottom"
                     SCENE))



;;; Procvičovací úloha

; Vezměte svou definici funkce  traffic-light-next z procvičovacích úloh v 3.1.rkt.
; Dopište signaturu a účel funkce. Napište k funkci testy.
; Dále napište big-bang program, který bude vykreslovat momentální barvu semaforu a každé
; 3 sekundy jí změní (v dokumentaci hledejte (on-tick tick-expr rate-expr) ).
; Tento semafor následně rozšiřte pro možnost ovládání záchrannou službou:
;   - Rozšiřte data TrafficLightState na HaltableTrafficLightState, který bude navíc obsahovat "red-halt".
;     (halt - zastavit)
;   - Pokud je stav semaforu "red-halt", nebude při on-tick docházet ke změně stavu, vykreslí se červená.
;   - Stiskem mezerníku přejde semafor z jakéhokoliv TrafficLightState do "red-halt".
;   - Stiskem mezerníku ve stavu "red-halt" dojde k obnovení provozu "green" -> "yellow" -> "red" -> "green".


(define (traffic-light-next state)
  ...)


(define (main-traffic-light state)
  ...)