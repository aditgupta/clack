#|
  This file is a part of Clack package.
  URL: http://github.com/fukamachi/clack
  Copyright (c) 2011 Eitarow Fukamachi <e.arrows@gmail.com>

  Clack is freely distributable under the LLGPL License.
|#

#|
  Clack is a Web server Interface for Common Lisp.

  Author: Eitarow Fukamachi (e.arrows@gmail.com)
|#

(in-package :cl-user)

(defpackage clack-asd
  (:use :cl :asdf))

(in-package :clack-asd)

(defsystem clack
  :version "0.1-SNAPSHOT"
  :author "Eitarow Fukamachi"
  :license "LLGPL"
  :depends-on (;; Utility
               :alexandria
               :metabang-bind
               :anaphora
               :split-sequence
               :cl-annot
               ;; Server
               :hunchentoot
               #+(or allegro cmu lispworks sbcl)
               :modlisp
               ;; for Other purpose
               :cl-ppcre
               :cl-fad
               :cl-test-more
               :cl-oauth
               :ironclad
               :drakma
               :local-time)
  :components ((:module "src"
                :components
                ((:module "core"
                  :depends-on ("util")
                  :components
                  ((:file "clack"
                    :depends-on ("component" "middleware" "handler"))
                   (:file "builder")
                   (:file "response")
                   (:file "request")
                   (:file "component")
                   (:file "middleware" :depends-on ("component"))
                   (:file "logger")
                   (:module "handler"
                    :depends-on ("component")
                    :components
                    ((:file "hunchentoot")
                     #+(or allegro cmu lispworks sbcl)
                     (:file "apache")))
                   (:file "test")
                   (:file "test/suite" :depends-on ("test"))
                   (:module "app"
                    :depends-on ("clack")
                    :components
                    ((:file "file")))
                   (:module "mw"
                    :pathname "middleware"
                    :depends-on ("clack" "response" "request")
                    :components
                    ((:file "static")
                     (:module "log"
                      :pathname "logger"
                      :serial t
                      :components
                      ((:file "base")
                       (:file "stream")
                       (:file "logger")))
                     (:module "session"
                      :serial t
                      :components
                      ((:file "state")
                       (:file "state/cookie")
                       (:file "store")
                       (:file "session")))))))
                 (:module "contrib"
                  :depends-on ("util" "core")
                  :components
                  ((:module "app"
                    :components
                    ((:file "route")))
                   (:module "middleware"
                    :components
                    ((:file "oauth")))))
                 (:module "util"
                  :serial t
                  :components
                  ((:file "doc")
                   (:file "util")
                   (:file "hunchentoot"))))))
  :description "Web Application Environment for Common Lisp"
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :direction :input)
      (let ((seq (make-array (file-length stream)
                             :element-type 'character
                             :fill-pointer t)))
        (setf (fill-pointer seq) (read-sequence seq stream))
        seq)))

;; Run unit tests.
#|
(defmethod asdf:perform :after ((op load-op) (c (eql (find-system :clack))))
  (asdf:oos 'asdf:load-op :clack-test))
|#
