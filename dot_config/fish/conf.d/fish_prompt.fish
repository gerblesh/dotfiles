function fish_mode_prompt
    # set --local vi_mode_color
    set --local vi_mode_symbol
    switch $fish_bind_mode
        case default
            set vi_mode_symbol "N "
        case insert
            set vi_mode_symbol ""
        case replace replace_one
            set vi_mode_symbol "R "
        case visual
            set vi_mode_symbol "V "
    end
    echo -ns (set_color -od brblack) "$vi_mode_symbol" (set_color normal)
end

function fish_prompt
    set -l last_status $pipestatus
    set -l stat

    for status_code in $last_status
        if test "$status_code" != 0
            set stat (set_color -i brred)" $last_status"(set_color normal)
            break
        end
    end

    # Silverblue workaround
    set -l pwd (string replace /var/home /home $PWD)


    echo -ns (set_color -o cyan)(prompt_pwd -D 1 -d 2 $pwd) (set_color normal) "$stat "
end

set -g __fish_git_prompt_showupstream informative
set -g __fish_git_prompt_showdirtystate true
set -g __fish_git_prompt_showstashstate true
set -g __fish_git_prompt_showuntrackedfiles true
set -g __fish_git_prompt_showcolorhints false
set -g __fish_git_prompt_char_upstream_behind " ↓"
set -g __fish_git_prompt_char_upstream_ahead " ↑"
set -g __fish_git_prompt_char_stagedstate " ●"
set -g __fish_git_prompt_char_untrackedfiles "!"

function fish_right_prompt
    if test -e /run/.containerenv
        echo -ns (set_color -od brblack) " "(string match -rg 'name="(.*)"'</run/.containerenv)(set_color normal)
    end
    echo -n (set_color -i magenta) (fish_vcs_prompt) (set_color normal)
end
