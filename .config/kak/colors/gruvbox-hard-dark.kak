# gruvbox-hard-dark theme

evaluate-commands %sh{
    gray_nor="rgb:7c6f64"
    red_nor="rgb:cc241d"
    green_nor="rgb:98971a"
    yellow_nor="rgb:d79921"
    blue_nor="rgb:458588"
    purple_nor="rgb:b16286"
    aqua_nor="rgb:689d6a"
    orange_nor="rgb:d65d0e"

    gray="rgb:928374"
    red="rgb:fb4934"
    green="rgb:b8bb26"
    yellow="rgb:fabd2f"
    blue="rgb:83a598"
    purple="rgb:d3869b"
    aqua="rgb:8ec07c"
    orange="rgb:fe8019"

    bg="rgb:1d2021"
    bg_alpha="rgba:1d2021a0"
    bg0="rgb:282828"
    bg1="rgb:3c3836"
    bg2="rgb:504945"
    bg3="rgb:665c54"
    bg4="rgb:7c6f64"

    fg="rgb:ebdbb2"
    fg_alpha="rgba:ebdbb2a0"
    fg0="rgb:fbf1c7"
    fg1="rgb:ebdbb2"
    fg2="rgb:d5c4a1"
    fg3="rgb:bdae93"
    fg4="rgb:a89984"

    echo "
        # Code highlighting
        face global value         ${purple}
        face global type          ${yellow}
        face global variable      ${blue}
        face global module        ${green_nor}
        face global function      ${yellow_nor}
        face global string        ${green}
        face global keyword       ${red}
        face global operator      ${blue_nor}
        face global attribute     ${orange}
        face global comment       ${gray}
        face global documentation ${gray_nor}
        face global meta          ${aqua}
        face global builtin       ${orange_nor}
        face global delimiter     ${red_nor}

        # Markdown highlighting
        face global title     ${green}+b
        face global header    ${orange}
        face global mono      ${fg4}
        face global block     ${aqua}
        face global link      ${blue}+u
        face global bullet    ${yellow}
        face global list      ${fg}

        face global Default            ${fg},${bg}
        face global PrimarySelection   ${fg_alpha},${blue_nor}+g
        face global SecondarySelection ${bg_alpha},${blue_nor}+g
        face global PrimaryCursor      ${bg},${fg}+fg
        face global SecondaryCursor    ${bg},${bg4}+fg
        face global PrimaryCursorEol   ${bg},${fg4}+fg
        face global SecondaryCursorEol ${bg},${bg2}+fg
        face global LineNumbers        ${bg4}
        face global LineNumberCursor   ${yellow},${bg1}
        face global LineNumbersWrapped ${bg1}
        face global MenuForeground     ${bg2},${blue}
        face global MenuBackground     ${fg},${bg2}
        face global MenuInfo           ${bg}
        face global Information        ${bg},${fg}
        face global Error              ${bg},${red}
        face global DiagnosticError    ${orange}
        face global DiagnosticWarning  ${yellow}
        face global StatusLine         ${fg},${bg}
        face global StatusLineMode     ${yellow}+b
        face global StatusLineInfo     ${purple}
        face global StatusLineValue    ${red_nor}
        face global StatusCursor       ${bg},${fg}
        face global Prompt             ${yellow}
        face global MatchingChar       ${fg},${bg3}+b
        face global BufferPadding      ${bg2},${bg}
        face global Whitespace         ${bg2}+f
    "
}
