#!/bin/bash

# Parameters
GIT_USER=""
GIT_EMAIL=""

PPAS=(
    nilarimogard/webupd8
    webupd8team/java
    rael-gc/rvm
    ondrej/php
    ansible/ansible
)

PACKAGES=(
    apt-transport-https
    ca-certificates
    curl
    software-properties-common
    htop
    cryptsetup
    oracle-java8-installer
    git
    zsh
    screen
    tmux
    build-essential
    jq
    android-tools-adb
    android-tools-fastboot
    python
    python3
    rvm
    ruby
    golang
    python-software-properties
    php
    nodejs
    npm
    virtualbox
    virtualbox-ext-pack
    virtualbox-guest-additions-iso
    code
    ansible
    vagrant
    packer
    docker
    docker-compose
    docker-machine
)

COMMANDS=(
    'chsh -s /usr/bin/zsh'
)

# Colors
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
bold=$(tput bold)
norm=$(tput sgr0)

function print_info(){
    echo -e "${green}✔${norm} ${bold}$1${norm}..."
}

function print_warn(){
    echo -e "${yellow}!${norm} ${bold}$1${norm}..."
}

function print_err(){
    echo -e "${red}✖${norm} ${bold}$1${norm}..."
}


#
# Main
#

# Add Repository
print_info "Adding repository..."
for ppa in "${PPAS[@]}"
do
    sudo add-apt-repository --yes --update ppa:$ppa
done

# Update System
print_info "Updating system..."
sudo apt clean
sudo apt update
sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt install -y ${PACKAGES[*]}

# VSCode Key & Repository
print_info "Installing vscode key & repository..."
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

## Install dotnet
print_info "Installing microsoft key & repository..."
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys EB3E94ADBE1229CF
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893
sudo echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-bionic-prod bionic main" > /etc/apt/sources.list.d/dotnetdev.list
sudo apt-get update
sudo apt install -y dotnet
#sudo apt install -y liblttng-ust0 libcurl3 libssl1.0.0 libkrb5-3 zlib1g libicu60
#wget https://dot.net/v1/dotnet-install.sh
#./dotnet-install.sh -c Current
#rm -rf dotnet-install.sh
#
## Install clang-format
#sudo apt install clang-format


# Install Android SDK, NDK & Studio
sudo mkdir -p /opt/google
if [ ! -d "/opt/google/android-studio" ]; then
    print_info "Installing Android Studio..."
    wget https://dl.google.com/dl/android/studio/ide-zips/3.2.1.0/android-studio-ide-181.5056338-linux.zip -P /tmp
    sudo unzip /tmp/android-studio-ide-181.5056338-linux.zip -d /opt/google
    #wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -P /tmp
    #sudo unzip /tmp/sdk-tools-linux-4333796.zip -d /opt/google/android-sdk
    #wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip -P /tmp
    #sudo unzip /tmp/platform-tools*-linux.zip -d /opt/google/android-sdk
    #wget https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip -P /tmp
    #sudo unzip /tmp/android-ndk-r18b-linux-x86_64.zip -d /opt/google
    #sudo mv /opt/google/android/android-ndk-* /opt/google/android-ndk
    rm -rf /tmp/android-studio*.zip #sdk-tools-linux*.zip platform-tools*.zip
    print_warn("Now open Android Studio and add SDK and NDK!")
fi

# Install Keybase
print_info "Downloading keybase"
wget https://prerelease.keybase.io/keybase_amd64.deb -O /tmp
print_info "Installing keybase"
sudo dpkg -i /tmp/keybase_amd64.deb
sudo apt-get install -f
rm -rf /tmp/keybase_amd64.deb

# Install Terraform
print_info "Downloading terraform"
#terraform_url=$(curl https://releases.hashicorp.com/index.json | jq '{terraform}' | egrep "linux.*amd64" | sort --version-sort -r | head -1 | awk -F[\"] '{print $4}')
terraform_url="https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')_linux_amd64.zip"
#curl -o terraform.zip $terraform_url
wget $terraform_url -O /tmp
print_info "Installing terraform"
sudo unzip /tmp/terraform*.zip -d /usr/local/bin
rm -rf /tmp/terraform*.zip

