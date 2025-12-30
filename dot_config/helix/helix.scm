(require "helix/configuration.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require "helix/ext.scm")
(require (prefix-in helix.static. "helix/static.scm"))
(require (prefix-in helix. "helix/commands.scm"))
(require-builtin helix/core/text)
(require "modeline/modeline.scm")
(require "helix/keymaps.scm")

; Actual config
(helix.theme "carbonfox_transparent")
(inline-diagnostics-end-of-line-enable "hint")
(inline-diagnostics-cursor-line-enable "warning")
(cursor-shape #:normal 'block #:select 'underline #:insert 'bar)

(line-number 'relative)
(whitespace (ws-visible #t))
(indent-guides (ig-render #t) (ig-character #\╎) (ig-skip-levels 1))
(jump-label-alphabet "jfkdls;aurieowpqnvmcxz")
(mouse #f)
(soft-wrap (sw-enable #t) (sw-max-wrap 25) (sw-max-indent-retain 0))
(rainbow-brackets #t)
(keymap (global)
        (normal (ret "goto_word")
                (L "move_next_sub_word_end")
                (H "move_prev_sub_word_start")
                (space (z ":sh zathura \"$(echo %{buffer_name} | sed 's/\\.[^.]*$/.pdf/')\"")
                       (i ":yank-diagnostic")
                       (l ":o .github")
                       (b ":sh git blame -L %{cursor_line},%{cursor_line} %{buffer_name}"))))

; LSP config
(define-lsp "steel-language-server" (command "steel-language-server") (args '()))
(define-language "scheme"
                 (formatter (command "raco") (args '("fmt" "-i")))
                 (auto-format #t)
                 (language-servers '("steel-language-server")))

(define-language "racket" (formatter (command "raco") (args '("fmt" "-i"))) (auto-format #t))
(define-language "c-sharp" (language-servers '("csharp-ls")))
(define-language "python" (language-servers '("pyright")))
(define-lsp "tinymist" (config (exportPdf "onType") (outputPath "$root/$dir/$name")))
(define-lsp "godot" (command "nc") (args '("127.0.0.1" "6005")))
(define-language "gdscript" (language-servers '("godot")))

;; Plugins

; config helpers
(define (open-helix-scm)
  (helix.open (helix.static.get-helix-scm-path)))
(define (open-init-scm)
  (helix.open (helix.static.get-init-scm-path)))
(define (fmt-lambda)

  (define current-selection (helix.static.current-selection-object))

  (helix.static.select_all)
  (helix.static.regex-selection "lambda\n")
  (helix.static.replace-selection-with "λ\n")

  (helix.static.select_all)
  (helix.static.regex-selection "lambda ")
  (helix.static.replace-selection-with "λ ")

  (helix.static.merge_selections)

  (helix.static.move_visual_line_down)
  (helix.static.move_visual_line_up))

(modeline-enable)

; helper scheme functions from ext.scm
(provide open-helix-scm
         open-init-scm
         evalp
         eval-buffer
         fmt-lambda)
