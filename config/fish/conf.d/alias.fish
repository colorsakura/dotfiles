# ---------------------------------------------------
# File Navigation and Listing
# ---------------------------------------------------
# Use eza if available, otherwise fallback to ls
if type -q eza
    alias ls "eza --color=auto --group-directories-first"
    alias la "eza -a --color=auto --group-directories-first"  # Show hidden files
    alias ll "eza -al --color=auto --group-directories-first"  # Long format
    alias lt "eza -T --color=auto --group-directories-first"   # Tree format
    alias lta "eza -Ta --color=auto --group-directories-first" # Tree with hidden files
else
    # Standard ls aliases if eza is not available
    alias ls "ls --color=auto --group-directories-first"
    alias la "ls -A --color=auto --group-directories-first"  # Show hidden files
    alias ll "ls -al --color=auto --group-directories-first"  # Long format
end

# ---------------------------------------------------
# Editor Aliases
# ---------------------------------------------------
# Set vim alias to nvim if available
if type -q nvim
    alias vim nvim
    alias v nvim
else if type -q vim
    alias v vim
end

# ---------------------------------------------------
# Git Shortcuts
# ---------------------------------------------------
alias g="git"
alias ga="git add"
alias gaa="git add --all"
alias gap="git add --patch"
alias gau="git add --update"  # Add only modified files
alias gb="git branch"
alias gbc="git checkout -b"   # Create and switch to new branch
alias gbl="git blame -b -w"   # Blame ignoring whitespace
alias gbnm="git branch --no-merged"  # List non-merged branches
alias gbr="git branch --remote"
alias gbs="git show-branch"
alias gc="git commit"
alias gca="git commit --amend"
alias gcam="git commit --all --message"
alias gcm="git commit --message"
alias gco="git checkout"
alias gcor="git checkout --recurse-submodules"
alias gcount="git shortlog --summary --numbered"  # Count commits per author
alias gcp="git cherry-pick"
alias gcpf="git push --force-with-lease --force-if-includes"
alias gcs="git commit -S"  # Commit with signature
alias gd="git diff"
alias gds="git diff --staged"
alias gdt="git difftool"
alias gf="git fetch"
alias gfa="git fetch --all --prune --jobs=10"
alias gfg="git ls-files | grep"  # Find file in git repo
alias gg="git gui citool"
alias gga="git gui citool --amend"
alias ggpull="git pull origin (git branch --show-current)"  # Pull from current branch
alias ggpur="git pull --rebase --prune"
alias ggpush="git push origin (git branch --show-current)"  # Push to current branch
alias ggsup="git branch --set-upstream-to=origin/(git branch --show-current)"
alias ghh="git help"
alias gignore="git update-index --assume-unchanged"  # Ignore file changes
alias gignored="git ls-files -v | grep ^[a-z]"  # List ignored files
alias gl="git log --topo-order --pretty=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset){%an}%C(reset)%n%C(white)%s%C(reset)'"
alias gla="git log --all"
alias glb="git log --oneline --decorate --graph"
alias glc="git log --oneline --graph --decorate --all"
alias gm="git merge"
alias gma="git merge --abort"
alias gmc="git merge --continue"
alias gmt="git mergetool"
alias gp="git push"
alias gpd="git push --dry-run"
alias gpf="git push --force-with-lease"
alias gpl="git pull"
alias gpr="git pull --rebase"
alias gpristine="git reset --hard && git clean --force -dfx"  # Reset everything
alias gpu="git push upstream"
alias gpv="git push --verbose"
alias gr="git remote"
alias gra="git remote add"
alias grb="git rebase"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"
alias grbi="git rebase --interactive"
alias grbm="git rebase master"
alias grbs="git rebase --skip"
alias grh="git reset"
alias grhh="git reset --hard"
alias grmv="git remote rename"
alias grrm="git remote remove"
alias grset="git remote set-url"
alias grt="cd (git rev-parse --show-toplevel)"  # Go to repo root
alias grup="git remote update"
alias grv="git remote --verbose"
alias gsb="git status --short --branch"  # Status with branch info
alias gsd="git svn dcommit"
alias gsi="git submodule init"
alias gsps="git show --pretty=short --show-signature"
alias gsr="git svn rebase"
alias gss="git status --short"
alias gst="git status"
alias gsta="git stash push"
alias gstaa="git stash apply"
alias gstc="git stash clear"
alias gstd="git stash drop"
alias gstl="git stash list"
alias gstp="git stash pop"
alias gsts="git stash show --text"
alias gsu="git submodule update"
alias gsw="git switch"
alias gswc="git switch --create"  # Create and switch to new branch
alias gswd="git switch --detach"  # Switch to detached HEAD
alias gtl="gt log --oneline --graph --date=relative --all"  # Requires 'gt' tool
alias gts="git tag --sort=version:refname"
alias gtv="git tag | sort -V"
alias gunignore="git update-index --no-assume-unchanged"  # Unignore file changes
alias gwch="git whatchanged --oneline --graph --color"
alias gwt="git worktree"
alias gwta="git worktree add"
alias gwtls="git worktree list"
alias gwtm="git worktree move"
alias gwtr="git worktree remove"
alias gwts="git worktree list"

# Convenience git aliases
alias gcd "git rev-parse --show-toplevel; and cd (git rev-parse --show-toplevel)"  # Go to repo root and print path
alias gcl="git clone"
alias gclean="git clean -fd"
alias ggf="git push --force-with-lease origin (git branch --show-current)"
alias ggrbb="git for-each-ref --format='%(authorname) %(color:red)%(objectname:short)%(color:reset) %(color:white)%(refname:short)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset))' refs/remotes/origin"
alias gignore="git update-index --assume-unchanged"
alias gk="gitk --all &"
alias gke="gitk --explain-output --all &"
alias gl1="git log --oneline"
alias glnext="git log --oneline --next-following (set -q @; or set @ master)"
alias glp="git log --pretty"
alias gpnp="git pull origin (git branch --show-current) && git push origin (git branch --show-current)"  # Pull and push current branch
alias gpu="git push upstream"
alias gpoat="git push origin --all && git push origin --tags"  # Push all and tags
alias gmtl="git mergetool --no-prompt"
alias gmtlvim="git mergetool --no-prompt --tool=vimdiff"

# Lazygit alias
alias lg="lazygit"

# ---------------------------------------------------
# Terminal Multiplexer
# ---------------------------------------------------
alias t="tmux"
alias ta="tmux attach -t"
alias tad="tmux attach -d -t"  # Attach and detach others
alias tns="tmux new-session -s"  # Create named session
alias tls="tmux list-sessions"  # List sessions
alias tksv="tmux kill-server"  # Kill tmux server
alias tkss="tmux kill-session -t"  # Kill named session