# Evaluace Booleovských výrazů

Začněme se definicemi
```racket
(define-struct literal (value))
(define-struct conjunction (left-operand right-operand))
(define-struct negation (operand))

; Expr je jedno z:
;  - (make-literal Boolean)
;  - (make-conjunction Expr Expr)
;  - (make-negation Expr)
; interpretace: Booleovský výraz
```

1. Vytvořte alespoň 5 konstantních definic typu Expr.
    Pojmenujte je `EXPR-1`, `EXPR-2`, ...

2. Podle "receptu" pro rekurzivní data implementujte funkci
    `evaluate` která provede evaluaci výrazu Expr do booleanu.
    K funkci dopište testy pomocí vámi definovaných konstantních definic.

3. Nadesignujte funkci `disjunction` která ze dvou Expr `A` a `B`
    vytvoří Expr `C` pro kterou platí `(evaluate C) == (or (evaluate A) (evaluate B))`
    (tedy `(evaluate (disjunction A B)) == (or (evaluate A) (evaluate B))`).
    Sepište vhodné testy.

# Programování se stromy

Uvažujme datovou strukturu:
```racket
(define-struct node (left value right))
(define-struct empty-tree ())
```

Tato struktura je speciální případ tzv. stromu.

Datová definice zní
```racket
; EmptyTree je structure (make-empty-tree))
; interpretace: prázdný strom
(define EMPTY (make-empty-tree))

; TreeOfNumbers je jedno z:
; - EmptyTree
; - (make-node TreeOfNumbers Number TreeOfNumbers)
; interpretace: strom s čísly v uzlech
```

### Pomocná funkce pro "listy (leaf)"

Strom, který obsahuje pouze jediné číslo `n` (tzv. leaf) musí mít tvar
`(make-node EMPTY n EMPTY)`. Nadesignujte funkci `make-leaf` která bude
takový tvar vytvářet.

### Vyhledávání ve stromu

Napište funkci `in-tree?` která bere za parametr Number a TreeOfNumbers
a vrátí, jestli se dané číslo ve stromu nachází. Použíjte recept pro design
s rekurzivními daty.

### Od stromů k listům (lists)

Napište funkci `tree->list`, která z TreeOfNumbers vytvoří ListOfNumbers.
Výsledný list čísel by měl obsahovat všechna čísla, která ve stromu jsou,
jejich pořadí je nám jedno.

### Redukce na struktuře

Napište funkci `tree-sum`, která vypočítá sumu všech hodnot ve stromu.
Problém můžete řešit rekurzivně přímo na stromu, nebo využít předchozí funkce
a převést tento problém na jiný.
Jak těžké bude implementovat funkci násobení všech čísel ve stromu?

### Jiná definice struktury

Všimněte si, kde se nachází prvky odpovídající listům (leaf).
Uvažujte, že máme novou datovou strukturu
```
(define-struct leaf [value])

; BTreeOfNumbers je jedno z:
; - (make-leaf Number)
; - (make-node BTreeOfNumbers Number BTreeOfNumbers)

```
Je tato struktura ekvivalentní TreeOfNumbers?
Jde jakýkoliv TreeOfNumbers zapsat pomocí BTreeOfNumbers a naopak?

Diskutujte a vysvětlete proč ano/ne.
Pokud ne, nakreslete příklad BTreeOfNumbers a TreeOfNumbers které jsou si
ekvivalentní a příklad kdy ne.