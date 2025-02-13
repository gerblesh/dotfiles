set INITIAL 0
set LOADING 1
set REPAINTING 2
set state "$INITIAL"

## async functions

# Hash function to hash the CWD and cache git results on disk
function hash_pwd
    set hash (pwd | sha1sum | head -c 40)

    echo "$hash"
end

function make_async_request
    if test "$state" -eq "$INITIAL"
        set state "$LOADING"
        "$HOME/.config/fish/conf.d/update_git_status.fish" %self >>/tmp/debug 2>&1 &
    end
end

function __async_prompt_repaint_prompt --on-signal SIGUSR1
    set state "$REPAINTING"
    commandline -f repaint >/dev/null 2>/dev/null
end

function async_set_buffer
    eval "set -U async_prompt_buffer_$(hash_pwd) \"$argv[1]\""
end

function async_print_buffer
    eval "echo -n \$async_prompt_buffer_$(hash_pwd)"
end

function async_clean_old_vars
    for var in (set --names)
        echo "$var" | grep -q async_prompt
        if test "$status" -eq 0
            set --erase "$var" &
        end
    end
end

## end async

set -g __fish_git_prompt_showupstream informative
set -g __fish_git_prompt_showdirtystate true
set -g __fish_git_prompt_showstashstate true
set -g __fish_git_prompt_showuntrackedfiles true
set -g __fish_git_prompt_showcolorhints false
set -g __fish_git_prompt_char_upstream_behind " ↓"
set -g __fish_git_prompt_char_upstream_ahead " ↑"
set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_untrackedfiles "!"
