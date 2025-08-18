(require "helix/configuration.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require "helix/ext.scm")
(require (prefix-in helix.static. "helix/static.scm"))
(require (prefix-in helix. "helix/commands.scm"))
(require "modeline/modeline.scm")
(require-builtin helix/core/text)

; Actual config
(helix.theme "carbonfox_transparent")
(inline-diagnostics-end-of-line-enable "hint")
(inline-diagnostics-cursor-line-enable "warning")
(cursor-shape #:normal 'block #:select 'underline #:insert 'bar)

;; requires PR: https://github.com/mattwparas/helix/pull/54
; (line-number 'relative)
; (whitespace (ws-visible #t))
; (indent-guides (ig-render #t) (ig-character #\╎) (ig-skip-levels 1))
; (jump-label-alphabet "jfkdls;aurieowpqnvmcxz")
(mouse #f)
(soft-wrap (sw-enable #t) (sw-max-wrap 25) (sw-max-indent-retain 0))
(rainbow-brackets #t)
(require "cogs/keymaps.scm")
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
(define-language "c-sharp" (language-servers '("csharp-ls")))
(define-language "python" (language-servers '("pyright")))
(define-lsp "tinymist" (config (exportPdf "onType") (outputPath "$root/$dir/$name")))
(define-lsp "godot" (command "nc") (args '("127.0.0.1" "6005")))
(define-language "gdscript" (language-servers '("godot")))

;; Plugins
(modeline-enable)
(provide refresh-modeline)

; config helpers
(define (open-helix-scm)
  (helix.open (helix.static.get-helix-scm-path)))
(define (open-init-scm)
  (helix.open (helix.static.get-init-scm-path)))
; helper scheme functions from ext.scm
(provide open-helix-scm
         open-init-scm
         evalp
         eval-buffer
         rope-regex)
