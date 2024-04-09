if status is-interactive

set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert line
# Set the replace mode cursors to an underscore
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
# Set the external cursor to a line. The external cursor appears when a command is started.
# The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
set fish_cursor_external line
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block


# Commands to run in interactive sessions can go here

fish_vi_key_bindings

# Configure path for localb
fish_add_path -P --append "$HOME"/.local/bin
fish_add_path -P --append /home/linuxbrew/.linuxbrew/bin
fish_add_path -P --append /home/linuxbrew/.linuxbrew/sbin
fish_add_path -P --append "$HOME"/.cargo/bin

function fish_greeting
# blank fish greeting
end

if which flatpak > /dev/null 2>&1
    alias mpv="flatpak run io.mpv.Mpv"
end

if which eza > /dev/null 2>&1
    alias ls="eza --icons --sort type"
end

if which podman > /dev/null
    alias butane='podman run --rm --interactive       \
                  --security-opt label=disable        \
                  --volume {$PWD}:/pwd --workdir /pwd \
                  quay.io/coreos/butane:release'
end

if which nvim > /dev/null 2>&1
    alias nano="nvim"
end

set EDITOR /usr/bin/vi

if which zoxide > /dev/null 2>&1
    eval (zoxide init --cmd cd fish | source) > /dev/null 2>&1
end
if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end

if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

end

