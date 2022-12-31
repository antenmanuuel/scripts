# !/bin/bash
# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./ubuntu.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
apt update
apt upgrade -y

# Install nala
echo "deb-src https://deb.volian.org/volian/ scar main" | sudo tee -a /etc/apt/sources.list.d/volian-archive-scar-unstable.list
apt update
apt install nala -y

nala fetch

add-apt-repository universe

# Installing dependencies 
nala install git npm tmux vim nodejs htop neofetch xclip ubuntu-restricted-extras gcc default-jdk vlc ruby-full opam gufw gnome-tweak-tool flatpak

# Stop snapd services
 systemctl stop snapd && systemctl disable snapd

# Purge snapd
apt purge -y snapd gnome-software-plugin-snap

# Prevent reinstall
apt-mark hold snap snapd
cat <<EOF | tee /etc/apt/preferences.d/snapd
Package: snapd
Pin: origin *
Pin-Priority: -1
EOF

nala install flatpak
nala install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


cd ~
git clone https://github.com/antenmanuuel/dotfiles.git
cd dotfiles
chmod +x .make.sh
./.make.sh
cd ~

apt install zsh 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

chsh -s $(which zsh)

git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
 git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


gem install colorls

git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list

wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -

nala update && nala install linux-xanmod-x64v3 

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
rm microsoft.gpg

nala  update &&  nala nstall microsoft-edge-stable 

git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer


opam init
eval `opam env`
opam switch create 4.11.1
opam switch set 4.11.1
eval `opam env`
opam install merlin
eval `opam env`
opam install ocaml-lsp-server
