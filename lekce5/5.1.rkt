;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |5.1|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)
; Strukturní typy

; Zatím jsme do stavu ukládali obecně jedno z:
; - String
; - Number
; - Image
; - Boolean

; -> Jsou to jediné datové typy, se kterými jsme doposud pracovali!
; Běžně ale potřebujeme reprezentovat složitější informace - složená data, jako například

; - Hra: Počet životů, poloha soupeře, poloha hráče, jméno hráče, nejvyšší skóre, ...
; - Adresář: Seznam kontatků obsahující více informací o jednotlivých lidech
;            jméno, adresa, email, telefon...

; Diskuze domácího úkolu - bylo vhodné použít komplexní číslo jako polohu na 2D plátnu?

; Začneme ukázkou struktury - posn
;   Souřaadnice na 2D plátnu, obsahjuje "souřadnici x" a "souřadnici y"

(make-posn 3 4) ; Pozice x=3 y=4

(define posn-one (make-posn 8 6)) ; Úkol - popište posn-one

; Nyní z posn zase chceme dostat jednotlivé informace
;(posn-x posn-one)
;(posn-y posn-one)

; Čemu se budou rovnat?
;(posn-x (make-posn X0 Y0))
;(posn-y (make-posn X0 Y0))

; Programování se strukturou posn

; Posn -> Number
; Spočítá vzdálenost (euklidovskou) bodu p od počátku (0, 0)
(check-expect (distance-to-0 (make-posn 0 5)) 5)
(check-expect (distance-to-0 (make-posn 7 0)) 7)
(check-expect (distance-to-0 (make-posn 3 4)) 5)
(define (distance-to-0 p)
  (sqrt (+ (sqr (posn-x p))
           (sqr (posn-y p)))))

; Evaluujte následující výrazy
;(distance-to-0 (make-posn 3 4))
;(distance-to-0 (make-posn 6 (* 2 4)))
;(+ (distance-to-0 (make-posn 12 5)) 10)


; Obecné struktury
; Chceme vytvářet vlastní strukturové typy - musíme je definovat!
(define-struct movie [title director year])
(define-struct game [name last-played hours-played rating])

; Takto vytvořená struktura obsahuje
;  1) jeden konstruktor (make-... x ...)
;      který vytváří instance této struktury
;      například (make-movie "Avatar: The Way of Water" "James Cameron" 2022)

;  2) jeden selektor za každý prvek struktury
;      například (movie-title m) nebo (game-last-played g)

;  3) Jeden strukturní predikát jako třeba (game? g)
;      nebo (movie? m)
; Toto jsou pro nás další funkce!

; PROCVIČTE SI! Vytvořte různé struktury, které odpovídají předmětům ve
; vašem okolí, např. struktura pro "knihu" nebo pro "peněženku"


; -------------------------------------------------------------------------------------


; Ukázkový problém - vyvineme strukturový typ pro simulaci "odrážejících se kuliček",
;  poloha kuličky je jedno číslo, rychlost kuličky je číslo a směr ve kterém se hýbe
;  Rozmyslete - proč při 1D pohybu stačí i pro rychlost jen číslo?

(define-struct ball [location velocity])
; Ball je struktura:
;  (make-ball Number Number)
; interpretace: Kulička v simulaci, location je momentální poloha, velocity momentální rychlost

; BallOrNumber je jedno z:
; - Ball
; - Number

(define WIDTH 100)
(define HEIGHT 100)
(define SCENE (empty-scene WIDTH HEIGHT))
(define BALL-RADIUS 4)
(define BALL (circle BALL-RADIUS "solid" "red"))

(define MU 0.7) ; Tlumící koeficient odrazu
(define DT 0.2) ; Časový krok simulace
(define M 1) ; Hmotnost kuličky
(define G 1) ; Tíhová konstanta (gravitační zrychlení

; Number Number -> Ball
; Provede simulaci skákání kuličky
(define (main-ball x0 v0)
  (big-bang (make-ball x0 v0)
    [on-tick ball-tick]
    [on-draw ball-draw]))

; Number Number BallOrNumber -> Boolean
; Predikát určující jestli je kulička y (nebo kulička ve výšce y) velikosti ball-radius nad zemí ve
; scéně výšky scene-height
(check-expect (ball-inside/y? 20 5 (make-ball 14 0)) #t)
(check-expect (ball-inside/y? 20 5 (make-ball 15 0)) #f)
(check-expect (ball-inside/y? 20 5 (make-ball 16 0)) #f)
(check-expect (ball-inside/y? 30 4 25) #t)
(check-expect (ball-inside/y? 30 4 26) #f)
(check-expect (ball-inside/y? 30 4 27) #f)
(define (ball-inside/y? scene-height ball-radius y)
  (> scene-height (+ ball-radius
                     (if (ball? y)
                         (ball-location y)
                         y))))

; Ball -> Number
; Vrátí zrychlení kuličky na základě její polohy
; Zde uvažujeme vzorec a = M*G, obecně ale můžeme brát
; funkci od polohy a rychlosti - vyzkoušíme!
(define (ball-acceleration b)
  (* M G))

; Number Ball -> Number
; Poloha kuličky b po čase dt
(check-expect (ball-next-location 1 (make-ball 0 1)) 1)
(define (ball-next-location dt b)
  (+ (ball-location b)
     (* (ball-velocity b) dt)))

; Number Ball -> Number
; Rychlost kuličky b po čase dt
(define (ball-next-velocity dt b)
  (+ (ball-velocity b)
     (* (ball-acceleration b) dt)))

; Ball -> Number
; Rychlost kuličky b po odrazu
(check-expect (ball-bounce (make-ball HEIGHT 0.5)) (* MU -0.5))
(define (ball-bounce b)
  (* (- MU) (ball-velocity b)))

; Number Number Number Number Ball -> Ball
; Pokud v následujícím kroku (tj. kulička bude mít polohu next-loc
; a rychlost next-vel) dojde k odrazu, provede odraz, jinak provede krok.
; Výška scény je height, poloměr kuličky je radius.
(define (ball-next height radius next-loc next-vel b)
  (if (ball-inside/y? height radius next-loc)
      (make-ball next-loc next-vel)
      (make-ball (ball-location b) (ball-bounce b))))

; Ball -> Ball
; Provede jeden krok simulace odrážející se kuličky b
(define (ball-tick b)
  (ball-next HEIGHT BALL-RADIUS
             (ball-next-location DT b)
             (ball-next-velocity DT b)
             b))

; Ball -> Image
; Vykreslí kuličku b v její pozici na scéně SCENE
(define (ball-draw b)
  (place-image BALL (/ WIDTH 2) (ball-location b) SCENE))

