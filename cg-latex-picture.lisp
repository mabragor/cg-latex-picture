;;;; cg-latex-picture.lisp

(in-package #:cg-latex-picture)

(cl-interpol:enable-interpol-syntax)

;; OK, what now?
;; * lisp-side syntax for all low-level commands
;; * ...
;; * PROFIT!

;; What these different commands are?
;; * \begin{picture} ... \end{picture}
;; * \setlength{\unitlength}{1.2cm}
;; * \put, \multiput{...}
;; * \line
;; * \vector
;; * \circle
;; * escaping the TeX formulae
;; * \linethickness
;; * \oval
;; * \newsavebox ... \usebox
;; * \qbezier

(defparameter *textgens* (make-hash-table :test #'equal))

(defun textgen (x)
  (cond ((consp x) (funcall (gethash (string (car x)) *textgens*) x))
	((stringp x) x)
	(t (error "Don't know how to generate text for this: ~a" x))))

(defmacro define-textgen (name &body body)
  (let ((fun-name (intern #?"$((string name))-TEXTGEN")))
    `(eval-when (:compile-toplevel :load-toplevel :execute)
       (progn (defun ,fun-name (x)
		,@body)
	      (setf (gethash ,(string name) *textgens*) #',fun-name)))))

;; put

(define-textgen put 
  (destructuring-bind (x y obj) (cdr x)
    #?"\\put($(x), $(y)){$((textgen obj))}"))
