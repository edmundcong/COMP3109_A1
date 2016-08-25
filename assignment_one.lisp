;; Question 1
;; Write a function (find-vars <expression>) that recursively traverses a expression and returns a list of
;; variables that are used in the expression. 

(defparameter variables '())

(defun find-vars (expression)
	(loop for e in expression ; loop through given symbol 
		do (if (atom e) ; if it's not a list (an atom)
			(cond ; can only do one of the following
				; compares e against symbolic transformed string for function names
				((eq e (intern "S-VAR")))
				((eq e (intern "S-ADD")))
				((eq e (intern "S-SUB")))
				((eq e (intern "S-NEG")))
				; otherwise unique and reverse array by checking if it's not a member, 
				; then push to variables list
				(t (if (not (member e variables)) (push e variables))) 
				)
		; recursively calls find-vars function for each node in expression list
		(find-vars e))
		)
	; once we have our unique list we do one last function call to return it
	; (therefore does not rely on printing the global list)
	(return-from find-vars (nreverse variables))
	)

(print (find-vars '(s-neg (s-sub (s-var a) (s-var b)))))

;; Question 2
;; Write a function (transformer <expression>) that takes a expression in Q as an argument and generates a
;; function as output.

(defun transformer (expression) ; expression: the expression given which is recursively shortened by the leading element on each call
	#'(lambda (input) ; input: the environment variable list/s given (e.g. (a 1) (b 2))
		(cond
			; if the first item in expression is s-neg
			((eq (car expression) (intern "S-NEG")) 
				(- ; minus the value from the result of the next recursive call
					(funcall (transformer (nth 1 expression)) input)) ; to transformer with the remainder of our expression, and input data as the argument to our lambda function
				)
			
			; if the first item in expression is s-add
			((eq (car expression) (intern "S-ADD"))  
				(+ ; sum the result of two calls to our transformer function with:
					(funcall (transformer (nth 1 expression)) input) ; the first s-var pairing as an argument, and the input data as the argument to our lambda function
					(funcall (transformer (nth 2 expression)) input)) ; and the second s-var pairing as an arguement, and the input data as the argument to our lambda function
				)
			
			; if the first item in expression is s-sub
			((eq (car expression) (intern "S-SUB"))  
				(- ; same as s-add but substract instead of add
					(funcall (transformer (nth 1 expression)) input) 
					(funcall (transformer (nth 2 expression)) input))
				)

			; if the first item in expression is s-var
			((eq (car expression) (intern "S-VAR"))
				(nth 1 ; get the 2nd cell (the value) of
					(assoc (nth 1 expression) input))) ; the pairing returned from finding our variable name in the passed input variables (e.g. (A 1) => 1)
		)
	)
)

(setq tq (transformer '(s-neg (s-sub (s-var a) (s-var b)))))
(print (funcall tq '((a 1) (b 2))))
(print (funcall tq '((a 3) (b 1))))

;; Question 3
;; This task is to write a query simplifier (simplify <query>), where <query> is an element in Q,
;; the set of recursively defined lists. The simplifier produces a new query as a result that is simpler.
;; Find an extensive rule set to simplify queries. Aim for minimizing the number of operators in the
;; result query.
;; Simplified Expressions:
; -(-(a-b) = (a-b)
; -((-a)-(-b)) = (a-b)
; -(a-b) = (b-a)
; (a-(-b)) = (a+b)
; (a+(-b)) = (a-b)
; ((-a)+b) = (b-a)

(defun simplify (expression)
	(if (null (cdr expression)) (setq expression (car expression))) ; if list of list turn into list (e.g. ((a)) => (a) )
	(setq head (car expression)) 
	(setq tail (cdr expression))

	(if (listp (car tail)) (setq swp (nreverse (cdr (car tail))))) 

	(cond
		((eq head (intern "S-NEG")) 
			(cond 
				((eq (car (car tail)) (intern "S-NEG")) (simplify (print (car (cdr (car tail)))))) ; -(-(a-b) = (a-b)
				((eq (car (car tail)) (intern "S-SUB")) (simplify (print (push (car (car tail)) swp)))) ; -(a-b) = (b-a)
			))
		((eq head (intern "S-SUB"))
			(cond 
				((eq (car (car tail)) (intern "S-VAR")) 
					(cond ((eq (car (car (cdr tail))) (intern "S-NEG"))  
										 						(simplify (print (cons 'S-ADD (cons (car tail) (cdr (car (cdr tail)))))))))) ; (a-(-b)) = (a+b)
				((eq (car (car tail)) (intern "S-NEG")) (simplify (print (cons head (cons   (cdr (car (cdr tail))) (car (cdr (car tail)))))))) ; -((-a)-(-b)) = (a-b)
			))
		((eq head (intern "S-ADD")) 
			(cond 
				((eq (car (car tail)) (intern "S-VAR")) 
					(cond ((eq (car (car (cdr tail))) (intern "S-NEG"))  
										 						(simplify (print (cons 'S-SUB (cons (car tail) (cdr (car (cdr tail)))))))))) ; (a+(-b)) = (a-b)
				((eq (car (car tail)) (intern "S-NEG")) 
					(cond ((eq (car (car (cdr (car tail)))) (intern "S-VAR"))  
										 						(simplify (print (cons 'S-SUB (car (cons (cdr (car tail)) (cdr (car (cdr tail))))))))))) ; ((-a)+b) = (b-a)
			))		
	)
)

; (simplify '(s-neg (s-neg (s-sub (s-var a) (s-var b)))))
; (simplify '(s-neg (s-sub (s-var a) (s-var b))))
; (simplify '(s-neg (s-neg (s-neg (s-sub (s-var a) (s-var b))))))
(simplify '(s-sub (s-neg (s-var a)) (s-neg (s-var b))))  
; (simplify '(s-sub (s-var a) (s-neg (s-var b))))
; (simplify '(s-add (s-var a) (s-neg (s-var b))))
; (simplify '(s-add (s-neg (s-var a) (s-var b))))