#!/usr/bin/env bash

# define some putput colors
yellow='\e[0;33m'
bright_yellow='\e[1;33m'
red='\e[0;31m'
bright_red='\e[1;31m'
green='\e[0;32m'
bright_green='\e[1;32m'
white='\e[1;37m'

# grab some values from the system
swappiness=$(cat /proc/sys/vm/swappiness)
resume_string=$(cat /etc/initramfs-tools/conf.d/resume)
kernel=$(uname -m)
user=$USER
export user

# define some functions

# a general ask-a-question-function
function ask {
    while true; do
 
        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi
 
        # Ask the question
        read -p "$1 [$prompt] " REPLY
 
        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi
 
        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
 
    done
}

# a check-if-Dropbox-installed-and-download-if-not function
function checkDropboxInstalledDownload(){
    if [[ ! -d "$HOME/.dropbox" ]] && [[ ! -d "$HOME/.dropbox-dist" ]] && [[ ! -d "$HOME/Dropbox" ]]; then
      cd ~/ && wget -O - $1  | tar xzf -
    fi
}

function setupDropbox(){
    if [[ -d "$HOME/.dropbox-dist" ]] && [[ -f "$HOME/.dropbox-dist/dropboxd" ]]; then
  
        sudo apt-get install nautilus-dropbox -y
        dropbox start && dropbox autostart y
        echo ""
        echo " ATTENTION! If this script stalls after Dropbox was started pleas quit Dropbox by right-clicking on its tray icon and selecting \"Quit\" "
        echo ""
        ~/.dropbox-dist/dropboxd
              
        #if [[ ! -f "/usr/share/nemo-dropbox" ]]; then # nemo-dropbox just gives me troubles!!!
        #  sudo apt-get install nemo-dropbox -y
        #  sudo apt-get remove nautilus -y
        #fi; echo 6  
        
    fi
}

echo ""
echo ""
echo -e "${green} ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo -e " +                                                                                              +"
echo -e " +                                ${bright_green}BE PATIENT! THIS TAKES TIME!                                  ${green}+"
echo -e " +                                                                                              +"
echo -e " +         And don't go too far, you need to enter some passwords a couple of times ;)          +"
echo -e " +     And when you're asked and you don't know what to enter, just go with the defaults ;)     +"
echo -e " +                                                                                              +"
echo -e " ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo -e ""
echo -e ""
echo -e " ************************************************************************************************"
echo -e " *                                                                                              *"
echo -e " *                         This script is only meant to be run once!                            *"
echo -e " *                                                                                              *"
echo -e " *                  If you need to run this script again be shure to remove                     *"
echo -e " *                  Dropbox before you run or else this script might stall.                     *"
echo -e " *                                                                                              *"
echo -e " *  To remove Dropbox run 'sudo apt-get remove dropbox; rm -rvf ~/.dropbox ~/.dropbox-dist'     *"
echo -e " *                               And then run 'rm -rv ~/Dropbox'                                *"
echo -e " *                                                                                              *"
echo -e " *     And then you need to make shure there aren't any duplicates in the software sources.     *"
echo -e " *                                                                                              *"
echo -e " ************************************************************************************************"
echo ""
echo ""

echo "This script sets up Git."
echo "Git needs your full name and email for its configuration."
read -p "Please enter your full name: " FULLNAME
read -p "Please enter your email: " EMAIL

echo "Setting up necessary software... You will need to enter your password."

checkExpect=$(which expect)
if [[ ! $checkExpect ]]; then
    sudo apt-get -y install expect
fi

read -p "Please confirm your password: " -r -s passwd
export passwd

# edit sudoers so that user wont need to provide password when doing sudo
echo -e "${green}This script can add your username to the list of sudoers so you wont"
echo -e "need to type your password each time when you update or install packages in the terminal."
echo -e "If you have not done that already it is recomended to select 'Y' for this option."
echo -e ""

# Default to Yes if the user presses enter without giving an answer:
if ask "Add me to the sudoers so my life becomes easier? " Y; then
    expect -c '
    spawn su -c "echo \"$env(user) ALL=(ALL:ALL) ALL\" >> /etc/sudoers"
    expect "Password:"
    send "$env(passwd)\r"
    spawn su -c "echo \"$env(user) ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"
    expect "Password:"
    send "$env(passwd)\r"
    interact
    '
fi

