if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source

    # Funky option key overrides to avoid the jump-word/jump-tab collision with zellij
    bind \e\[1\;3D backward-word
    bind \e\[1\;3C forward-word
end

abbr -a -- vim nvim
abbr -a -- ls eza
abbr -a -- cat bat
abbr -a -- cd z
abbr -a -- grep rg
alias ll='eza -lbG --git'

# Abbreviations for nextest
alias ct='cargo nextest run'
alias ctp='cargo nextest run -p'
alias ctdd='cargo nextest run --no-fail-fast --no-capture -p tpuf-engine --test=datadriven_tests'
alias k=kubectl