# Install Packer
#print_info "Downloading packer"
#packer_url=$(curl https://releases.hashicorp.com/index.json | jq '{packer}' | egrep "linux.*amd64" | sort --version-sort -r | head -1 | awk -F[\"] '{print $4}')
#curl -o packer.zip $packer_url
#print_info "Installing packer"
#sudo unzip packer.zip -d /usr/bin

# Install docker
#print_info "Installing docker"
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
#sudo apt-cache policy docker-ce
#sudo apt install -y docker-ce

# Launch Commands
print_info "Launching some commands shell"
for cmd in "${COMMANDS[@]}"
do
    $cmd
done

# Link Data files
for file in data/*
do
    print_info "Linking $file to ${bold}~/.$(basename $file)${norm}"
    rm -rf ~/.$(basename $file)
    ln -s $(pwd)/$file ~/.$(basename $file)
done

# Create GOPATH
mkdir -p ~/gocode/

# Configure Git
print_info "Setting up git config"
if [ -z $GIT_USER ]; then
    read -p "${yellow}!${norm} ${bold}Insert your git user:${norm} " $GIT_USER
fi
if [ -z $GIT_EMAIL ]; then
    read -p "${yellow}!${norm} ${bold}Insert your git e-mail:${norm} " $GIT_EMAIL
fi
git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"
git config --global core.editor "code -w"
git config --global color.ui true
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto

# Install VSCode Extensions
code -v > /dev/null
if [[ $? -eq 0 ]];then
    print_info "Installing vscode extensions"
    code --install-extension bbenoist.vagrant
    code --install-extension felixfbecker.php-intellisense
    code --install-extension mauve.terraform
    code --install-extension mikael.angular-beastcode
    code --install-extension ms-python.python
    code --install-extension ms-vscode.go
    code --install-extension ms-vscode.cpptools
    code --install-extension ms-vscode.csharp
    code --install-extension ms-vscode.powershell
    code --install-extension peterjausovec.vscode-docker
    code --install-extension rebornix.ruby
    code --install-extension davidanson.vscode-markdownlint
    code --install-extension eg2.tslint
    code --install-extension felixrieseberg.vsc-travis-ci-status
    code --install-extension fatihacet.gitlab-workflow
    code --install-extension robertohuertasm.vscode-icons
    code --install-extension blanu.vscode-styled-jsx
    code --install-extension batisteo.vscode-django
    code --install-extension christian-kohler.npm-intellisense
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension dzannotti.vscode-babel-coloring
    code --install-extension eg2.vscode-npm-script
    code --install-extension t-sauer.autolinting-for-javascript
    code --install-extension timothymclane.react-redux-es6-snippets
    code --install-extension Zignd.html-css-class-completion
    code --install-extension abusaidm.html-snippets
    code --install-extension christian-kohler.path-intellisense
    code --install-extension mohsen1.prettify-json
    code --install-extension mrmlnc.vscode-scss
    code --install-extension cssho.vscode-svgviewer
    code --install-extension whtouche.vscode-js-console-utils
    code --install-extension wix.vscode-import-cost
fi

# Firefox Settings

## Firefox Extensions
#https://addons.mozilla.org/en-US/firefox/addon/hoxx-vpn-proxy/?src=search
#https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/
#
#https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/?src=collection
#https://addons.mozilla.org/en-US/firefox/addon/user-agent-switcher-revived/?src=search
#https://addons.mozilla.org/en-US/firefox/addon/bloody-vikings/?src=collection # generate temporary mail
#
#https://addons.mozilla.org/en-US/firefox/addon/noscript/
#https://addons.mozilla.org/en-US/firefox/addon/https-everywhere/?src=search
#https://addons.mozilla.org/en-US/firefox/addon/adblock-plus/?src=search
#
#https://addons.mozilla.org/en-US/firefox/addon/easyscreenshot/?src=search
#https://addons.mozilla.org/en-US/firefox/addon/video-downloadhelper/?src=search
