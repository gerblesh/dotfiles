#!/usr/bin/env fish


ghostty --class="com.gar.todo" --background-opacity=1.0 --window-width=100 --window-height=30 --gtk-single-instance=false -e "/bin/fish '-ic hx $HOME/journal/todo.md'"
