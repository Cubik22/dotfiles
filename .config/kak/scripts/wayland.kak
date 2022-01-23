provide-module wayland -override %{

define-command wayland-terminal -params 1.. -shell-completion -docstring '
wayland-terminal <program> [<arguments>]: create a new terminal as a Wayland window
The program passed as argument will be executed in the new terminal' \
%{
    evaluate-commands -save-regs 'a' %{
        set-register a %arg{@}
        evaluate-commands %sh{
            if [ -z "${kak_opt_termcmd}" ]; then
                echo "fail 'termcmd option is not set'"
                exit
            fi
            setsid foot sh -c "$kak_quoted_reg_a" < /dev/null > /dev/null 2>&1 &
        }
    }
}

define-command wayland-focus -params ..1 -client-completion -docstring '
wayland-focus [<kakoune_client>]: focus a given client''s window
If no client is passed, then the current client is used' \
%{
    fail There is no way to focus another window on Wayland
}

alias global focus wayland-focus
alias global terminal wayland-terminal

}
