#!/usr/bin/env bash

case `uname` in 
    Darwin)
        echo 'MacOS'
        brew install zsh macvim stow tig ctags zsh-completions curl wget
        ;;
    Linux)
        echo 'Make sure we have required packages on our Linux'
        sudo yum install -y git tig vim zsh ctags screen tmux stow curl wget
        ;;
esac

if [ ! -d ${HOME}/.oh-my-zsh ] ; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

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

