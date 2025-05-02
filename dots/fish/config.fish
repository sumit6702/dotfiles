set -g fish_greeting ""

alias l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias la="eza -A --icons=auto"
alias mkd="mkdir -p"
alias rmd="rm -r"
alias free="free -m"
alias c='clear'
alias e="exit"
alias f='fastfetch'
alias i='sudo pacman -S'
alias ui='sudo pacman -Rs'
alias upg='sudo pacman -Syu && yay -Syu'
alias yi='yay -S'
alias yu='yay -Rs'
alias ze='zellij'
alias p='cd projects'
alias l='cd learning'
alias stm='systemctl'
alias spc='ssh sumitk@192.168.2.16'
alias serveron='wol -i 192.168.0.187 e0:d5:5e:01:a4:d1'

abbr mkdir 'mkdir -p'

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
fish_add_path /home/sumit/.spicetify

set -gx PNPM_HOME "/home/sumit/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

zoxide init --cmd cd fish | source
#oh-my-posh init fish --config ~/.config/fish/user_fish/omp.json | source
