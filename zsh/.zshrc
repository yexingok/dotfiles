# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# If not Centos, we use power10k, if centos we use robbyrussell

if [ ! -f /etc/redhat-release ] ; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
else
    # Centos
    ZSH_THEME="robbyrussell"
fi

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
#

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    # z+ 快速跳转
    z
    # Search code very fast with The Silver Searcher ag: https://github.com/ggreer/the_silver_searcher#installing 
    ag
    aws 
    # git 补全
    git 
    # 忘记加sudo的时候按2下esc
    sudo
    # 按x解压任意类型的压缩包
    extract 
    python 
    rsync 
    # Prevent any code from actually running while pasting, so you can review
    safe-paste
    # Add enhancement for Tmux
    tmux
    # vi操作模式
    vi-mode 
    # 彩色man手册
    colored-man-pages 
    zsh-autosuggestions 
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
# Define default locale as en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

case `uname` in 
    Darwin)
        alias vim='mvim -v'
        alias gvim='mvim'

        # Customize:
        # Tell ls to be colourful
        export CLICOLOR=1
        export LSCOLORS=Exfxcxdxbxegedabagacad

        # Tell grep to highlight matches
        export GREP_OPTIONS='--color=auto'

        # Use UTSC Homebrew bottles
        export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
        ;;
    Linux)
        export GPG_TTY=$(tty)
        if [ "$TERM" = "screen"  ] ; then
            export TERM=xterm-256color
        fi
        ;;
    *Microsoft*)
        unsetopt BG_NICE 
        ;;
esac

alias ssh='ssh -A'

alias awsyx='aws --profile yx'
alias awscn='aws --profile cn'
alias awsjp='aws --profile jp '
alias awssgp='aws --profile sgp'

if [ -d ~/.local/bin ] ; then
    export PATH=${PATH}:~/.local/bin/
fi

# For loading SSH key and Proxy within WSL, add more ssh keys to end if needed
/usr/bin/keychain -q --nogui $HOME/.ssh/id_rsa 
source $HOME/.keychain/$HOST-sh

if [ $(uname -r | grep "WSL") ] ; then
    # Handle gpg sign in WSL2 - cache pass for a while 
    # cache time edit in ~/.gnupg/gpg-agent.conf
    gpg-checkttl() {
        local CONF=~/.gnupg/gpg-agent.conf
        if [ -f $CONF ] ; then
            if [ $(grep -q "default-cache-ttl 3600" $CONF) ] ; then
                echo "default-cache-ttl 3600" >> $CONF
                echo "max-cache-ttl 3600" >> $CONF
            fi
        else
            mkdir -p ~/.gnupg
            echo "default-cache-ttl 3600" > $CONF
            echo "max-cache-ttl 3600" >> $CONF
        fi
    }
    gpg-login() {
        export GPG_TTY=$TTY
        # 对 "test" 这个字符串进行 gpg 签名，这时候需要输密码。
        # 然后密码就会被缓存，下次就不用输密码了。
        # 重定向输出到 null，就不会显示到终端中。
        echo "test" | gpg --clearsign > /dev/null 2>&1
        echo "Login"
    }
    gpg-logout() {
        echo RELOADAGENT | gpg-connect-agent
    }

    # Handle use local proxy for WSL2
    # Read more for WSL2 network: https://docs.microsoft.com/en-us/windows/wsl/networking 
    setproxy() {
        local host_ip=$(cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ")
        export ALL_PROXY="socks5://${host_ip}:1081"
        export all_proxy="socks5://${host_ip}:1081"
        #echo -e "Acquire::socks::Proxy \"socks5://${host_ip}:1081\";" | sudo tee -a /etc/apt/apt.conf > /dev/null
        curl ip.sb
    }
    unsetproxy() {
        unset ALL_PROXY
        unset all_proxy
        #sudo sed -i -e '/Acquire::socks::Proxy/d' /etc/apt/apt.conf
        curl ip.sb
    }
    # If win10 blocks all network from WSL2, add a network profile WSL below to enable the vEthernet (WSL) (ie: above proxy settings no response)
    # PS C:\WINDOWS\system32> $myIp = (ubuntu2204 run "cat /etc/resolv.conf | grep nameserver | cut -d' ' -f2")
    #PS C:\WINDOWS\system32> $myIp
    # 172.19.112.1
    # PS C:\WINDOWS\system32> New-NetFirewallRule -DisplayName "WSL" -Direction Inbound  -InterfaceAlias "vEthernet (WSL)"  -Action Allow 
    # If need to access port on win10 local, ie: 127.0.0.1:1081, can add a port forwarding without edit firewall settings(like below), or enable port from win10 firewall public profile
    # PS C:\WINDOWS\system32> netsh interface portproxy add v4tov4 listenport=1081 listenaddress=$myIp connectport=1081 connectaddress=127.0.0.1

else
    # Enable proxy for other platform
    alias setproxy="export ALL_PROXY=socks5://127.0.0.1:1081"
    alias unsetproxy="unset ALL_PROXY"
fi

if [ -d ~/.local/bin ] ; then
    export PATH=${PATH}:~/.local/bin/
fi

# Load NVM
# Install refer https://github.com/nvm-sh/nvm#installing-and-updating 
if [ -d ~/.nvm ] ; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
