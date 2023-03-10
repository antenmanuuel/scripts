# !/bin/bash
# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./fedora.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

dnf update

# sudo nano /etc/dnf/dnf.conf
# max_parallel_downloads=10
# fastestmirror=true
# deltarpm=true

dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

dnf install vlc -y
dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
dnf install lame\* --exclude=lame-devel -y
dnf group upgrade --with-optional Multimedia -y
dnf install gnome-tweaks gnome-extensions-app -y

dnf install curl cabextract xorg-x11-font-utils fontconfig -y
rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

dnf install git tmux vim nodejs npm htop neofetch xclip gcc java-11-openjdk ruby-full gufw  xournalpp -y

cd ~
git clone https://github.com/antenmanuuel/dotfiles.git
cd dotfiles
chmod +x .make.sh
./.make.sh
cd ~

# dnf install zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# chsh -s $(which zsh)

# git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
# git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

gem install colorls

git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer

 dnf update
 dnf upgrade
# dnf install opam
# opam init
# eval `opam env`
# opam switch create 4.11.1
# opam switch set 4.11.1
#  eval `opam env`
# opam install merlin
# eval `opam env`
# opam install ocaml-lsp-server


grep -E --color '(vmx|svm)' /proc/cpuinfo
lsmod | grep -i kvm
dnf group install --with-optional virtualization
systemctl start libvirtd
systemctl enable libvirtd


dnf copr enable rmnscnce/kernel-xanmod -y
dnf install kernel-xanmod-edge kernel-xanmod-edge-headers

