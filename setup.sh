#!/usr/bin/bash
set -e
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
foot_config()
{
    mkdir -p "$HOME/.config/foot/"
    if sudo cp "$SCRIPT_DIR/foot/foot.ini" "$HOME/.config/foot/foot.ini" &>/dev/null
    then
        echo "复制foot.ini文件成功"
    fi
}
helix_config()
{
    mkdir -p "$HOME/.config/helix/"
    if sudo cp "$SCRIPT_DIR/helix/*" "$HOME/.config/helix/" &>/dev/null
    then
        echo "复制helix配置文件成功"
    fi
}
sway_config()
{
    mkdir -p "$HOME/.config/sway/"
    if sudo cp "/etc/sway/config" "$HOME/.config/sway/config" &>/dev/null
    then
        echo "复制/etc/sway/config文件成功"
        printf "\n" >> "$HOME"/.config/sway/config
        cat "$SCRIPT_DIR/sway/config" >> "$HOME/.config/sway/config"
        echo "追加到$HOME/.config/sway/config成功"
    else
        echo "sway配置失败"
    fi
}
fish_config()
{
    mkdir -p "$HOME/.config/fish/"
    if sudo cp "$SCRIPT_DIR/fish/config.fish" "$HOME/.config/fish/config.fish" &>/dev/null
    then
        echo "复制config.fish文件成功"
    fi
}
git_config()
{
    if command -v "git" &>/dev/null
    then
        git config --global user.name "liuyinwanli"
        git config --global user.email "liuyinwanli@outlook.com"
        git config --global core.editor hx
        git config --global init.defaultBranch main
        ssh -T git@github.com
    fi
}
ssh_config()
{
    mkdir -p "$HOME/.ssh/"
    if sudo cp "$SCRIPT_DIR/ssh/*" "$HOME/.ssh/" &>/dev/null
    then
        echo "$SCRIPT_DIR/ssh/ 已复制到 $HOME/.ssh/"
    fi
}
name_config()
{
    sudo hostnamectl set-hostname fedorax
}
dnf_config()
{
    if sudo cp "$SCRIPT_DIR/dnf/dnf.conf" "/etc/dnf/dnf.conf" &>/dev/null
    then
        echo "$SCRIPT_DIR/dnf/dnf.conf 已复制到 /etc/dnf/dnf.conf"
    fi
}
#换源
change_fedora_repo()
{



    if [ -f "/etc/yum.repos.d/fedora.repo.bak" ]
    then
        echo "/etc/yum.repos.d/fedora.repo.bak 已存在"

    else
        sudo cp /etc/yum.repos.d/fedora.repo /etc/yum.repos.d/fedora.repo.bak && \
        echo "/etc/yum.repos.d/fedora.repo 已备份"
    fi

    if [ -f "/etc/yum.repos.d/fedora-updates.repo.bak" ]
    then
        echo "/etc/yum.repos.d/fedora-updates.repo.bak 已存在"

    else
        sudo cp /etc/yum.repos.d/fedora-updates.repo /etc/yum.repos.d/fedora-updates.repo.bak && \
        echo "/etc/yum.repos.d/fedora-updates.repo 已备份"
    fi

    # sudo sed \
    #     -e 's|^metalink=|# metalink=|g' \
    #     -e 's|^# baseurl|baseurl|g' \
    #     -i \
    #     /etc/yum.repos.d/fedora.repo \
    #     /etc/yum.repos.d/fedora-updates.repo \
    # && sudo dnf makecache

    sudo sed \
        -e 's|^metalink=|# metalink=|g' \
        -e 's|^# baseurl=http://download.example/pub/fedora/linux|baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora|g' \
        -i \
        /etc/yum.repos.d/fedora.repo \
        /etc/yum.repos.d/fedora-updates.repo \
    && sudo dnf makecache




}

#恢愎源
origin_fedora_repo()
{



    if [ -f "/etc/yum.repos.d/fedora.repo.bak" ]
    then
        sudo rm /etc/yum.repos.d/fedora.repo && \
        sudo mv /etc/yum.repos.d/fedora.repo.bak /etc/yum.repos.d/fedora.repo && \
        echo "/etc/yum.repos.d/fedora.repo 已恢愎"

    else
        echo "/etc/yum.repos.d/fedora.repo.bak 不存在"
    fi

    if [ -f "/etc/yum.repos.d/fedora-updates.repo.bak" ]
    then
        sudo rm /etc/yum.repos.d/fedora-updates.repo && \
        sudo mv /etc/yum.repos.d/fedora-updates.repo.bak /etc/yum.repos.d/fedora-updates.repo && \
        echo "/etc/yum.repos.d/fedora-updates.repo 已恢愎"
    else
        echo "/etc/yum.repos.d/fedora-updates.repo.bak 不存在"
    fi


    sudo dnf makecache

}

