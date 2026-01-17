(define package-name 'my-helix-config)
(define version "0.1.0")

;; Point to all of the packages that exist
(define dependencies
  '((#:name breadcrumbs #:git-url "https://codeberg.org/gwid/breadcrumbs.hx.git")
    (#:name modeline #:git-url "https://codeberg.org/gwid/modeline.hx.git")))

(define dylibs '())
