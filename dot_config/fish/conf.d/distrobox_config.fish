if test -e /etc/fish/conf.d/distrobox_config.fish
    echo "Loading distrobox fish config"
    source /etc/fish/conf.d/distrobox_config.fish
    echo "Overwriting prompt by user's choice"
    source $XDG_CONFIG_HOME/fish/conf.d/fish_prompt.fish
end
