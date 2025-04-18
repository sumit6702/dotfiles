alias c = clear
alias e = exit
alias ll = ls -l
alias la = ls -a

alias p = cd projects
alias spc = ssh sumitk@192.168.2.16
alias sshon = wol -i 192.168.0.187 e0:d5:5e:01:a4:d1

alias ys = yay -S
alias yr = yay -Rns
alias in = sudo pacman -S
alias ui = sudo pacman -Rns

alias ff = fastfetch
alias py = python
alias dot = bash ~/skdot/install.sh

# PATH VARIABELS
$env.JAVA_HOME = "/usr/lib/jvm/java-21-openjdk"
$env.PATH = ($env.PATH | append $"($env.HOME)/.local/bin")
$env.BUN_INSTALL = $"($env.HOME)/.bun"
$env.PATH = ($env.PATH | prepend $"($env.BUN_INSTALL)/bin")

#YAZI "Y" COMMAND
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

#/home/linuxbrew/.linuxbrew/bin/brew shellenv | save -f ~/.config/nushell/brew.nu
source ~/.config/nushell/brew.nu

#zoxide init nushell | save -f ~/.config/nushell/zoxide.nu
source ~/.config/nushell/zoxide.nu

#oh-my-posh init nu --config ~/.config/ohmyposh/omp_wallbash.json | save -f ~/.config/nushell/oh-my-posh.nu
source ~/.config/nushell/oh-my-posh.nu

#thefuck --alias | save -f ~/.config/nushell/thefuck.nu
source ~/.config/nushell/thefuck.nu
