# Add Homebrew binaries to PATH
$env.PATH = ($env.PATH | prepend "/home/linuxbrew/.linuxbrew/bin" | prepend "/home/linuxbrew/.linuxbrew/sbin")

# Ensure MANPATH exists before modifying it
if not ($env | get -i MANPATH | default null | is-empty) {
    $env.MANPATH = ($env.MANPATH | prepend "/home/linuxbrew/.linuxbrew/share/man")
} else {
    $env.MANPATH = "/home/linuxbrew/.linuxbrew/share/man"
}

# Ensure INFOPATH exists before modifying it
if not ($env | get -i INFOPATH | default null | is-empty) {
    $env.INFOPATH = ($env.INFOPATH | prepend "/home/linuxbrew/.linuxbrew/share/info")
} else {
    $env.INFOPATH = "/home/linuxbrew/.linuxbrew/share/info"
}
