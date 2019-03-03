#!/bin/bash

# Parameters
PWD=$(pwd)

# Upgrade vscode settings
echo "Upgrading vscode settings.."
if [ -z "~/.config/Code/User/settings.json" ]; then
    cp ~/.config/Code/User/settings.json $PWD/dotfiles/data/vscode/
fi
if [ -z "~/.config/Code/User/keybindings.json" ]; then
    cp ~/.config/Code/User/keybindings.json $PWD/dotfiles/data/vscode/
fi
if [ -d "~/.config/Code/User/snippets/" ]; then
    cp -r ~/.config/Code/User/snippets/* $PWD/dotfiles/data/vscode/
    #mv ~/.config/Code/User/workspaceStorage/ $PWD/dotfiles/data/vscode/
fi

# Upgrade oh-my-zsh
echo "Upgrading oh-my-zsh.."
cd $PWD/data/oh-my-zsh
git pull
cd $PWD

# Ask for publishing to github
read -p "Would you like to push it? [y/N]" choice
if [[ $choice =~ ^[Yy]$ ]]; then
    git commit -am "misc: general refactoring"
    git push # origin master
else
    echo -n "You have chosen not to push anything!"
fi

exit 0