# tweak the systems performance
# adjust swappiness
if [[ $swappiness -gt 10 ]]; then
    expect -c '
    spawn su -c "echo \"vm.swappiness=10\" >> /etc/sysctl.conf"
    expect "Password:"
    send "$env(passwd)\r"
    interact
'
fi

echo "This script can tweak your system for better performance!"
if ask "Do you want your system tweaked? " Y; then

    # Disable Hibernation
    if [[ $resume_string =~ ^RESUME.+ ]]; then
      hashed_string="#"$resume_string
      export hashed_string
      
      expect -c '
        spawn su -c "rm /etc/initramfs-tools/conf.d/resume"
        expect "Password:"
        send "gulur.123\r"
        interact
      '
      expect -c '
        spawn su -c "touch /etc/initramfs-tools/conf.d/resume"
        expect "Password:"
        send "gulur.123\r"
        interact
      '
      expect -c '
        spawn su -c "echo \"$env(hashed_string)\" >> /etc/initramfs-tools/conf.d/resume"
        expect "Password:"
        send "gulur.123\r"
        interact
      '
    fi

    # Move /tmp to RAM
    if ! grep -q 'tmpfs /tmp tmpfs defaults,noexec,nosuid 0 0' /etc/fstab; then
      expect -c '
        spawn su -c "echo \"tmpfs /tmp tmpfs defaults,noexec,nosuid 0 0\" >> /etc/fstab"
        expect "Password:"
        send "$env(passwd)\r"
        interact
      '
    fi
    # performance tweak done
fi

if ask "Do you have a Google Account (Gmail)?" Y; then 
    account=yes
else
    account=no
fi

# create a tmp/ folder under Home folder.
cd ~/ && mkdir $HOME/tmp
# create a vagrant folder for Vagrant Server
cd ~/ && mkdir $HOME/Vagrant

# get repositories
echo -ne "\n" | sudo add-apt-repository ppa:webupd8team/sublime-text-2
echo -ne "\n" | sudo add-apt-repository ppa:webupd8team/y-ppa-manager
echo -ne "\n" | sudo add-apt-repository ppa:nilarimogard/webupd8
echo -ne "\n" | sudo add-apt-repository ppa:webupd8team/jupiter
echo -ne "\n" | sudo add-apt-repository ppa:webupd8team/java
echo -ne "\n" | sudo add-apt-repository ppa:apt-fast/stable
echo -ne "\n" | sudo add-apt-repository ppa:shnatsel/zram
echo -ne "\n" | sudo add-apt-repository ppa:git-core/ppa
echo -ne "\n" | sudo add-apt-repository ppa:ondrej/php5
echo -ne "\n" | sudo add-apt-repository ppa:mitya57

# get chrome
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# get playonlinux
wget -q "http://deb.playonlinux.com/public.gpg" -O- | sudo apt-key add -
sudo wget http://deb.playonlinux.com/playonlinux_precise.list -O /etc/apt/sources.list.d/playonlinux.list
echo -e "${green}"
# update the software sources
sudo apt-get update
sudo apt-get -y install preload
sudo apt-get -y install apt-fast
sudo apt-fast -y install oracle-java7-installer
sudo apt-fast -y install oracle-java7-set-default
sudo apt-fast -y install sublime-text-dev
sudo apt-fast -y install y-ppa-manager
sudo apt-fast -y install android-tools-adb android-tools-fastboot
sudo apt-fast -y install playonlinux

if [[ $account == "yes" ]]; then

    sudo apt-fast -y install grive
    mkdir -p ~/grive && cd grive

    # install grive - Linux Google Drive client on the Desktop
    echo ""
    echo -e " ${bright_yellow}--- Setting up Grive - A Linux Google Drive Desktop Client ---"
    echo -e " ${bright_yellow}--- Right-click the provided link below and select to open in a browser and follow the instructions. --- "
    echo -e " ${bright_yellow}--- Grive needs to sync your Google Drive with the grive folder."
    echo ""
    grive -a

fi

# get VirtualBox from Oracle
echo "deb http://download.virtualbox.org/virtualbox/debian quantal contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -

