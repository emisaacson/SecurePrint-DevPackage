#!/bin/bash

#
# Set the sources, mostly for getting
# ubuntu's sun java package.
#

cat << EOF > /etc/apt/sources.list
deb http://mirrors.kernel.org/debian wheezy main contrib
deb-src http://mirrors.kernel.org/debian wheezy main contrib

deb http://security.debian.org/ wheezy/updates main contrib
deb-src http://security.debian.org/ wheezy/updates main contrib

# wheezy-updates, previously known as 'volatile'
deb http://mirrors.kernel.org/debian wheezy-updates main contrib
deb-src http://mirrors.kernel.org/debian wheezy-updates main contrib

deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
EOF

#
# Put a nice eclipse icon in the applications menu
#

cat << EOF > /usr/share/applications/eclipse.desktop
[Desktop Entry]
Encoding=UTF-8
Name=Eclipse
Comment=Eclipse
Categories=Development;
Exec=bash -c "SWT_GTK3=0 /opt/eclipse/eclipse"
Icon=/opt/eclipse/icon.xpm
Terminal=false
Type=Application
EOF

#
# UDev rules for a samsung phone.
# Consult the android documentation to get the idVendor
# for your phone if it's different.
#

echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="plugdev"' > /etc/udev/rules.d/51-android.rules

#
# Accept the key for the ubuntu repository
#

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

#
# Upgrade all packages
#

apt-get update
apt-get upgrade -y

#
# We need to add i386 architecture and libc to install the ia32-libs
# which is required by android.
#

dpkg --add-architecture i386 
apt-get update
apt-get install libc6:i386 -y

#
# Auto accept the sun java license agreement
#

echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

#
# Install the necessary packages
#

apt-get install oracle-java7-installer -y
apt-get install git -y
apt-get install ia32-libs -y

#
# Download the eclipse package
#

wget -q -O- http://www.emikek.com/android.tar.gz > /opt/android.tar.gz

pushd /opt/
tar xzf android.tar.gz
mv android eclipse
popd

mkdir /root/workspace

git clone https://github.com/emisaacson/SecurePrint-Android.git /root/workspace/SecurePrintAndroidApp
pushd /root/workspace/SecurePrintAndroidApp/
git submodule init
git submodule update
popd

#
# Bug in VB 4.3.10
#

if [ -d /opt/VBoxGuestAdditions-4.3.10 ]; then
	ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
fi

#
# Install Gnome and x windows, but don't have a graphical
# login.
#

apt-get install tasksel -y
tasksel install gnome-desktop --new-install
update-rc.d gdm3 remove

wget -q -O- --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u20-b26/jdk-8u20-linux-x64.tar.gz > /opt/jdk-8u20-linux-x64.tar.gz
