#lang racket
;-----------------------------------------------------------------
; Exercise 1.2
(define (exercise-1-2)
  (/
   (+ 5
      (- 2
         (- 3
            (+ 6
               (/ 1 5)))))
   (* 3
      (- 6 2)
      (- 2 7)
      )))


;-----------------------------------------------------------------
; Exercise 1.3
(define (square n)
  (* n n))

(define (sum-of-squares a b)
  (+ (square a) (square b)))

(define (exercise-1-3 x y z)
  (cond ((and (>= x y) (>= y z)) (sum-of-squares x y))
        ((and (>= x y) (>= z y)) (sum-of-squares x z))
        ((and (>= y x) (>= z x)) (sum-of-squares y z))))


;-----------------------------------------------------------------
; Exercise 1.4
; In the example, a compound expression is used as an operator to determine which operator to apply in a given
; situation.  More specifically, the if statement determines whether to add or subtract two numbers depending
; on whether or not one, b, is positive or negative.  This could be extended to more complex compound
; expressions that return more advanced, custom defined operators to be applied.
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))


;-----------------------------------------------------------------
; Exercise 1.5
; Applicative order evaluation will evaluate all of the operands before substituting their values into the
; definition of the operator.  In this example, the interpreter would attempt to evaluate p, which evaluates
; to itself, which evaluates to itself, which evaluates to itself, ad infinitum.  On the other hand, normal
; order execution will substitute 0 and p into the definition of test without first trying to evaluate p.  As
; the if statement in test's definition only includes x, and the predicate is true, which returns a literal
; value, a value for p is never actually required, so it is never evaluated.
;
; Applicative order
; -> (test x (p))
; -> Interpreter: x is x
; -> Interpreter: (p) is (p), so let's evaluate (p)
; -> Interpreter: (p) is (p), so let's evaluate (p)
; -> ...
;
; Normal order
; -> (test 0 (p))
; -> (if (= x 0)
;     0
;     (p))         ; <- NOT EVALUATED AS if DOESN'T USE APPLICATIVE ORDER EVALUATION
; -> (if (= 0 0)
;     0
;     (p))
; -> 0


;-----------------------------------------------------------------
; Square Root Code
(define (is-guess-close-enough guess old-guess max-pc-change)
  (< (* (abs (- 1.0 (/ old-guess guess))) 100.0) max-pc-change))

; Calculates the next square root guess given the previous guess and the radicand (number we're trying to find
; the square root for).  It does this by finding the intercept of the tangent at the old guess and the x axis.
(define (improve-sqrt-guess old-guess radicand)
  (/ (+ old-guess (/ radicand old-guess)) 2.0))

; Calculates an approximation of the square root of n; returning when the percentage change between guesses is
; less than max-pc-change.
(define (sqrt-pc-change n guess old-guess max-pc-change)
  (if (is-guess-close-enough guess old-guess max-pc-change)
      guess
      (sqrt-pc-change n (improve-sqrt-guess guess n) guess max-pc-change)))

(define (sqrt n)
  (sqrt-pc-change n (improve-sqrt-guess 1.0 n) 1.0 1.0))


;-----------------------------------------------------------------
; Exercise 1.6
; sqrt-1-6 is a procedure that fails to terminate.  The reason is that new-if is not a special form, and
; therefore applicative order evaluation is used to evaluate all of its arguments before new-if itself is
; evaluated.  That means that the recursive call to sqrt-pc-change-1-6 is evaluated before the call to new-if,
; and that recursive call contains another recursive call which needs to evaluated.  The evaluation of
; recursive calls to sqrt-pc-change-1-6 will continue ad infinitum.
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

(define (sqrt-pc-change-1-6 n guess old-guess max-pc-change)
  (new-if (is-guess-close-enough guess old-guess max-pc-change)
      guess
      (sqrt-pc-change-1-6 n (improve-sqrt-guess guess n) guess max-pc-change)))

(define (sqrt-1-6 n)
  (sqrt-pc-change-1-6 n (improve-sqrt-guess 1.0 n) 1.0 1.0))

; Below is an additional test I ran while playing with this exercise to confirm my understanding.  It
; demonstrates that cond is a special form that is evaluated the same way that if is: subsequent predicates
; are only evaluated if their predecessors return false.  That is, the recursive calls are only evaluated
; until the guess is close enough, at which point the guess is returned without trying to evaluate the next
; recursive call.
(define (sqrt-pc-change-1-6-safe n guess old-guess max-pc-change)
  (cond ((is-guess-close-enough guess old-guess max-pc-change) guess)
        (else (sqrt-pc-change-1-6-safe n (improve-sqrt-guess guess n) guess max-pc-change))))

(define (sqrt-1-6-safe n)
  (sqrt-pc-change-1-6-safe n (improve-sqrt-guess 1.0 n) 1.0 1.0))
