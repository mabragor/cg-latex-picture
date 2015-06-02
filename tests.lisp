

(in-package :cl-user)

(defpackage :cg-latex-picture-tests
  (:use :cl :cg-latex-picture :fiveam :iterate)
  (:export #:run-tests))

(in-package :cg-latex-picture-tests)

(cl-interpol:enable-interpol-syntax)

(def-suite cg-latex-picture)
(in-suite cg-latex-picture)

(defun run-tests ()
  (let ((results (run 'cg-latex-picture)))
    (fiveam:explain! results)
    (unless (fiveam:results-status results)
      (error "Tests failed."))))

(test basic
  (is (equal "\\put(1, 2){asdf}" (textgen '(put 1 2 "asdf"))))
  (is (equal "\\multiput(X, Y)(DX, DY){N}{object}" (textgen '(multiput x y dx dy n object))))
  (is (equal "\\oval(W, H)" (textgen '(oval w h))))
  (is (equal "\\oval(W, H)[tblr]" (textgen '(oval w h :top :bottom :l :r)))))