rpm_fusion_install()
{
    local v
    v=$(rpm -E %fedora)
    echo "fedora version is $v"
    if rpm -q rpmfusion-free-release &>/dev/null && rpm -q rpmfusion-nonfree-release &>/dev/null
    then
        echo "RPM Fusion 已存在"
    else
        sudo yum install --nogpgcheck \
        https://mirrors.tuna.tsinghua.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-"$v".noarch.rpm \
        https://mirrors.tuna.tsinghua.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-"$v".noarch.rpm
        # sudo dnf install \
        # https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$v".noarch.rpm \
        # https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$v".noarch.rpm
    fi
}
fonts_install()
{
    sudo dnf install -y fira-code-fonts cascadia-code-nf-fonts
}
clash_install()
{
    if command -v "clash-verge" &>/dev/null
    then
        echo "clash 已存在"
    else
        sudo dnf copr enable oak443/clash-verge-rev && sudo dnf install -y clash-verge-rev
    fi
}
yazi_install()
{
    if command -v "yazi" &>/dev/null
    then
        echo "yazi 已存在"
    else
        sudo dnf copr enable lihaohong/yazi && sudo dnf install yazi
    fi
}
code_install()
{
    if command -v "code" &>/dev/null
    then
        echo "code 已存在"
    else
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
        echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

        sudo dnf check-update &&
        sudo dnf install code # or code-insiders

    fi
}
rime_install()
{
    if command -v "fcitx5" &>/dev/null
    then
        echo "rime 已存在"
    else
        sudo dnf install fcitx5 fcitx5-configtool  fcitx5-qt  fcitx5-gtk fcitx5-rime librime-lua fcitx5-autostart
        touch ~/.profile  && printf '\nexport GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS="@im=fcitx"'  >>  ~/.profile
        mkdir -p "$HOME/.local/share/fcitx5"
        if [ -d "$HOME/.local/share/fcitx5/rime" ]
        then
            rm -rf "$HOME/.local/share/fcitx5/rime"
        fi
        if cp -r "$SCRIPT_DIR/rime"  "$HOME/.local/share/fcitx5/rime" &>/dev/null
        then
            echo "复制rime文件成功"
        fi

    fi
}
rust_install()
{
    if command -v "cargo" &>/dev/null
    then
        echo "rust 已存在"
    else
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        # source "$HOME/.cargo/env.fish"
        mkdir "$HOME/.cargo/"
        cp "$SCRIPT_DIR/cargo/config.toml" "$HOME/.cargo/config.toml"

    fi
}
chrome_install()
{
    if command -v "google-chrome" &>/dev/null
    then
        echo "chrome 已存在"
    else
        sudo dnf install fedora-workstation-repositories
        sudo dnf config-manager setopt google-chrome.enabled=1
        sudo dnf install google-chrome-stable
    fi
}
docker_install()
{
    if command -v "docker" &>/dev/null
    then
        echo "docker 已存在"
    else
        sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
        sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo systemctl start docker
        sudo docker run hello-world
    fi
}
solana_install()
{
        if command -v "solana" &>/dev/null
    then
        echo "solana 已存在"
    else
        curl -sSfL https://release.anza.xyz/stable/install | bash
    fi
}
uv_install()
{
    if command -v "uv" &>/dev/null
    then
        echo "uv 已存在"
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
        uv venv ~/.XPV
    fi
}
helix_install()
{
    if command -v "hx" &>/dev/null
    then
        echo "helix 已存在"
    else
        sudo dnf install helix
        helix_config
    fi
}
fish_install()
{
    if command -v "fish" &>/dev/null
    then
        echo "fish 已存在"
    else
        sudo dnf install fish
        sudo chsh -s "$(which fish)"
    fi
    fish_config
}
zoxide_install()
{
    if command -v "zoxide" &>/dev/null
    then
        echo "zoxide 已存在"
    else
        sudo dnf install zoxide
    fi
}
echo "===== Fedora 安装后 初如化  超出索引 则返回 ======"
select action in "<切换源>" "<装软件>" "<搞配置>"
do
    echo "==========================>>$action"
    case "$REPLY" in
        1)
            select _ in "换源" "恢愎源" "RPM-FUSION"
            do

                case "$REPLY" in
                    1)
                        change_fedora_repo
                        ;;
                    2)
                        origin_fedora_repo
                        ;;
                    3)
                        rpm_fusion_install
                        ;;
                    *)
                        # echo "===== Fedora 安装后 初如化  超出索引 则返回 ======"
                        echo "========>><切换源> <装软件> <搞配置>"
                        break
                        ;;
                esac
            done
            ;;
        2)
            select _ in "clash" "rime" "zoxide" "code" "helix" "yazi" "rust" "chrome" "docker" "fish" "solana" "fonts" "uv"
            do
                case "$REPLY" in
                    1)
                        clash_install
                        ;;
                    2)
                        rime_install
                        ;;
                    3)
                        zoxide_install
                        ;;
                    4)
                        code_install
                        ;;
                    5)
                        helix_install
                        ;;
                    6)
                        yazi_install
                        ;;
                    7)
                        rust_install
                        ;;
                    8)
                        chrome_install
                        ;;
                    9)
                        docker_install
                        ;;
                    10)
                        fish_install
                        ;;

                    11)
                        solana_install
                        ;;
                    12)
                        fonts_install
                        ;;
                    13)
                        uv_install
                        ;;
                    *)
                        # echo "===== Fedora 安装后 初如化  超出索引 则返回 ======"
                        echo "========>><切换源> <装软件> <搞配置>"
                        break
                        ;;
                esac
            done
            ;;
        3)
            select _ in "sway" "fish" "foot" "helix" "git" "ssh" 
            do
                case "$REPLY" in
                    1)
                        sway_config
                        ;;
                    2)
                        fish_config
                        ;;
                    3)
                        foot_config
                        ;;
                    4)
                        helix_config
                        ;;
                    5)
                        git_config
                        ;;

                    6)
                        ssh_config
                        ;;
                    *)
                        # echo "===== Fedora 安装后 初如化  超出索引 则返回 ======"
                        echo "========>><切换源> <装软件> <搞配置>"
                        break
                        ;;
                esac
            done
            ;;
        *)
            break
            ;;
    esac
done
