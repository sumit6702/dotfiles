def fuck [] {
    let cmd = (history | last | get command)
    let suggestion = (thefuck $cmd | str trim)

    if ($suggestion != "") {
        print $"Fixing command: ($suggestion)"
        nu -c $suggestion
    } else {
        print "No suggestions"
    }
}
