(require "helix/configuration.scm")
(require "helix/components.scm")
(require "helix/editor.scm")
(require "helix/misc.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
(require-builtin helix/core/text as text.)
(require "cogs/keymaps.scm")

; Actual config
(helix.theme "carbonfox_transparent")
(inline-diagnostics-end-of-line-enable "hint")
(inline-diagnostics-cursor-line-enable "warning")
(cursor-shape #:normal 'block #:select 'underline #:insert 'bar)
(line-number 'relative)
(mouse #f)
(whitespace (ws-visible #t))
(indent-guides (ig-render #t) (ig-character #\╎) (ig-skip-levels 1))
(jump-label-alphabet "jfkdls;aurieowpqnvmcxz")
(soft-wrap (sw-enable #t) (sw-max-wrap 25) (sw-max-indent-retain 0))
(keymap (global)
        (normal (ret "goto_word")
                (L "move_next_sub_word_end")
                (H "move_prev_sub_word_start")
                (space (z ":sh zathura \"$(echo %{buffer_name} | sed 's/\\.[^.]*$/.pdf/')\"")
                       (i ":yank-diagnostic")
                       (l ":o .github"))))

; LSP config
(define-lsp "steel-language-server" (command "steel-language-server") (args '()))
(define-language "scheme"
                 (formatter (command "raco") (args '("fmt" "-i")))
                 (auto-format #t)
                 (language-servers '("steel-language-server")))
(define-language "c-sharp" (language-servers '("csharp-ls")))
(define-language "python" (language-servers '("pyright")))
(define-lsp "tinymist"
            (command "tinymist")
            (config (exportPdf "onType") (outputPath "$root/$dir/$name")))

; helper scheme functions
(provide open-helix-scm
         open-init-scm
         evalp
         eval-buffer)
;;@doc
;; Open the helix.scm file
(define (open-helix-scm)
  (helix.open (helix.static.get-helix-scm-path)))

;;@doc
;; Opens the init.scm file
(define (open-init-scm)
  (helix.open (helix.static.get-init-scm-path)))

;;@doc
;; Eval prompt
(define (evalp)
  (push-component! (prompt "$ " (lambda (expr) (set-status! (eval-string expr))))))

(define (get-document-as-slice)
  (let* ([focus (editor-focus)]
         [focus-doc-id (editor->doc-id focus)])
    (text.rope->string (editor->text focus-doc-id))))

;;@doc
;; Eval the current buffer, morally equivalent to load-buffer!
(define (eval-buffer)
  (eval-string (get-document-as-slice)))
