#!/usr/bin/env bash

case `uname` in 
    Darwin)
        echo 'MacOS'
        brew install zsh macvim stow tig ctags zsh-completions curl wget
        ;;
    Linux)
        echo 'Make sure we have required packages on our Linux'
        if [ -r /etc/debian_version  ] ; then
            #debian or ubuntu:
            sudo apt-get install git tig vim zsh ctags screen tmux stow curl wget
        fi
        if [ -r /etc/redhat-release ] ; then
            #Redhat or Centos:
            sudo yum install -y git tig vim zsh ctags screen tmux stow curl wget
        fi
        ;;
esac

if [ ! -d ${HOME}/.oh-my-zsh ] ; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

#Add zsh plugins
for plugin in zsh-autosuggestions zsh-syntax-highlighting ; do
    echo "Check and install zsh plugin:" ${plugin}
    if [ ! -d ${HOME}/.oh-my-zsh/custom/plugins/${plugin} ] ; then
        git clone https://github.com/zsh-users/${plugin} ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/${plugin}
    fi
done

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

