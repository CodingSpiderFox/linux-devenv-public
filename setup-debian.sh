#!/bin/bash

chmod +x *.sh

apt install ufw
ufw default deny incoming
ufw default allow outgoing
systemctl enable ufw
cp etc/apt/apt.conf.d/44noextrapackages /etc/apt/apt.conf.d/
echo "Disable apt recommends and suggests (/etc/apt/apt.conf.d/44noextrapackages)"

apt install gnome-shell gdm3 tmux sudo tree git gnome-terminal nautilus
/sbin/usermod -aG sudo user (needs complete logout and re-login to be effective)
sudo systemctl enable gdm3

apt install -y gnome-tweaks \
 gnome-disk-utility \
 neofetch unzip unrar software-properties-commin curl wget vim \
 deja-dup gnome-shell-extension-manager nvidia-driver gnome-control-center \
 gnome-backgrounds gnome-bluetooth-sendto gnome-font-viewer gnome-clocks \
 gnome-settings-daemon gnome-software-common gnome-system-monitor gnome-weather \
 xdg-utils chrome-gnome-shell network-manager-gnome network-manager-vpn network-manager \
 fwupd ghostscript gnome-clocks gnome-calculator gnome-calculator gnome-color-manager \
 gnome-keyring-pkcs11 gnome-remote-desktop gnome-initial-setup jq kdiff3 \ 
 ffmpeg vlc nautilus-extension-gnome-terminal p7zip-full power-profiles-daemon \
 systemsettings task-desktop sed zsh \
 ntfs-3g

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install com.brave.Browser org.mozilla.firefox org.libreoffice.Libreoffice

sudo systemctl enable tlp
sudo systemctl start tlp

sed -i 's/main/main contrib non-free/' /etc/apt/sources.list

# Add third-party repositories (Docker and Brave Browser)
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-core.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/brave-browser-release.gpg
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list

# Add Arkenfox user.js for Firefox privacy and security configuration
mkdir -p /etc/firefox/pref
curl -fsSL https://raw.githubusercontent.com/arkenfox/user.js/master/user.js -o /etc/firefox/pref/user.js

# Configure Firefox to use the Arkenfox user.js
echo 'pref("general.config.obscure_value", 0);' >> /etc/firefox/pref/vendor-user.js
echo 'pref("general.config.filename", "user.js");' >> /etc/firefox/pref/vendor-user.js

# Configure system settings (example: swappiness)
echo "vm.swappiness=10" >> /etc/sysctl.conf

apt update
apt upgrade -y

apt install -y tmux \
  keepassxc \
  tree \
  gedit \
  ncdu \
  neofetch \
  htop \
  net-tools \
  build-essential make g++ cmake clang \
  vlc gimp

wget https://releases.hyper.is/download/deb
sudo dpkg -i deb
rm deb

# Install Oh-My-Zsh:
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme for Oh-My-Zsh:
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

chsh -s /usr/bin/zsh

# Virtualbox dependencies
apt install gcc make perl libqt5help5 libqt5sql5 \
 libqt5opengl5 libqt5xml5 flatpak acpid tlp tlp-rdw powertop \
 psmisc linux-headers-amd64
wget https://download.virtualbox.org/virtualbox/7.0.10/virtualbox-7.0_7.0.10-158379~Debian~bookworm_amd64.deb
dpkg -i virtualbox-7.0_7.0.10-158379~Debian~bookworm_amd64.deb
usermod -aG vboxusers user

# Allow touchpad touch
gsettings set org.gnome.desktop.peripherals.touchpad.tap-to-click true

# Set keybindings
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
"$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | \
sed -e "s|]|, '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']|")" && \
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
name 'Open Terminal' && \
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
command 'gnome-terminal' && \
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
binding '<Super>t'