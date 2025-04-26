if ! [ -t 1 ]; then
    return
fi

alias v=nyaahvim
alias nvim=nyaahvim
alias bat=batcat # Consider fixing this, with update-alternatives
alias gh="goto $HDD"
alias ghh="goto $HDD/Hoarding"
alias gp='goto ~/Pictures'
alias gw='goto ~/Pictures/Wallpaper\ Poop'
alias gs='goto ~/.local/bin'
alias gc='goto ~/.config' # Consider removal; replace with fzf-powered search mechanism
alias gd='goto ~/Downloads'
alias gm='goto ~/Pictures/Poop'
alias gM='goto ~/Videos/Poopoo'
alias gn='goto ~/Documents/Notes'
alias gN='goto ~/Nix'

alias tt='tmux-run run'
alias te='tmux-run edit'

alias rm=rmtrash' -I'
alias rmdir=rmdirtrash

# return of 1 indicates updates are needed. 0 indicates all is good.
sync() {
    sudo echo Syncing Debian repositories...

    (sudo apt update) | while true; do
        local line
        if ! read -r line; then
            if [ "$prev_line" = 'All packages are up to date.' ]; then
                return 0
            else 
                return 1
            fi
        fi

        printf '%s\n' "$line"
        prev_line="$line"
    done
}

ud() {
    sync || sudo apt upgrade
    flatpak update --user
}

fastfetch

