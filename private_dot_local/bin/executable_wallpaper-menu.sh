#!/usr/bin/env fish

# wezterm start --always-new-process --class "floatterm" --cwd ~/Pictures/Wallpapers/Mocha/ fish -ic 'wallpaper (pwd)/(fzf)'

floatterm-exec "cd ~/Pictures/Wallpapers/Mocha && yazi --chooser-file $HOME/.config/wallpaper"

wallpaper init
