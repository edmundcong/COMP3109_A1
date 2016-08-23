;; Question 1
;; Write a function (find-vars <query>) that recursively traverses a query and returns a list of
;; variables that are used in the query. 

(defparameter variables '())

(defun find-vars (query)
	(loop for e in query ; loop through given symbol 
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
		; recursively calls find-vars function for each node in query list
		(find-vars e))
		)
	; once we have our unique list we do one last function call to return it
	; (therefore does not rely on printing the global list)
	(return-from find-vars (nreverse variables))
	)

(print (find-vars '(s-neg (s-sub (s-var a) (s-var b)))))

;; Question 2
;; Write a function (transformer <query>) that takes a query in Q as an argument and generates a
;; function as output.

(defun transformer (query) ; query: the expression given which is recursively shortened by the leading element on each call
	(lambda (input) ; input: the environment variable list/s given (e.g. (a 1) (b 2))
		(cond
			; if the first item in query is s-var
			((eq (car query) (intern "S-VAR"))
				(nth 1 ; get the 2nd cell (the value) of
					(assoc (nth 1 query) input))) ; the pairing returned from finding our variable name in the passed input variables (e.g. (A 1) => 1)
			
			; if the first item in query is s-neg
			((eq (car query) (intern "S-NEG")) 
				(- ; minus the value from the result of the next recursive call
					(funcall (transformer (nth 1 query)) input)) ; to transformer with the remainder of our query, and input data as the argument to our lambda function
				)
			
			; if the first item in query is s-add
			((eq (car query) (intern "S-ADD"))  
				(+ ; sum the result of two calls to our transformer function with:
					(funcall (transformer (nth 1 query)) input) ; the first s-var pairing as an argument, and the input data as the argument to our lambda function
					(funcall (transformer (nth 2 query)) input)) ; and the second s-var pairing as an arguement, and the input data as the argument to our lambda function
				)
			
			; if the first item in query is s-sub
			((eq (car query) (intern "S-SUB"))  
				(- ; same as s-add but substract instead of add
					(funcall (transformer (nth 1 query)) input) 
					(funcall (transformer (nth 2 query)) input))
				)
		)
	)
)

(setq tq (transformer '(s-neg (s-sub (s-var a) (s-var b)))))
(print (funcall tq '((a 1) (b 2))))
(print (funcall tq '((a 3) (b 1))))
