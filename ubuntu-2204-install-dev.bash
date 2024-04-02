#!/bin/bash



# Commands to install GitHub CLI, update apt, ensure gh is installed, then
#     install gh extensions like copilot, gh explain & suggest

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install gh
gh extension install github/copilot

# sudo apt remove --purge vim && sudo add-apt-repository ppa:jonathonf/vim && sudo apt update && sudo apt install -y vim
# sudo apt update && sudo apt install -y git && mkdir -p .vim/pack/ && git clone https://github.com/github/copilot.vim.git ~/.vim/pack/github/start/copilot.vim && vim -c 'Copilot setup'
