# 基础设置 {{{1
_zdir=${ZDOTDIR:-$HOME}
HISTSIZE=10000
SAVEHIST=10000

autoload -Uz compinit && compinit

# 选项设置 {{{1
unsetopt beep
# 不需要cd，直接进入目录
setopt autocd
# 自动记住已访问目录栈
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus
# rm * 时不要提示
setopt rm_star_silent
# 允许在交互模式中使用注释
setopt interactive_comments
setopt extendedglob

# 历史记录 {{{2
# 不保存重复的历史记录项
setopt hist_save_no_dups
setopt hist_ignore_dups
# setopt hist_ignore_all_dups
# 在命令前添加空格，不将此命令添加到记录文件中
setopt hist_ignore_space

# 补全与 zstyle {{{1
# 自动补全 {{{2
# 用本用户的所有进程补全
zstyle ':completion:*:processes' command 'ps -afu$USER'
zstyle ':completion:*:*:*:*:processes' force-list always
# 进程名补全
zstyle ':completion:*:processes-names' command  'ps c -u ${USER} -o command | uniq'

# 警告显示为红色
zstyle ':completion:*:warnings' format $'\e[91m -- No Matches Found --\e[0m'
# 描述显示为淡色
zstyle ':completion:*:descriptions' format $'\e[2m -- %d --\e[0m'
zstyle ':completion:*:corrections' format $'\e[93m -- %d (errors: %e) --\e[0m'

# cd 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
# 在 .. 后不要回到当前目录
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# complete manual by their section, from grml
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true

zstyle ':completion:*' menu select
# 分组显示
zstyle ':completion:*' group-name ''
# 歧义字符加粗（使用「true」来加下划线）；会导致原本的高亮失效
# http://www.thregr.org/~wavexx/rnd/20141010-zsh_show_ambiguity/
# zstyle ':completion:*' show-ambiguity '97'
# _extensions 为 *. 补全扩展名
# 在最后尝试使用文件名
if [[ $ZSH_VERSION =~ '^[0-4]\.' || $ZSH_VERSION =~ '^5\.0\.[0-5]' ]]; then
  zstyle ':completion:*' completer _complete _match _approximate _expand_alias _ignored _files
else
  zstyle ':completion:*' completer _complete _extensions _match _approximate _expand_alias _ignored _files
fi
# 修正大小写
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle -e ':completion:*' special-dirs \
  '[[ $PREFIX == (../)#(|.|..) ]] && reply=(..)'
# 使用缓存。某些命令的补全很耗时的（如 aptitude）
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${XDG_CACHE_HOME:-$HOME/.cache}/zsh

# complete user-commands for git-*
# https://pbrisbin.com/posts/deleting_git_tags_with_style/
zstyle ':completion:*:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}/git-/}
zstyle ':completion:*:*:git:*' user-commands subrepo:'perform git-subrepo operations'

# 命令行编辑 {{{1
bindkey -e

# ^Xe 用$EDITOR编辑命令
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Esc-Esc 在当前/上一条命令前插入 sudo {{{2
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    [[ $BUFFER != sudo\ * && $UID -ne 0 ]] && {
      typeset -a bufs
      bufs=(${(z)BUFFER})
      while (( $+aliases[$bufs[1]] )); do
        local expanded=(${(z)aliases[$bufs[1]]})
        bufs[1,1]=($expanded)
        if [[ $bufs[1] == $expanded[1] ]]; then
          break
        fi
      done
      bufs=(sudo $bufs)
      BUFFER=$bufs
    }
    zle end-of-line
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

zle -C complete-file menu-expand-or-complete _generic
zstyle ':completion:complete-file:*' completer _files

# 变量设置 {{{1
[[ -z $EDITOR ]] && (( $+commands[vim] )) && export EDITOR=vim

export PATH="$HOME/.local/bin:$HOME/.local/bin/zig-0.14:$PATH"

# 别名 {{{1
# 命令别名 {{{2
alias ll='ls -lh'
alias la='ls -A'

(( $+commands[exa] )) && {
  xtree () {
    exa -Tl --color=always "$@" | less
  }

  alias ls="exa"
}

(( $+commands[ip] )) && alias ip="ip -c"

if (( $+commands[npm] )); then
  alias npm="bwrap --unshare-all --share-net --die-with-parent \
    --ro-bind /usr /usr --ro-bind /etc /etc --proc /proc --dev /dev --tmpfs /tmp \
    --symlink usr/bin /bin --symlink usr/bin /sbin --symlink usr/lib /lib --symlink usr/lib /lib64 \
    --ro-bind ~/.npmrc ~/.npmrc --bind ~/.cache/npm ~/.cache/npm \
    --bind \$PWD \$PWD \
    npm"
  alias npx="bwrap --unshare-all --share-net --die-with-parent \
    --ro-bind /usr /usr --ro-bind /etc /etc --proc /proc --dev /dev --tmpfs /tmp \
    --symlink usr/bin /bin --symlink usr/bin /sbin --symlink usr/lib /lib --symlink usr/lib /lib64 \
    --ro-bind ~/.npmrc ~/.npmrc --bind ~/.cache/npm ~/.cache/npm \
    --bind \$PWD \$PWD \
    npx"
fi

alias sysuser="systemctl --user"


___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

_plugin=${_zdir}/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
if [[ -f $_plugin ]]; then
  . $_plugin
  FAST_HIGHLIGHT[use_async]=1
fi

eval "$(fzf --zsh)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"

# vim: fdm=marker
