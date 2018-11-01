#!/bin/bash

cd "$(brew --repo)"
git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git

#uncomment below to revert:
#cd "$(brew --repo)"
#git remote set-url origin https://github.com/Homebrew/brew.git
#cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
#git remote set-url origin https://github.com/Homebrew/homebrew-core.git

