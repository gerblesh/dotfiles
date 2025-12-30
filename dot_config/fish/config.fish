if status is-interactive
    set PATH "/usr/bin:/usr/sbin:/usr/local/bin"
    set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -x MANROFFOPT -c
    # set HOME /var/home/user
    fish_add_path -P --prepend "$HOME"/.local/bin
    fish_add_path -P "$HOME/.dotnet/tools"
    set -Ux XDG_DATA_DIRS "$XDG_DATA_DIRS:/home/linuxbrew/.linuxbrew/share"
    function yy
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    function setup_vi_mode
        set -Ux fish_cursor_default underscore
        # Set the insert mode cursor to a line
        set -Ux fish_cursor_insert underscore
        # Set the replace mode cursors to an underscore
        set -Ux fish_cursor_replace_one underscore
        set -Ux fish_cursor_replace underscore
        # Set the external cursor to a line. The external cursor appears when a command is started.
        # The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
        set -Ux fish_cursor_external underscore
        # The following variable can be used to configure cursor shape in
        # visual mode, but due to fish_cursor_default, is redundant here
        set -Ux fish_cursor_visual underscore

        # Commands to run in interactive sessions can go here
        fish_vi_key_bindings
    end

    function ba # brew apply
        brew bundle --cleanup --file ~/.config/Brewfile
    end

    function eb # edit brew
        $EDITOR ~/.config/Brewfile
    end

    function cgitcm # chezmoi git commit
        chezmoi re-add
        chezmoi git add .
        chezmoi git commit
    end

    function cgitps # chezmoi git push
        chezmoi git push
    end

    function cgitpl # chezmoi git pull, and apply
        chezmoi git pull
        chezmoi apply
    end

    function flatdump
        flatpak list --user --columns=application >~/.config/Flatpakfile
    end

    function groot
        set GROOT (git rev-parse --show-toplevel 2>&1)
        if test $status -ne 0
            echo "Not inside a Git repository."
            return 1
        end
        cd $GROOT
    end

    function flatinstall
        xargs -a ~/.config/Flatpakfile flatpak install --user -y
    end

    # set fish_vi_force_cursor 1

    function setup_homebrew
        fish_add_path -P --append /home/linuxbrew/.linuxbrew/bin
        fish_add_path -P --append /home/linuxbrew/.linuxbrew/sbin
        set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
        set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar"
        set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew"
        if not which brew >/dev/null 2>&1
            return
        end

        if test -d (brew --prefix)"/share/fish/completions"
            set -p fish_complete_path (brew --prefix)/share/fish/completions
        end

        if test -d (brew --prefix)"/share/fish/vendor_completions.d"
            set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
        end
        # set -gx LDFLAGS "-L$HOMEBREW_PREFIX/lib $LDFLAGS"
        # set -gx CPPFLAGS "-I$HOMEBREW_PREFIX/include $CPPFLAGS"
        # set -gx PKG_CONFIG_PATH "$HOMEBREW_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
    end

    fish_add_path -P --prepend /usr/local/bin
    fish_add_path -P --prepend "$HOME"/.local/bin
    fish_add_path -P --append "$HOME"/.cargo/bin
    # Gruvbox
    # set -Ux FZF_DEFAULT_OPTS "--color=fg:#ebdbb2,hl:#b16286 --color=fg+:#689d6a,bg+:#32302f,hl+:#d3869b --color=info:#d65d0e,prompt:#458588,pointer:#fe8019 --color=marker:#8ec07c,spinner:#cc241d,header:#fabd2f --preview='fzf-preview.sh {}'"

    # Carbonfox
    set -Ux FZF_DEFAULT_OPTS '
    --color=fg:-1,fg+:#6e6f70,bg:-1,bg+:#282828
    --color=hl:#33b1ff,hl+:#52bdff,info:#afaf87,marker:#25be6a
    --color=prompt:#33b1ff,spinner:#be95ff,pointer:#be95ff,header:#87afaf
    --color=border:#262626,label:#aeaeae,query:#d9d9d9
    --preview-window="border-rounded" --prompt="  " --marker="↪" --pointer="◆"
    --separator="─" --scrollbar="│"'

    # Kaolin
    # set -Ux FZF_DEFAULT_OPTS '
    #   --color=fg:#c5c8c6,fg+:#ffffff,bg:#1d1f21,bg+:#1d1f21
    #   --color=hl:#81a2be,hl+:#8abeb7,info:#f0c674,marker:#b5bd68
    #   --color=prompt:#81a2be,spinner:#b294bb,pointer:#b294bb,header:#8abeb7
    #   --color=border:#1d1f21,label:#c5c8c6,query:#ffffff
    #   --preview-window=border-rounded --prompt="  " --marker="↪" --pointer="◆"
    #   --separator="─" --scrollbar="│"'
    set SHELL /bin/fish

    setup_vi_mode
    setup_homebrew

    function fish_greeting
        # Silverblue fix
        set -l pwd (string replace /var/home /home $PWD)
        cd "$pwd"
    end

    if which flatpak >/dev/null 2>&1
        alias mpv="flatpak run io.mpv.Mpv"
    end
    if which haxelib >/dev/null 2>&1
        alias flixel="haxelib run flixel-tools"
    end

    if which eza >/dev/null 2>&1
        alias ls="eza --icons --sort type"
    end
    if which bat >/dev/null 2>&1
        alias cat="bat"
    end

    function __editor_fzf
        set FZF_RET (fzf)
        if test $status != 0
            return
        end
        "$EDITOR" "$FZF_RET"
    end

    if which hx >/dev/null 2>&1
        set EDITOR (which hx)
        set SUDO_EDITOR $EDITOR
        bind --mode insert \ce __editor_fzf
    end

    if which zoxide >/dev/null 2>&1
        eval (zoxide init --cmd cd fish | source) >/dev/null 2>&1
        bind --mode insert \cw __zoxide_zi
        bind --mode insert \cp '__zoxide_zi && __editor_fzf'
    end

    if which lazygit >/dev/null 2>&1
        alias lg=lazygit
        bind --mode insert \cg lazygit
    end

    if which mise >/dev/null 2>&1
        mise activate fish | source
    end

    function __select_from_last
        set -l FZF_OUT (eval $history[1] | fzf)
        if test -n "$FZF_OUT"
            commandline -a "$FZF_OUT "
            commandline -f end-of-line
        end
    end

    alias sudo 'run0 --background='

    function dnfzf
        dnf list --available | grep -Ev "Available packages" | fzf --preview 'dnf info {1}'
    end
    alias psql=psql-17

    bind --mode insert \cn __select_from_last
end
