;; The problem is to place n queens on an n × n chessboard,
;;   so that no two queens are attacking each other.
;; An exercise in backtracking!
(require "asdf")

(defpackage :randumb-n-queens  
  (:use :cl)) 

(in-package :randumb-n-queens)

;; Q is a vector of length n, where n is the # of rows on the chessboard.
;; Each element in Q holds the col # for which a Queen is placed on that row.
;; For example: Q[1 3 0 2] indicates there is a queen on...
;;   the 2nd col of the first row,
;;   the 4th col of the second row,
;;   the 1st col of the third row,
;;   and the 3rd col of the last row
(defun print-queens (Q)
  (let ((n (length Q)))
    (dotimes (rank n)
      (dotimes (file n)
	(let ((piece (if (= (nth rank Q) file) "♛"
			 (if (evenp (+ rank file)) "■" "□"))))
          (format t "~a " piece)))
      (format t "~%")))
  (format t "~%"))

;; Solution #1, trying to be fast.
;; Only printing the solutions, not tracking the total # of solutions.
(defun place-queens (Q r)
  (let ((n (length Q)))
    (if (= r n)
	(print-queens Q)
	(dotimes (j n)
	  (let ((legal t))
	    (dotimes (i r)
	      (when (or (= (nth i Q) j)
			(= (nth i Q) (- (+ j r) i))
			(= (nth i Q) (+ (- j r) i)))
		(setf legal nil)))
	    (when legal
	      (setf (nth r Q) j)
	      (place-queens Q (+ 1 r))))))))

(place-queens (make-list 8 :initial-element nil) 0)

;; Solution #2, messing around with scope in order to track # of solutions.
;; Tracking the # of solutions, not printing any.
(defun place-queens-counting (Q r)
  (let ((n (length Q))
	(acc 0))
    (labels ((place-queens-aux (Q r)
		 (if (= r n)
		     (setf acc (+ 1 acc))
		     (dotimes (j n)
		       (let ((legal t))
			 (dotimes (i r)
			   (when (or (= (nth i Q) j)
				     (= (nth i Q) (- (+ j r) i))
				     (= (nth i Q) (+ (- j r) i)))
			     (setf legal nil)))
			 (when legal
			   (setf (nth r Q) j)
			   (place-queens-aux Q (+ 1 r))))))))
      (place-queens-aux Q r))
    (format t "~a~%" acc)
    acc))

(place-queens-counting (make-list 8 :initial-element nil) 0)

#| Comparison of extra overhead of tracking the # of solutions.
   The overhead occurs because the recursion actually has to unwind in order 
     to get all the accumulations on `acc`.

  seconds  |     gc     |  consed | calls |  sec/call  |  name  
-----------------------------------------------------
     0.002 |      0.000 |       0 |     1 |   0.002436 | PLACE-QUEENS-COUNTING
     0.000 |      0.000 | 243,216 | 2,057 |   0.000000 | PLACE-QUEENS
-----------------------------------------------------
     0.003 |      0.000 | 243,216 | 2,058 |            | Total

|#