# install all the necessary software
sudo apt-fast -y install zramswap-enabler google-chrome-stable build-essential gcc-4.6-base cpp-4.6 libgomp1 libquadmath0 libc6-dev bison zlib1g-dev libssl-dev autoconf automake libtool curl 
sudo apt-fast -y install dkms virtualbox-4.2 python3.3 openssh-server vim subversion git git-core anjuta vlc x264 ffmpeg2theora oggvideotools istanbul shotwell hugin pavucontrol ogmrip 
sudo apt-fast -y install transmageddon guvcview wavpack mppenc faac flac vorbis-tools faad lame cheese sound-juicer picard arista iperf ifstat wireshark tshark arp-scan htop netspeed 
sudo apt-fast -y install nmap netpipe-tcp preload lm-sensors hardinfo fortune-mod libnotify-bin terminator googleearth-package lsb-core ttf-mscorefonts-installer mint-flashplugin 
sudo apt-fast -y install jupiter alien debhelper intltool intltool-debian istanbul lintian po-debconf anjuta intltool aptdaemon gparted gedit gedit-plugins rabbitvcs-gedit 
sudo apt-fast -y install nemo nemo-data nemo-share nemo-fileroller rabbitvcs-nautilus vim-puppet cream vim-conque vim-addon-manager vim-vimoutliner vim-scripts supercollider-vim
sudo apt-fast -y install vim-syntax-gtk vim-gui-common vim-gtk gimp gimp-data gimp-data-extras gimp-lensfun abr2gbr gimp-gmic pandora gimp-ufraw inkscape ink-generator shutter umlet clipit retext


# make nemo restart so it doesn't screw the rest of the process up
nemo --quit
nautilus --quit

# configure virtualbox
sudo usermod -a -G vboxusers $USERNAME

# git configurations
git config --global user.name "$FULLNAME"
git config --global user.email $EMAIL
git config --global core.editor vim
git config --global merge.tool meld
git config --global color.ui auto
git config --global color.branch auto
git config --global color.diff auto
git config --global color.interactive auto
git config --global color.status auto

# get python distribute and install pip - the python package manager
cd ~/tmp && curl -O http://python-distribute.org/distribute_setup.py
sudo python distribute_setup.py && rm distribute_setup.py
sudo easy_install pip && cd ~/


# install python packages
sudo pip install virtualenv
sudo pip install --upgrade httpie

# lamp stack
sudo apt-fast -y install apache2
sudo apt-fast -y install mysql-server mysql-client
sudo apt-fast -y install php5 libapache2-mod-php5 php5-mcrypt php5-curl php5-ffmpeg php5-geoip php5-imagick php5-imap php5-intl php5-sqlite php5-xdebug php5-xmlrpc php5-xsl php-gettext php-apc php-pear
sudo /etc/init.d/apache2 restart
sudo apt-fast -y install libapache2-mod-auth-mysql php5-mysql phpmyadmin

# make sure .profile is sourced for rvm
echo source ~/.profile >> ~/.bash_profile

# get rvm and ruby
sudo apt-fast -y install libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libgdbm-dev libncurses5-dev libffi-dev
curl -#L https://get.rvm.io | bash -s stable --autolibs=3 --ruby

# get node version manager
cd ~/ && curl https://raw.github.com/creationix/nvm/master/install.sh | sh
. ~/.nvm/nvm.sh && nvm install v0.10.5 && nvm use v0.10.5 && nvm alias default v0.10.5

npm install -g less coffee-script uglify-js jade stylus bower yeoman handlebars grunt async
npm link less coffee-script uglify-js jade stylus bower yeoman handlebars grunt async

# create project folders
cd ~/ && mkdir $HOME/Github

cd ~/ && mkdir $HOME/sites

# set folder permissions for userdir
chmod 711 $HOME
chown $USER:$USER $HOME/sites
chmod 755 -R $HOME/sites

# enable apache2 userdir
if [ -d /etc/apache2 ]
then
	sudo a2enmod userdir
	sudo rm /etc/apache2/mods-enabled/userdir.conf
	sudo rm /etc/apache2/mods-available/php5.conf
	sudo wget https://raw.github.com/villimagg/The-Minty-Developer/master/apache2-mods/userdir.conf -P /etc/apache2/mods-enabled/
	sudo wget https://raw.github.com/villimagg/The-Minty-Developer/master/apache2-mods/php5.conf -P /etc/apache2/mods-available/
	sudo service apache2 restart
	cd ~/ && touch $HOME/sites/phpinfo.php
	echo "<?php phpinfo();" >> $HOME/sites/phpinfo.php
fi

# get composer
cd ~/ && curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar "/usr/local/bin/composer"

sudo mkdir "/usr/local/etc/phpunit"
cd "/usr/local/etc/phpunit"

