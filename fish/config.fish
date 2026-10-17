if status is-interactive
    set -gx EDITOR hx
    set -gx VISUAL hx
    source .XPV/bin/activate.fish
    zoxide init fish | source
end

