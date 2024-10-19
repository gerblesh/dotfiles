fish_add_path -P --prepend "$HOME"/.local/bin
if status is-interactive

set -Ux XDG_DATA_DIRS "/home/linuxbrew/.linuxbrew/share:$XDG_DATA_DIRS"
    function yy
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end


    function setup_vi_mode
        # set -Ux fish_cursor_default block
        # Set the insert mode cursor to a line
        # set -Ux fish_cursor_insert line
        # Set the replace mode cursors to an underscore
        # set -Ux fish_cursor_replace_one underscore
        # set -Ux fish_cursor_replace underscore
        # Set the external cursor to a line. The external cursor appears when a command is started.
        # The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
        # set -Ux fish_cursor_external line
        # The following variable can be used to configure cursor shape in
        # visual mode, but due to fish_cursor_default, is redundant here
        # set -Ux fish_cursor_visual block

        # Commands to run in interactive sessions can go here
        fish_vi_key_bindings
    end

    # set fish_vi_force_cursor 1

    function setup_homebrew
        fish_add_path -P --append /home/linuxbrew/.linuxbrew/bin
        fish_add_path -P --append /home/linuxbrew/.linuxbrew/sbin
        set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
        set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar"
        set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew"
    end

    fish_add_path -P --prepend "$HOME"/.local/bin
    fish_add_path -P --append "$HOME"/.cargo/bin
    set -Ux FZF_DEFAULT_OPTS "--color=fg:#ebdbb2,bg:#282828,hl:#b16286 --color=fg+:#689d6a,bg+:#32302f,hl+:#d3869b --color=info:#d65d0e,prompt:#458588,pointer:#fe8019 --color=marker:#8ec07c,spinner:#cc241d,header:#fabd2f --preview='fzf-preview.sh {}'"

#     set -Ux FZF_DEFAULT_OPTS "\
# --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
# --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
# --preview='fzf-preview.sh {}'"
    set SHELL "fish"

    setup_vi_mode
    setup_homebrew
    # Configure path for localbin

    function fish_greeting
        # blank fish greeting
    end

    if which flatpak >/dev/null 2>&1
        alias mpv="flatpak run io.mpv.Mpv"
    end

    if which eza >/dev/null 2>&1
        alias ls="eza --icons --sort type"
    end

    # if which hx >/dev/null 2>&1
    #     alias nvim="hx"
    # end

    if which podman >/dev/null
        alias butane='podman run --rm --interactive       \
                  --security-opt label=disable        \
                  --volume {$PWD}:/pwd --workdir /pwd \
                  quay.io/coreos/butane:release'
    end

    set EDITOR "/home/linuxbrew/.linuxbrew/bin/nvim"

    if which nvim >/dev/null 2>&1
        alias nano="nvim"
    end

    if which zoxide >/dev/null 2>&1
        eval (zoxide init --cmd cd fish | source) >/dev/null 2>&1
    end
    if test -d (brew --prefix)"/share/fish/completions"
        set -p fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end

end
