;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |5.2|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)
;; Převeďme tento problém do 2D - jak bude vypadat struktura pro 2d Ball ?

;    Nested    x   Flat
;   (Vnořená)    (Plochá)

(define WIDTH 200)
(define HEIGHT 200)
(define SCENE (empty-scene WIDTH HEIGHT))
(define BALL-RADIUS 4)
(define BALL (circle BALL-RADIUS "solid" "red"))

(define MU 0.8) ; Tlumící koeficient odrazu - určuje kolik "rychlosti" se "zachová"
(define DT 0.2) ; Časový krok simulace
(define M 1) ; Hmotnost kuličky
(define G 1) ; Tíhová konstanta (gravitační zrychlení

; Number Number Number Number -> Ball
; Provede simulaci skákání kuličky
(define (main-ball x0 y0 vx0 vy0)
  (big-bang (make-ball (make-posn x0 y0) (make-posn vx0 vy0))
    [on-tick ball-tick]
    [on-draw ball-draw]
    [on-mouse ball-mouse]))

(define-struct ball [location velocity])
; Ball je struktura:
;  (make-ball Posn Posn)
; interpretace: Kulička v simulaci, location je momentální poloha, velocity momentální rychlost

; BallOrPosn je jedno z:
; - Ball
; - Posn

; Posn Posn -> Posn
; Provede translaci pozice posn1 o posn2
(check-expect (posn+ (make-posn -1 1) (make-posn 1 1)) (make-posn 0 2))
(check-expect (posn+ (make-posn 0 8) (make-posn 8 0)) (make-posn 8 8))
(define (posn+ posn1 posn2)
  (make-posn (+ (posn-x posn1) (posn-x posn2))
             (+ (posn-y posn1) (posn-y posn2))))

; Number Posn -> Posn
; Vynásobí složky posn1 číslem num
(check-expect (posn* 5 (make-posn 0 0)) (make-posn 0 0))
(check-expect (posn* 2 (make-posn -1 1)) (make-posn -2 2))
(define (posn* num posn1)
  (make-posn (* num (posn-x posn1))
             (* num (posn-y posn1))))

; Number Number Posn -> Boolean
; Predikát určující jestli se kulička v poloze p o poloměru ball-radius nachází v souřadnici x mezi 0 a width
(check-expect (ball-inside/x? 20 5 (make-posn 14 65)) #t)
(check-expect (ball-inside/x? 20 5 (make-posn 15 65)) #f)
(check-expect (ball-inside/x? 20 5 (make-posn 16 65)) #f)
(define (ball-inside/x? width ball-radius p)
  (> width (+ ball-radius (posn-x p)) ball-radius))

; Number Number Posn -> Boolean
; Predikát určující jestli se kulička v poloze p o poloměru ball-radius nachází v souřadnici y mezi 0 a height
(check-expect (ball-inside/y? 20 5 (make-posn 65 14)) #t)
(check-expect (ball-inside/y? 20 5 (make-posn 65 15)) #f)
(check-expect (ball-inside/y? 20 5 (make-posn 65 16)) #f)
(define (ball-inside/y? height ball-radius p)
  (> height (+ ball-radius (posn-y p)) ball-radius))

; Number Number Number BallOrPosn -> Boolean
; Predikát určující jestli se kulička b (nebo v pozici b) o poloměru ball-radius nachází
; uvnitř scény s výškou height a šířkou width
(define (ball-inside? width height ball-radius b)
  (and (ball-inside/x? width ball-radius (if (ball? b) (ball-location b) b))
       (ball-inside/y? height ball-radius (if (ball? b) (ball-location b) b))))

; Ball -> Posn
; Vrátí zrychlení kuličky na základě její polohy
; Zde uvažujeme vzorec a = M*G, obecně ale můžeme brát
; funkci od polohy a rychlosti - vyzkoušíme!
(define (ball-acceleration b)
  (make-posn 0 (* M G)))

; Number Ball -> Posn
; Poloha kuličky b po čase dt
(check-expect (ball-next-location 1 (make-ball (make-posn 10 10) (make-posn 0 5))) (make-posn 10 15))
(define (ball-next-location dt b)
  (posn+ (ball-location b)
     (posn* dt (ball-velocity b))))

; Number Ball -> Posn
; Rychlost kuličky b po čase dt
(define (ball-next-velocity dt b)
  (posn+ (ball-velocity b)
         (posn* dt (ball-acceleration b))))

; Number -> Number
; Tlumení jedné složky odrazu
(check-expect (ball-bounce 5) (* MU -5))
(define (ball-bounce vel)
  (* (- MU) vel))

; Number Number Number Posn Posn Ball -> Ball
; Pokud v následujícím kroku (tj. kulička bude mít polohu next-loc
; a rychlost next-vel) dojde k odrazu, provede odraz, jinak provede krok.
; Šířka scény je width, výška scény je height, poloměr kuličky je radius.
(define (ball-next width height radius next-loc next-vel b)
  (if (ball-inside? width height radius next-loc)
      (make-ball next-loc next-vel)
      (make-ball (ball-location b)
                 (make-posn (if (ball-inside/x? width radius next-loc)
                                (posn-x next-vel)
                                (ball-bounce (posn-x next-vel)))
                            (if (ball-inside/y? height radius next-loc)
                                (posn-y next-vel)
                                (ball-bounce (posn-y next-vel)))))))

; Ball -> Ball
; Provede jeden krok simulace odrážející se kuličky b
(define (ball-tick b)
  (ball-next WIDTH HEIGHT BALL-RADIUS
             (ball-next-location DT b)
             (ball-next-velocity DT b)
             b))

; Posn Number Number -> Posn
; Vytvoří z globálního (x, y) vytvoří posn v "lokálních souřadnicích" kolem pos
(check-expect (local-vector (make-posn 0 1) 1 0) (make-posn 1 -1))
(check-expect (local-vector (make-posn 1 2) 0 0) (make-posn -1 -2))
(define (local-vector pos x y)
  (make-posn (- x (posn-x pos))
             (- y (posn-y pos))))

; Ball Number Number MouseEvent -> Ball
; Při kliknutí myši dojde k urychlení kuličky směrem ke kurzoru
(define (ball-mouse b x y me)
  (if (mouse=? me "button-down")
      (make-ball (ball-location b)
                 (local-vector (ball-location b) x y))
      b))

; Ball -> Image
; Vykreslí kuličku b v její pozici na scéně SCENE
(define (ball-draw b)
  (place-image BALL (posn-x (ball-location b)) (posn-y (ball-location b)) SCENE))