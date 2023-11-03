#!/bin/bash

# Define variables
NVM_VERSION="0.39.5"

# Define colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Update and upgrade packages, and install useful tools
echo -e "${GREEN}Running initial package upgrades...${NC}"
sudo apt update && sudo apt upgrade -y


# Install all the tools!
echo -e "${GREEN}Installing defined base packages...${NC}"
sudo apt install -y \
htop \
wget \
curl \
vim \ 
git \
openssh-client \
apt-transport-https \
ca-certificates \
gnupg \ 
software-properties-common \
lsb-release \

# Docker Setup
echo -e "${GREEN}Installing Docker repo & Docker Engine...${NC}"

curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" |tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

apt install docker-ce \
docker-ce-cli \ 
containerd.io \
docker-buildx-plugin \
docker-compose-plugin 

# Docker initial check
echo -e "${GREEN}Validating Docker install (active)${NC}"
systemctl is-active docker


# Install vim syntax highlighting and autocomplete
echo -e "${GREEN}Boosting VIM editor...${NC}"
git clone https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/pack/github/start/ctrlp.vim
git clone https://github.com/vim-airline/vim-airline.git ~/.vim/pack/dist/start/vim-airline
git clone https://github.com/scrooloose/nerdtree.git ~/.vim/pack/dist/start/nerdtree
git clone https://github.com/tpope/vim-fugitive.git ~/.vim/pack/github/start/vim-fugitive

# Install Node.js LTS version via NVM
echo -e "${GREEN}Installing NVM...${NC}"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash

# Load NVM
source ~/.bashrc

echo -e "${GREEN}Installing Node.js (LTS)${NC}"
nvm install --lts

# Install Yarn
echo -e "${GREEN}Installing Yarn package manager (global)${NC}"
npm install -g yarn

# Prompt user for SSH key passphrase
echo -e "${CYAN}Enter passphrase for GitLab SSH key:${NC}"
read -s SSH_KEY_PASSPHRASE

# Generate SSH key pair with passphrase and comment
ssh-keygen -t ed25519 -f ~/.ssh/id_gitlab_ed25519 -N "$SSH_KEY_PASSPHRASE" -C "GitLab SSH Key"

# Create SSH config for GitLab.com
echo -e "Host gitlab.com
  HostName gitlab.com
  IdentityFile ~/.ssh/id_gitlab_ed25519" > ~/.ssh/config

# Set appropriate permissions for SSH files
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_gitlab_ed25519
chmod 644 ~/.ssh/id_gitlab_ed25519.pub
chmod 644 ~/.ssh/config

# Print message for user
echo -e "${GREEN}Setup finished. Happy developing!${NC}"
