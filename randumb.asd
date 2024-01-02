;; Usual Lisp comments are allowed here

(defsystem "randumb"
  :description "random practice stuff"
  :version "0.0.1"
  :author "Kyle Harrington <harintonkairu@gmail.com>"
  :licence "Public Domain"
  :depends-on ("alexandria" 
               "bt-semaphore" 
	       "cl-ppcre"
	       "listopia"
               "lparallel" 
               "magicl" 
               "serapeum"
               "trivia"
               "uiop")
  :components ((:file "n-queens")))
