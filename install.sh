#!/usr/bin/env bash

case `uname` in 
    Darwin)
        echo 'MacOS'
        brew install zsh macvim stow tig zsh-completions curl wget
        ;;
    Linux)
        echo 'Make sure we have required packages on our Linux'
        if [ -r /etc/debian_version  ] ; then
            #debian or ubuntu:
            sudo apt-get install git tig vim zsh screen tmux stow curl wget unzip keychain
        fi
        if [ -r /etc/redhat-release ] ; then
            #Redhat or Centos:
            sudo yum install -y git tig vim zsh screen tmux stow curl wget unzip
        fi
        ;;
esac

if [ ! -d ${HOME}/.oh-my-zsh ] ; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

#Add zsh plugins
for plugin in zsh-autosuggestions zsh-syntax-highlighting ; do
    echo "Check and install zsh plugin:" ${plugin}
    if [ ! -d ${HOME}/.oh-my-zsh/custom/plugins/${plugin} ] ; then
        git clone https://github.com/zsh-users/${plugin} ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/${plugin}
    fi
done

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

# git clone --depth=1 https://github.com/powerline/fonts.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/fonts/
# follow doc to config fonts: https://github.com/romkatv/powerlevel10k/blob/master/README.md#meslo-nerd-font-patched-for-powerlevel10k 

echo "Check and install vim Vundle"
if [ ! -d ${HOME}/.vim/bundle/Vundle.vim ] ; then
    git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
fi

for d in `ls -d */`;
do 
	( stow $d )
done

echo ""
echo "Done! open vim and run plugin install:"
echo ":PluginInstall"

