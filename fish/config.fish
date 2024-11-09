set -g fish_greeting

if status is-interactive
    starship init fish | source
end

set -Ux fish_user_paths $fish_user_paths /home/sumit/.deno/bin
set -x QT_QPA_PLATFORMTHEME qt5ct
set -x QT_STYLE_OVERRIDE kvantum
set -x JAVA_HOME /usr/lib/jvm/java-17-openjdk


# List Directory
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
alias upgrade="sudo pacman -Syu"
alias zed=zeditor
alias ff='fastfetch'
alias install='sudo pacman -S'
alias uninstall='sudo pacman -Rs'
alias update='sudo pacman -Syu && yay -Syu'
alias yayi='yay -S'
alias yayu='yay -Rs'
alias apks='$HOME/.config/scripts/apkau.sh'
alias ze='zellij'

#Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# For Fish users - add to ~/.config/fish/config.fish
# if test -z "$ZELLIJ"
#     if test "$ZELLIJ_AUTO_ATTACH" = "true"
#         zellij attach -c
#     else
#         zellij
#     end 
#     # Exit if zellij is closed
#     exit
# end

zoxide init --cmd cd fish | source

oh-my-posh init fish --config ~/.config/ohmyposh/catt_latte.omp.json | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
