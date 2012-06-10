; Exercise 1.9
; --------------------------------------
(define (inc n)
  (+ n 1))

(define (dec n)
  (- n 1))

(define (first+ a b)
  (if (= a 0)
      b
      (inc (first+ (dec a) b))))

; Substituting each recursive call to + with the resultant call to inc shows that this procedure is
; essentially incrementing b, a times.  We can also see that the process is recursive, as the call stack is
; required to keep track of how many times we increment b.
; (first+ 4 5)
; (inc (+ (dec 4) 5))
; (inc (inc (+ (dec 3) 5)))
; (inc (inc (inc (+ (dec 2) 5))))
; (inc (inc (inc (inc (+ (dec 1) 5)))))
; (inc (inc (inc (inc (+ 0 5)))))
; (inc (inc (inc (inc 5))))
; (inc (inc (inc 6)))
; (inc (inc 7))
; (inc 8)
; 9

(define (second+ a b)
  (if (= a 0)
      b
      (second+ (dec a) (inc b))))

; Each syntactically recursive call to second+ is simply restating the problem with different arguments that
; will yield the correct solution.  As a result, the process does not require a call stack to keep track of
; what is required to return an answer in the same way that first+ does.  Therefore, this process is
; iterative and not recursive.
; (second+ 4 5)
; (second+ (dec 4) (inc 5))
; (second+ 3 6)
; (second+ (dec 3) (inc 6))
; (second+ 2 7)
; (second+ (dec 2) (inc 7))
; (second+ 1 8)
; (second+ (dec 1) (inc 8))
; (second+ 0 9)
; 9


; Exercise 1.10
; ----------------------------------------
(define (Ackermann x y)
	(cond ((= y 0) 0)
				((= x 0) (* 2 y))
				((= y 1) 2)
				(else (Ackermann (- x 1)
												 (Ackermann x (- y 1))))))

; (Ackermann 1 10)
; (Ackermann 0 (Ackermann 1 9))
; (Ackermann 0 (Ackermann 0 (Ackermann 1 8)))
; ...
; The pattern above continues so that each substitution results in another recursive call to Ackermann, where
; the arguments are 0 and (Ackermann 1 (- y 1)) until y becomes 1.  As n decrements by one each time we
; perform a substitution, there will be (- n 1) recursive calls on the stack where 0 is the first argument,
; and the second argument of the final call will be (A 1 1).
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 1 1))))))))))
; 
; At this point, (Ackermann 1 1) returns 2, leaving us with the list of recursive calls below.  
; (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 (A 0 2)))))))))
;
; Each call to the Ackermann function where the first argument is 0 returns (* 2 y), therefore the list of
; recursive calls has the effect of multiplying the second argument of the last call by 2^(n-1).  As the final
; argument will always be 2 when the first argument of the original call is 1 (we add calls until we get to (A
; 1 1)), any call to the Ackermann function that takes the form (A 1 n) will return 2^n.  Therefore the final
; answer is 2^10 = 1024


; (Ackermann 2 4)
; (A 1 (A 2 3))
; (A 1 (A 1 (A 2 2)))
; (A 1 (A 1 (A 1 (A 2 1))))
; (A 1 (A 1 (A 1 2)))
; We know that each call to the Ackermann function that takes the form (A 1 n) equals 2^n, so we can progress
; as follows
; 2  ^  (2  ^ (2^2))
; 2^(2^4)
; 2^16 = 65536


; (Ackermann 3 3)
; (A 2 (A 3 2))
; (A 2 (A 2 (A 3 1)))
; (A 2 (A 2 2))
; (A 2 (A 1 (A 2 1)))
; (A 2 (A 1 2))
; (A 2 4)
; 65536


; returns 2n
; (define (f n) (Ackermann 0 n))
;
; returns 2^n
; (define (g n) (Ackermann 1 n))
;
; returns 2^2^2... n times - e.g. (h 5) -> 2^2^2^2^2
; (define (h n) (Ackermann 2 n))


; Section 1.2.2 - counting change
; -------------------------------
; 
; Copy the tree-recursive algorithm in the book to see how long it takes.
(define (count-change amount)

  (define (first-denomination kinds-of-coins)
    (cond ((= kinds-of-coins 1) 1)
          ((= kinds-of-coins 2) 5)
          ((= kinds-of-coins 3) 10)
          ((= kinds-of-coins 4) 25)
          ((= kinds-of-coins 5) 50)))

  (define (cc amount kinds-of-coins)
    (cond ((= amount 0) 1)
          ((< amount 0) 0)
          ((= kinds-of-coins 0) 0)
          (else (+ (cc amount (- kinds-of-coins 1))
                   (cc (- amount (first-denomination kinds-of-coins)) kinds-of-coins)))))

  (cc amount 5))


