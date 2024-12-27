#!/usr/bin/env fish

# wezterm start --always-new-process --class "floatterm" --cwd ~/Pictures/Wallpapers/Mocha/ fish -ic 'wallpaper (pwd)/(fzf)'

ghostty --title="floatterm" --gtk-titlebar=false --working-directory="~/Pictures/Wallpapers/Mocha" -e "/bin/fish '-ic cd ~/Pictures/Wallpapers/Mocha && wallpaper (pwd)/(fzf)'"

wallpaper init
