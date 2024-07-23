if status is-interactive
    # Commands to run in interactive sessions can go here
end


function fish_prompt
    echo -n (whoami)
    set_color $fish_color_cwd
    echo -n "@ "(pwd)
    echo -n " > "
    set_color normal
    
end

set -g fish_greeting


# Aliases
alias ls "ls -G"
alias ll "ls -l"
alias la "ls -a"
alias lla "ls -la"
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."
alias ...... "cd ../../../../.."
alias ....... "cd ../../../../../.."
alias ........ "cd ../../../../../../.."
alias ......... "cd ../../../../../../../.."
alias .......... "cd ../../../../../../../../.."
alias ........... "cd ../../../../../../../../../.."