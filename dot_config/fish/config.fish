if status is-interactive

# Commands to run in interactive sessions can go here

fish_vi_key_bindings

# Configure path for localb
fish_add_path "$HOME"/.local/bin
fish_add_path /home/linuxbrew/.linuxbrew/bin
fish_add_path /home/linuxbrew/.linuxbrew/sbin
fish_add_path "$HOME"/.cargo/bin

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

