# COMP3109_A1
Functinal Programming Assignment 1
COMP3109
 Assignment 1
Functional Programming (10 marks)
This first assignment is an individual assignment, and is due in Week 5 on Friday, August 26,
at 6pm. Please pack the source code of this assignment into a zip file and submit it via eLearning.
The documentation of the program should be done in form of comments. Please be verbose with your
comments, i.e., explain your ideas thoroughly, saying in plain English how you have implemented the
program. Not complying to documentation standards will give you less marks for your assignment.
In this assignment you will implement a function evaluator for arithmetic functions. Please choose one
of the following functional programming languages to implement your assignment in: LISP, SCHEME
or Haskell. Your assignment should run on the ucpu[01] machines and/or on the workspaces on
edstem.com.au.
We define a set of arithmetic functions for a variable environment. A variable environment is a list of
pairs, each associating an arithemtic value with a variable, i.e., an environment is given as:
((var1 . value1) ... (varN .valueN))
We assume that data values in the association list are numbers, e.g., 1, 10, −1, etc. Another assump-
tion is that we have for a single variable a unique pair in the variable environment. For example the
following variable environment describes the values of variables a, b, and c.
variablea
b
c
value
1
10
-4
This table is translated to following list object:
1
 (setq my-environment '( (a 1) (b 10) (c -4) ))
For a variable environment, we would like to formulate a “composed” arithmetic function. This
arithmetic function queries the environment for variable values, and computes arithmetic operations.
An arithmetic function is given in form of a recursively defined list. The recursive list is an element
of the following inductively defined set Q:
1. If v is a variable, then (s-var v ) ∈ Q.
2. If a, b ∈ Q then (s-add a b) ∈ Q.
3. If a, b ∈ Q then (s-sub a b) ∈ Q.
4. If a ∈ Q then (s-neg a) ∈ Q.
1
COMP3109
5. Nothing else is in Q.
where the arithmetic operator s-add and s-sub represents the addition and subtraction, i.e., a + b
and a − b, respectively. The arithmetic operator s-neg represents the negation, i.e., −a, and s-var
retrieves the value of the given variable from the variable environment.
For example the following list (s-neg (s-sub (s-var a) (s-var b))) is in Q and semanti-
cally models the query: −(a − b)).
1
 Question 1 (2 marks)
Write a function (find-vars <query>) that recursively traverses a query and returns a list of
variables that are used in the query. For example
1
 (find-vars '(s-neg (s-sub (s-var a) (s-var b)) (s-var a)))
should return (a b). Do not return multiple occurrences of variables. You may assume that the
recursive list <query> is always an element of Q, so error-handling is not needed.
2
 Question 2 (4 marks)
Write a function (transformer <query>) that takes a query in Q as an argument and generates a
function as output. The generated function has a variable environment as input and returns the value
of the epression. Note that the transformer reads recursively the elements of a query and constructs a
lambda function on the fly. For example
1
 > (setq tq (transformer '(s-neg (s-sub (s-var a) (s-var b)))))
2
 ...
3
 > (funcall tq '((a 1) (b 2)))
4
 1
5
 > (funcall tq '((a 3) (b 1)))
6
 -2
Hint: Start simple. Try to translate the variable environment access and from there you construct
lambda terms for operators s-neg, s-add, and s-sub.
3
 Question 3 (4 marks)
This task is to write a query simplifier (simplify <query>), where <query> is an element in Q,
the set of recursively defined lists. The simplifier produces a new query as a result that is simpler.
Find an extensive rule set to simplify queries. Aim for minimizing the number of operators in the
result query.
Programming Languages and Paradigms
 Page 2 of 2
