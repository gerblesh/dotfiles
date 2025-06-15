function fish_right_prompt
    set -l duration $CMD_DURATION
    make_async_request

    # greater than 10 seconds
    # duration, not the most useful info tbh
    # if test $duration -gt 10000
    #     echo -ns (set_color -od brblack) "$duration" "ms "(set_color normal)
    # end

    if test -e /run/.containerenv
        echo -ns (set_color -od brmagenta) " "(string match -rg 'name="(.*)"'</run/.containerenv)(set_color normal)
    end

    async_print_buffer

    # Reset state, prompt is complete
    if test "$state" -eq "$REPAINTING"
        set state "$INITIAL"
    end
end
