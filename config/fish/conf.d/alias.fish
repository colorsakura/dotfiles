# ls
if type -q eza
    alias ls eza
    alias la "ls -A"
    alias ll "la -l"
end

if type -q nvim
    alias vim nvim
end

# -------------------------------------------------------------------------
# git
# -------------------------------------------------------------------------

alias g="git"
alias ga="git add -A"
alias gac="git add -A; git commit"
alias gaf="git add -f"
alias gap="git add -p"
alias gb="git branch"
alias gba="git branch --all"
alias gbd="git branch --delete --force"
alias gbm="git branch --move"
alias gbu="git branch --unset-upstream"
alias gc="git commit"
alias gcb="git checkout -b"
alias gd="git diff"
alias gdw="git diff --word-diff"
alias gdc="git diff --cached"
alias gdcw="git diff --cached --word-diff"
alias gcd "cd (git rev-parse --show-toplevel)"
alias gclc="git clean -fd :/"
alias gcn="git commit --no-verify"
alias gco="git checkout"
alias gcoh="git checkout --ours ."
alias gcom="git checkout --theirs ."
alias gcp="git cherry-pick"
alias gf="git add -A; git commit -m 'fixup: quick update, squash later'"
alias gk="gitk"
alias gfn="git add -A; git commit --no-verify -m 'fixup: quick update, squash later'"
alias gt="git add -A; git commit -m 'fixup: TEST COMMIT THAT WILL DELETED'"
alias gl="git log --graph --full-history --pretty --oneline"
alias gl1="git log --oneline"
alias gla="gl --all"
alias glp="git log -p"
alias glpd="git log -p --word-diff"
alias gpa="git push --all"
alias gp="git push --quiet"
alias gpl="git pull --rebase"
alias gpf='git push --force-with-lease --quiet'
alias gpt="git push --tags"
alias gr="git remote"
alias grec="git rebase --continue || git revert --continue"
alias groot="git rebase --root -i"
alias gs="git status"
alias gsh="git show"
alias gshw="git show --word-diff"

alias lg="lazygit"

alias t="tmux"

alias sudo="sudo-rs"