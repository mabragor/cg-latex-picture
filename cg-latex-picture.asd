;;;; cg-latex-picture.asd

(asdf:defsystem #:cg-latex-picture
  :description "Convenience layer on top of LaTeX picture environment"
  :author "Alexandr Popolitov <popolit@gmail.com>"
  :license "MIT"
  :serial t
  :depends-on (#:cg-common-ground #:cl-interpol)
  :components ((:file "package")
               (:file "cg-latex-picture")))

(defsystem :cg-latex-picture-tests
  :description "Tests for CG-LATEX-PICTURE."
  :licence "MIT"
  :depends-on (:cg-latex-picture :fiveam :cl-interpol)
  :components ((:file "tests")))

(defmethod perform ((op test-op) (sys (eql (find-system :cg-latex-picture))))
  (load-system :cg-latex-picture)
  (funcall (intern "RUN-TESTS" :cg-latex-picture)))
