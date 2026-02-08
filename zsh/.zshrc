# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    extract  # 额外推荐：输入 x filename 自动解压任何格式压缩包
    z        # 额外推荐：输入 z dir 快速跳转到历史访问过的目录
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/xciusdusk/opt/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/xciusdusk/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/xciusdusk/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/xciusdusk/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# direnv settings
eval "$(direnv hook bash)"
export DIRENV_LOG_FORMAT=""

# ====================================================
# WSL2 Mirrored Network Proxy Helper (Fixed)
# ====================================================

# 1. 【全局救命配置】No Proxy 白名单
# 无论是否开启代理，这些地址永远直连，绝对不要走代理！
# 这解决了 llm、ollama、以及 pip 在本地连接时的各种 502/Connection Refused 问题
export no_proxy="localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,*.local,googleapis.com.cn"
export NO_PROXY="$no_proxy"  # 同步设置大写变量，兼容性更好

function proxy_on() {
    # 2. 设置代理地址 (你的端口是 7897)
    local PROXY_PORT=7897
    local PROXY_URL="http://127.0.0.1:${PROXY_PORT}"

    # 3. 设置环境变量
    export http_proxy="$PROXY_URL"
    export https_proxy="$PROXY_URL"
    export all_proxy="$PROXY_URL"

    # 同步大写变量 (某些 Linux 工具只认大写)
    export HTTP_PROXY="$PROXY_URL"
    export HTTPS_PROXY="$PROXY_URL"
    export ALL_PROXY="$PROXY_URL"

    # 4. Git 配置
    git config --global http.proxy "$PROXY_URL"
    git config --global https.proxy "$PROXY_URL"

    echo -e "\033[32m[√] Proxy ON\033[0m (Port: $PROXY_PORT | Local Protection Active)"
}

function proxy_off() {
    # 5. 清除代理变量
    unset http_proxy https_proxy all_proxy
    unset HTTP_PROXY HTTPS_PROXY ALL_PROXY

    # 清除 Git 代理
    git config --global --unset http.proxy
    git config --global --unset https.proxy

    # 注意：我们故意 **不** unset no_proxy
    # 即使关闭了外网代理，本地直连保护也必须保留！

    echo -e "\033[31m[x] Proxy is OFF\033[0m"
}

# Connect to antigravity
ag() {
    local DISTRO=$WSL_DISTRO_NAME
    local AG_EXE="/mnt/g/Development_Tools/IDE/Antigravity/bin/antigravity"
    "$AG_EXE" --remote wsl+$DISTRO "$(pwd)"
}

# Connect to VSCode
code() {
    local DISTRO=$WSL_DISTRO_NAME
    local CODE_EXE="/mnt/g/Development_Tools/IDE/Microsoft VS Code/bin/code"
    "$CODE_EXE" --remote wsl+$DISTRO "$(pwd)"
}

# 添加 fd 的链接
export PATH=$HOME/.local/bin:$PATH


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# ==========================================
# FZF Configuration (Zsh Version)
# ==========================================

# 核心：加载 Zsh 专用脚本 (注意后缀是 .zsh)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# 推荐配置 (保持不变)
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/.*"'
export FZF_CTRL_T_OPTS="--preview 'cat {}' --preview-window 'right:60%'"

# ==========================================
# Load Local Secrets/Configs (Not in Git)
# ==========================================
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ==========================================
# # Editor Configuration
# # ==========================================
export EDITOR='vim'
export VISUAL='vim'

# Git 别名 (可选，方便用 vim 处理 git commit)
alias g='git'

# ==========================================
# Direnv Hook (自动加载环境变量)
# ==========================================
eval "$(direnv hook zsh)"

#===========================================
# alias
#===========================================
alias dc='cd'
