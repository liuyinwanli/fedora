if status is-interactive
    # set -x ALL_PROXY socks5://127.0.0.1:7897
    set -gx EDITOR hx
    set -gx VISUAL hx
    source .XPV/bin/activate.fish
    zoxide init fish | source
end

