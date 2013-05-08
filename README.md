The Minty Web Developer - Post install script.
=============================================

A painless Post Installation Script for Linux Mint for Web Developers
-----------------------------------------------------------------

### Installation
To install make sure you've updated your Mint and then copy and paste this command into terminal:

    wget https://raw.github.com/villimagg/The-Minty-Developer/master/minty-devinstaller.sh && chmod +x minty-devinstaller.sh && ./minty-devinstaller.sh && rm minty-devinstaller.sh

This script is meant to be run **once** after a fresh install of Linux Mint 13/14, but if you want to run it again go right ahead :)

### NOTE: This is meant to take away all the tedious post-installation process for most Linux users.
#### But first, why Linux Mint?
> Aside from the discussion on Mac and Windows, for those wanting to run on an open and 
> free platform there are numerous options. Having played with both Ubuntu and Fedora 
> I've learned a lot about what to avoid. Ubuntu and Fedora are both great distros but not
> necessarily the best choise for a web developer who just wants a platform that doesn't 
> stand in his or her way of simply just developing his or hers applications. Ubuntu is friendly
> indeed, but its getting quite heavy on resources and becoming more and more commercial by
> the year. Fedora is awesome in its innovation and leads the development for new technology
> in the open source community. But Fedora can break your desktop more than once in a month
> due to its frequent bleeding edge updates which aren't yet tested well enough. That is not
> something a web developer wants nor needs. I've spent too many hours fixing and tweaking, and
> getting my desktop in shape after updates and this is where I say stop. No more of that.
> Linux Mint is a better option for people like us, who need a working platform that doesn't
> take to much resources since its desktop environment is more light weight and snappy, doesn't
> try to sell you something all the time and doesn't break your environment all the time just 
> because some bleeding edge developers couldn't wait till their code was tested well enough.
> It is also no secret that Linux Mint has become the most popular Linux distro of all of the
> three mentioned here. I wonder why that is?

---

## What's included?

This script includes software sources from [Webupd8.org][webupd8], essential development tools and libraries such as Git, Sublime Text 2, ReText Markdown Editor, all the Vim you can get, Gedit extensions, **LAMP STACK**, RVM, latest Ruby, NVM and Node.js, Python, ORACLE JAVA, Vagrant, necessary fonts and a graphic design suit and a custom .bashrc file with sensible aliases for common terminal commands.

The script sets user permissions so that the user wont need to type his password each time he runs sudo. It installs these packages, creates project folders for github projects and a sites folder in your home folder, sets the necessary permissions for the sites folder for you to use as an Apache2 userdir folder for easy creation of mutiple web development projects.

When the script is done and your computer has rebooted you can navigate to ```http://localhost/~username/``` and there is your user directory for all your web development and a phpinfo.php file for you to check on your PHP installation.

This script also installs some sensible packages like preload and apt-fast for faster package installation and system updating. Just run ```sudo apt-fast update/upgrade/install/remove/reinstall``` instead of ```sudo apt-get```.

This script configures Git. In the beginning of the script it asks you for your full name and email for Git to use for its configuration.

---

## Instructions

After you've installed your Mint, updated and double updated your Mint then run the command which is here above by copying and pasting it into your terminal.
That will fire a script that will start by setting up some necessary software for the Post Installation Process to continue.
Then you will be asked to enter you full name. That is for setting up your Git server on your machine, and then you will be asked to enter you email which you accosiate with Git/Github.

Commits you will make using Git will contain the name and the email you provide. Welcome to Open source.

After that you will be asked for your root password.
Just enter you root password.

You will be asked to accept the ORACLE Java licence. In many cases the ORACLE Java compiler is depended on over OpenJDK. Like for users of Aptana Studio. Just accept.

You will be asked to accept the Microsoft font licence since many important Microsoft fonts will be installed. Just accept.

The jackd2 daemon will come as a depenency. It will prompt you to answer if you'd like to enable realtime kernel processing. Unless you intend to produce music and videos on your machine it is adviced to **NOT** select 'yes' to realtime processing.

Then you will be prompted for a MySQL "root" user password. No less than three times. Many developers prefere to keep their RDBMS Database on their local development computer unguarded since it is only meant for development. It saves the developer a whole bunch of time while developing. You are free to choose whatever password you wish whether it be an "empty" password or whatnot.

Thereafter you will be prompted to configure 'phpmyadmin'. You'll be given a choice between configuring phpmyadmin for wither apache2 or lighthttpd. This script sets up apache2 so select that.

> Again you will be prompted by phpmyadmin to "Configure database for phpmyadmin with dbconfig-common?". Just select 'Yes'.

