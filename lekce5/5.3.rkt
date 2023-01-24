;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |5.3|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Další ukázky struktur
(define-struct contact [name home office cellphone])
(define-struct phone [area number])

(define j-novak (make-contact "Jan Novák"
                               (make-phone "+420" "999888777")
                               (make-phone "+420" "666555444")
                               (make-phone "+421" "333222111")))

(phone-area (contact-office j-novak))

; -------------------------------------------------------------------

(define-struct entry [name phone email])

(define pl (make-entry "Al Abe" "666-7771" "lee@x.me"))

(posn? pl)
(contact? pl)
(entry? pl)