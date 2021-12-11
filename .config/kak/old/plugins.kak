# bootstrap the plugin manager

evaluate-commands %sh{
    plugins="$kak_config/plugins"
    mkdir -p "$plugins"
    [ ! -e "$plugins/plug.kak" ] && \
        git clone -q https://github.com/andreyorst/plug.kak.git "$plugins/plug.kak"
    printf "%s\n" "source '$plugins/plug.kak/rc/plug.kak'"
}

set-option global plug_profile false
# set to number of plugins
set-option global plug_max_active_downloads 7
set-option global plug_always_ensure false
set-option global plug_block_ui false
set-option global plug_report_conf_errors true

# plugin configurations

plug-chain "https://github.com/andreyorst/plug.kak" noload \
plug "https://github.com/Delapouite/kakoune-palette" \
plug "https://github.com/kkga/foot.kak" \
plug "https://github.com/eraserhd/kak-ansi" \
plug "https://gitlab.com/Screwtapello/kakoune-state-save" config %{
    hook global KakBegin .* %{
        state-save-reg-load colon
        state-save-reg-load pipe
        state-save-reg-load slash
    }
    hook global KakEnd .* %{
        state-save-reg-save colon
        state-save-reg-save pipe
        state-save-reg-save slash
    }
} plug "https://github.com/alexherbo2/tiny.kak" config %{
    # integration
    synchronize-terminal-clipboard
    make-directory-on-save

    # remove error scratch message
    # remove-scratch-message
} plug "https://github.com/alexherbo2/auto-pairs.kak" config %{
    # auto-pairing of characters without quotes
    set-option global auto_pairs ( ) { } [ ]
    enable-auto-pairs
}