# dl phpunit composer.json
sudo wget https://raw.github.com/villimagg/The-Minty-Developer/master/phpunit/composer.json
sudo composer install

# get artisan command script
cd ~/tmp && wget https://raw.github.com/villimagg/The-Minty-Developer/master/artisan
chmod +x ./artisan && sudo mv ./artisan /usr/local/bin/

# Composer creates a ~/.composer/ directory for caching
# Making sure ~/.composer/ directory is owned by $USER and not ROOT since otherwise users can't composer install
if [[ ! -d ~/.composer/ ]]; then
    mkdir ~/.composer
fi
sudo chown $USER:$USER -R $HOME/.composer/

# if using cinnamon desktop get the web developer lamp start/stop tool
# enable in Cinnamon Settings > Applets
if [ ! -d ~/.local ]; then 
	mkdir ~/.local
fi

if [ ! -d ~/.local/share ]; then 
	mkdir ~/.local/share
fi

if [ ! -d ~/.local/share/cinnamon ]; then 
	mkdir ~/.local/share/cinnamon
fi

if [ ! -d ~/.local/share/cinnamon/applets ]; then 
	mkdir ~/.local/share/cinnamon/applets
fi

cd ~/tmp
wget http://cinnamon-spices.linuxmint.com/uploads/applets/4PF7-M5KP-USAD.zip
unzip 4PF7-M5KP-USAD.zip && rm 4PF7-M5KP-USAD.zip && cd web-developer-menu@infiniteshroom
mv web-developer-menu@infiniteshroom/ ~/.local/share/cinnamon/applets

# get package controll for sublime text 2
if [ ! -d ~/.config/sublime-text-2 ]; then
	mkdir ~/.config/sublime-text-2
fi

if [ ! -d ~/.config/sublime-text-2/Packages ]; then
	mkdir ~/.config/sublime-text-2/Packages
fi

cd "~/.config/sublime-text-2/Packages"

git clone https://github.com/wbond/sublime_package_control.git "Package Control"
cd "Package Control"
git checkout python3

# get a customized .bashrc script
cd ~/ && rm .bashrc && wget https://raw.github.com/villimagg/The-Minty-Developer/master/.bashrc
source ~/.bashrc

# final update
sudo apt-get update
sudo apt-get autoclean

# source the rvm
source $HOME/.rvm/scripts/rvm
# install some good gems
echo ""
echo -e "${green}Fetching some userful ruby gems..."
echo ""
gem install compass guard guard-phpunit guard-livereload guard-sass guard-coffeescript guard-jasmine guard-haml guard-concat jsmin cssmin zurb-foundation bootstrap-sass bundler bourbon notify rb-inotify libnotify


if [[ $kernel == "x86_64" ]]; then
    #cd ~/tmp && wget -U firefox -r -np http://www.xmind.net/xmind/downloads/xmind-linux-3.3.1.201212250029_amd64.deb && sudo dpkg -i xmind-linux-3.3.1.201212250029_amd64.deb
    cd ~/tmp && wget http://files.vagrantup.com/packages/7e400d00a3c5a0fdf2809c8b5001a035415a607b/vagrant_1.2.2_x86_64.deb && sudo dpkg -i vagrant_1.2.2_x86_64.deb
    checkDropboxInstalledDownload "https://www.dropbox.com/download?plat=lnx.x86_64"
else
    #cd ~/tmp && wget -U firefox -r -np http://www.xmind.net/xmind/downloads/xmind-linux-3.3.1.201212250029_i386.deb && sudo dpkg -i xmind-linux-3.3.1.201212250029_i386.deb
    cd ~/tmp && wget http://files.vagrantup.com/packages/7e400d00a3c5a0fdf2809c8b5001a035415a607b/vagrant_1.2.2_i686.deb && sudo dpkg -i vagrant_1.2.2_i686.deb
    checkDropboxInstalledDownload "https://www.dropbox.com/download?plat=lnx.x86"
fi

# run the setuoDropbox function
setupDropbox

# remove the tmp folder
cd ~/ && rm -rf ~/tmp

echo -e "${green}"
echo ""
echo -e "All is DONE!"
echo ""
echo -e "${yellow}Apache ${bright_yellow}userdir ${yellow}is enabled. Navigate to ${white}http://localhost/~$USERNAME/ ${yellow}to access your userdir."

if ask "You need to reboot your computer. Reboot now?" Y; then
    sudo reboot
else
    exit 1
fi