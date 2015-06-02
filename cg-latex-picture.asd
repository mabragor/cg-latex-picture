;;;; cg-latex-picture.asd

(asdf:defsystem #:cg-latex-picture
  :description "Convenience layer on top of LaTeX picture environment"
  :author "Alexandr Popolitov <popolit@gmail.com>"
  :license "MIT"
  :serial t
  :depends-on (#:cg-common-ground)
  :components ((:file "package")
               (:file "cg-latex-picture")))

