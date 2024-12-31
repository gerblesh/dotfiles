#!/bin/fish

function update_git_info
    set pid $argv[1]
    # fix issue?
    if test "$pid" = ""
        exit
    end

    # XXX: global variables takes time to update so we need to wait 1ms
    trap "kill -s SIGUSR1 $pid" EXIT

    async_set_buffer (echo "$(set_color -o magenta)$(fish_vcs_prompt)$(set_color normal)")
end

update_git_info $argv[1]
