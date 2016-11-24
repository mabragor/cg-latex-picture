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
  (cond ((consp x)
	 (if (symbolp (car x))
	     (funcall (gethash (string (car x)) *textgens*) x)
	     (joinl "~%" (mapcar #'textgen x))))
	((stringp x) x)
	((symbolp x) (stringify-symbol x))
	(t (error "Don't know how to generate text for this: ~a" x))))

(defmacro define-textgen (name args &body body)
  (let ((fun-name (intern #?"$((string name))-TEXTGEN")))
    `(eval-when (:compile-toplevel :load-toplevel :execute)
       (progn (defun ,fun-name (form)
		(destructuring-bind ,args (cdr form)
		  ,@body))
	      (setf (gethash ,(string name) *textgens*) #',fun-name)))))

(define-textgen put (x y obj)
  #?"\\put($(x), $(y)){$((textgen obj))}")

(define-textgen multiput (x y dx dy n obj)
  #?"\\multiput($(x), $(y))($(dx), $(dy)){$(n)}{$((textgen obj))}")

;; For now we perform no checking on the arguments (this assumed to be handled already by the higher levels)
(define-textgen line (x y length)
  #?"\\line($(x), $(y)){$(length)}")

(define-textgen vector (x y length)
  #?"\\vector($(x), $(y)){$(length)}")

(define-textgen circle (diameter)
  #?"\\circle{$(diameter)}")

(define-textgen disk (diameter)
  #?"\\circle*{$(diameter)}")

(define-textgen line-thickness (dimen)
  #?"\\linethickness{$((textgen dimen))}")

(define-textgen thicklines ()
  #?"\\thicklines")
(define-textgen thinlines ()
  #?"\\thinlines")

(defun tblr-textgen (lst)
  (if lst
      (let ((it (with-output-to-string (stream)
		  (iter (for elt in lst)
			(cond ((or (eq elt :top) (eq elt :t)) (format stream "t"))
			      ((or (eq elt :bottom) (eq elt :b)) (format stream "b"))
			      ((or (eq elt :left) (eq elt :l)) (format stream "l"))
			      ((or (eq elt :right) (eq elt :r)) (format stream "r")))))))
	#?"[$(it)]")
      ""))


(define-textgen oval (w h &rest tblr)
  #?"\\oval($(w), $(h))$((tblr-textgen tblr))")

(define-textgen newsavebox (name)
  #?"\\newsavebox{\\$((textgen name))}")

(define-textgen savebox (name width height (&rest position) &rest content)
  (let ((text-content (joinl "~%  " (mapcar #'textgen content))))
    #?"\\savebox{\\$((textgen name))}($(width), $(height))$((tblr-textgen position)){\n  $(text-content)}"))

(define-textgen usebox (name)
  #?"\\usebox{\\$((textgen name))}")

(define-textgen qbezier (x1 y1 x y x2 y2)
  #?"\\qbezier($(x1), $(y1))($(x), $(y))($(x2), $(y2))")

(define-textgen picture ((x y) (&rest x0y0) &rest subforms)
  (let ((text-subforms (joinl "~%  " (mapcar #'textgen subforms))))
    (join "~%"
	  #?"\\begin{picture}($(x), $(y))$((if (not x0y0) "" #?"($((car x0y0)), $((cadr x0y0)))"))"
	  #?"  $(text-subforms)"
	  #?"\\end{picture}")))

;; OK, now I have the lowest level possible -- I can write in lispy way put commands
;; What's next?

(defmacro with-lapic-function-transformer (&body body)
  `(let ((*function-transformer* (lambda (form)
				   ...)))
     ,@body))

