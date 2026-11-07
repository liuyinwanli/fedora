if status is-interactive
    set -gx EDITOR hx
    set -gx VISUAL hx
    source .XPV/bin/activate.fish
    zoxide init fish | source
    
    
    url=http://127.0.0.1:7897
    surl=socks5://127.0.0.1:7897
    abbr poff unset http_proxy;unset all_proxy;unset https_proxy
    abbr pon export http_proxy=$url; export https_proxy=$url ;export all_proxy=$surl
end
function fish_greeting                                            
    # do nothing
    # 用于,取消,fish_greeting
end 