; Exercise 1.11
; -------------
(define (f-recursive n)
  (if (< n 3)
      n
      (+ (f-recursive (- n 1))
         (* 2 (f-recursive (- n 2)))
         (* 3 (f-recursive (- n 3))))))

(define (f-iter n)

  ; Internal iteration function
  ;   n: the value we are calculating the function for
  ;   current-n: the value of n that this iteration should evalute f(n) for
  ;   fn-1: the value of f(current-n - 1)
  ;   fn-2: the value of f(current-n - 2)
  ;   fn-3: the value of f(current-n - 3)
  (define (f-internal-iter n current-n fn-1 fn-2 fn-3)
    (if (> current-n n)
        fn-1
        (f-internal-iter n
                         (+ current-n 1)
                         (+ fn-1 (* 2 fn-2) (* 3 fn-3))
                         fn-1
                         fn-2)))

  (if (< n 3)
      n
      (f-internal-iter n 3 2 1 0)))


; Exercise 1.12
; -------------
; pascal returns the number in Pascal's triangle given its row and column (both starting at 1)
(define (pascal row col)
  (cond ((< row 3) 1)
        ((= col 1) 1)
        ((= row col) 1)
        (else (+ (pascal (- row 1) (- col 1))
                 (pascal (- row 1) col)))))

; Exercise 1.13
; -------------
; See the interwebs :p


; Exercise 1.14 TODO
; ------------------
; Drew tree, but problem hard.  Deepest path through the tree is if you make the entire sum up from pennies.
; While there are other trees in memory at the same time, they seem to end earlier, so it looks like O(n) in
; space.  Number of steps - no idea.  Need to make progres...


; Exercise 1.15
; -------------
(define (cube x) (* x x x))
(define (p x) (- (* 3 x) (* 4 (cube x))))
(define (sine angle)
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)))))

; Part a)
; Each time we make a recursive call to sine, we divide the problem angle by 3.  When we hit an angle that is
; <= to our limit (0.1 in this case), we stop and unwind the recursive calls.  Each recursive call results in
; a call to p for the returned angle, so p is applied however many times we need to divide 12.15 by 3 to get
; a number that is less than 0.1.  12.15 / (3^4) = 0.15 and 12.15 / (3^5) = 0.05, therefore the answer is 5.
;
; Part b)
; As the problem space is being divided by 3 with each recursive call, the problem will grow in log3(a)
; space.  As the majority of the computing time will be spent processing calls to p, and p is called after
; each recursive call, the function will grow in number of steps at the same rate as it will grow in space.



; Exercise 1.16
; -------------
(define (fast-expt-116 b n)
  (define (even? n)
    (= (remainder n 2) 0))

  (define (fast-expt-iter b n a)
    (cond ((= n 0) a)
          ((= n 1) (* a b))
          ((even? n) (fast-expt-iter (* b b) (/ n 2) a))
          (else (fast-expt-iter b (- n 1) (* a b)))))

  (fast-expt-iter b n 1))


; Exercise 1.17
; -------------
(define (double n) (* n 2))
(define (halve n) (/ n 2))
(define (mult-117 a b)
    (cond ((= b 0) 0)
          ((= a 0) 0)
          ((= b 1) a)
          ((= a 1) b)   ; optimization in case called with a=1
          ((even? b) (mult-117 (double a) (halve b)))
          (else (+ a (mult-117 a (- b 1))))))


; Exercise 1.18
; -------------
(define (mult-118 a b)
  ; (+ (* a b) result) is the invariant.  If b is odd, we start by making result a and subtracting one from
  ; b, after which b is even and we can commence with the doubling and halving in logarithmic time.
  (define (mult-iter a b result)
    (cond ((= b 0) 0)
          ((= a 0) 0)
          ((= b 1) (+ result a))
          ((= a 1) (+ result b))
          ((even? b) (mult-iter (double a) (halve b) result))
          (else (mult-iter a (- b 1) (+ result a)))))

  (mult-iter a b 0))
