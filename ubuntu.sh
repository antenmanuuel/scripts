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
apt update
apt install nala -y

nala fetch

add-apt-repository universe



# Installing dependencies 
nala install git npm tmux vim nodejs htop neofetch xclip ubuntu-restricted-extras gcc default-jdk vlc ruby-full gufw gnome-tweak-tool  -y

# Removing Snap
snap remove --purge firefox
snap remove --purge thunderbird
snap remove --purge snap-store
snap remove --purge gnome-3-38-2004
snap remove --purge gtk-common-themes
snap remove --purge snapd-desktop-integration
snap remove --purge bare
snap remove --purge core20
snap remove --purge powershell
snap remove --purge core18
snap remove --purge snapd
nala remove -snapd -y

cat <<EOF | tee /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
nala update

apt install --install-suggests gnome-software
add-apt-repository ppa:mozillateam/ppa
apt install -t 'o=LP-PPA-mozillateam' firfox

echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

cat <<EOF | tee /etc/apt/preferences.d/mozillateamppa
Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 501
EOF
nala update


nala install flatpak
nala install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


cd ~
git clone https://github.com/antenmanuuel/dotfiles.git
cd dotfiles
chmod +x .make.sh
./.make.sh
cd ~

nala install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

chsh -s $(which zsh)

git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
 git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


gem install colorls

git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions


git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer

nala update
nala upgrade
nala install opam -y
opam init
eval `opam env`
opam switch create 4.11.1
opam switch set 4.11.1
eval `opam env`
opam install merlin
eval `opam env`
opam install ocaml-lsp-server

egrep -c '(vmx|svm)' /proc/cpuinfo

nala install qemu-kvm qemu-system qemu-utils python3 python3-pip libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
systemctl status libvirtd.service
virsh net-start default
virsh net-autostart default
virsh net-list --all

usermod -aG libvirt $USER
usermod -aG libvirt-qemu $USER
usermod -aG kvm $USER
usermod -aG input $USER
usermod -aG disk $USER

nala install qemu bash coreutils ovmf grep jq lsb procps python3 genisoimage usbutils util-linux sed spice-client-gtk swtpm wget xdg-user-dirs zsync unzip -y
apt-add-repository ppa:flexiondotorg/quickemu
nala update
nala install quickemu -y
