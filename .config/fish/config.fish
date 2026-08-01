if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source

    # Ghostty sends Option+arrows as modified arrow sequences so Zellij can
    # distinguish them from its Alt-b/Alt-f shortcuts.
    bind \e\[1\;3D backward-word
    bind \e\[1\;3C forward-word
end

abbr -a -- vim nvim
abbr -a -- ls eza
abbr -a -- cat bat
abbr -a -- cd z
abbr -a -- grep rg
abbr -a -- top btm
abbr -a -- du dust
alias ll='eza -lbG --git'

# Additional jj abbreviations adapted from Oliver Nguyen's workflow.
# Fisher's kapsmudit/plugin-jj provides the rest of the `j*` abbreviations.
abbr -a -- jab 'jj absorb'
abbr -a -- 'jn+' 'jj new -A @'
abbr -a -- jn- 'jj new -B @'
abbr -a -- jrs 'jj restore'
abbr -a -- js 'jj status'
abbr -a -- jss 'jj show @ --summary'
abbr -a -- jjs 'jj show @ --summary'
abbr -a -- 'j+' 'jj next'
abbr -a -- 'j++' 'jj next 2'
abbr -a -- 'j+++' 'jj next 3'
abbr -a -- 'j++++' 'jj next 4'
abbr -a -- 'j+2' 'jj next 2'
abbr -a -- 'j+3' 'jj next 3'
abbr -a -- 'j+4' 'jj next 4'
abbr -a -- 'j+5' 'jj next 5'
abbr -a -- 'j+6' 'jj next 6'
abbr -a -- j- 'jj prev'
abbr -a -- j-- 'jj prev 2'
abbr -a -- j--- 'jj prev 3'
abbr -a -- j---- 'jj prev 4'
abbr -a -- j-2 'jj prev 2'
abbr -a -- j-3 'jj prev 3'
abbr -a -- j-4 'jj prev 4'
abbr -a -- j-5 'jj prev 5'
abbr -a -- j-6 'jj prev 6'

# Abbreviations for nextest
alias ct='cargo nextest run'
alias ctp='cargo nextest run -p'
alias ctdd='cargo nextest run --no-fail-fast --no-capture -p tpuf-engine --test=datadriven_tests'
alias k=kubectl

set -gx KUBE_EDITOR nvim
set -gx K9S_CONFIG_DIR "$HOME/.config/k9s"
set -gx FX_THEME 2