> "Password of the database's administrative user:" Again this is a development machine. You should rather protect your data using other solutions.

> "MySQL application password for phpmyadmin:" Empty. Just hit OK.

In the end Dropbox is installed. It can happen that the script stalls after Dropbox starts. If that happens quit Dropbox by right-clicking on its tray icon and select "Quit".


--

### Commands available after the script is done:

- ```rvm``` commands for Ruby and Ruby environments
- ```gem``` commands for RubyGems
- ```nvm``` and ```npm``` commands for installing Nodejs modules
- ```artisan``` commands without the need to type ```php``` before ```artisan```

---

## Languages and Servers
- PHP 5.4.14 from a Debian PPA
- Apache 2.2*
- MySQL 5.5*
- Ruby latest via RVM
- Node.js and NPM via NVM
- Python 2.7, 3.2 and 3.3
- Vagrant
- OpenSSH Server
- Git latest
- Dropbox
- Grive - Google Drive Client

## Modules and gems

### Python

- Distribute
- PIP
- HTTPie
- Vitrualenv

### Ruby

- RVM
- Ruby latest
- Guard
- Guard-PHPUnit
- Guard-LiveReload
- Guard-SASS
- Guard-Coffeescript
- Guard-Jasmine 
- Guard-Haml
- jsmin
- cssmin
- bundler
- bourbon
- Compass & SASS
- Zurb Foundation
- Twitter Bootstrap SASS
- notify rb-inotify libnotify

### PHP

- php5
- libapache2-mod-php5
- php5-mcrypt
- php5-curl
- php5-ffmpeg
- php5-geoip 
- php5-imagick 
- php5-imap 
- php5-intl 
- php5-sqlite 
- php5-xdebug 
- php5-xmlrpc 
- php5-xls 
- php-gettext
- php-pear
- php-apc
- Composer
- PHPUnit 3.7.* 
- Artisan

### Node and NPM Packages

- Node.js v0.10.5
- LESS
- coffee-script
- uglify-js
- jade
- stylus
- bower
- yeoman
- handlebars
- grunt
- async

### Programs

- Sublime Text 2
- Vim
- VirtualBox 4.2
- Shutter
- Umlet
- Clipit
- ReText


To install more modules simply navitage to the repositories for the respective package manager and find which packages you want to install. Then it's simply a matter of ```rvm install```, ```gem install```, ```nvm install```, ```npm install -g```, ```composer <command>```, ```artisan <command>```.

---


## The ```artisan``` command
When you want to create a new Laravel 4 project navigate to your sites folder and type ```artisan new <project-name>```.

The command then pulls down the latest build of Laravel 4 and stores it under the folder named after your ```<project-name>```. 

Then cd into your new project folder and use artisan without typing ```php``` before typing ```artisan```. That way it becomes much nicer developing using the artisan tool which ships with Laravel.

---

## The ```mktouch``` command

- ```mktouch newfoldername/newfilename.php``` will create the folder with the file inside it.
- ```mktouch parent/sub-parent/filename.php``` also works fine.

## Compass aliases for generating sass or foundation projects

- ```compass:sass somename``` ="compass create compass-sass -r bootstrap-sass --using bootstrap"
- ```compass:foundation somename``` ="compass create compass-foundation -r zurb-foundation --using foundation"

---

## Command Line aliases
- ls='ls --color=auto'
- dir='dir --color=auto'
- vdir='vdir --color=auto'
- grep='grep --color=auto'
- fgrep='fgrep --color=auto'
- egrep='egrep --color=auto'
- ll='ls -lF'
- lla='ls -alF'
- la='ls -A'
- l='ls -CF'
- cl='clear'
- cll='clear;ls -lF'
- cla='clear;ls -alF'
- update='sudo aptitude update && sudo aptitude upgrade -y'
- p="phpunit --colors"
- alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

### What next?

You've got all the latest development tools installed and there's nothing to stop you from installing Rails using RubyGems, ```gem install rails```, or start a new Nodejs project using NPM. 

## Go nuts!

## If anyone better in BASH scripting than I can help impove this script so that it may be of more use to more people and more intuitive please do not hesitate to fork this repository and make a pull request!

### I do not claim any knowledge in BASH scripting and therefor concider all help appreciated. It is my hope that this script may be of use to both 32-bit users as well as 64-bit users, and those using other distributions as well.

### Below is a list of TODO's, thank you and enjoy.


---

# TODO

- Add some easy commands to easily update the whole development environment and/or parts of it
- Get more people involved for prosperous development of this script



[webupd8]: http://www.webupd8.org/p/ubuntu-ppas-by-webupd8.html "Webupd8.org"




