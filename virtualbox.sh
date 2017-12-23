#!/usr/bin/env bash

#
# https://jasonmun.blogspot.my
# https://github.com/yomun
# 
# Copyright (C) 2017 Jason Mun
#
#
# 将这个 BASH 放到 Linux 虚拟机上运行
# sudo bash virtualbox.sh

# 主机现在所用的 VirtualBox 版本号
VBOX_VER="5.2.4"

# 用户 ID
USER_ID="yomun"

OS_RELEASE=`cat /etc/os-release`

function install_VBOXADDITIONS()
{
	if [ ! -d "/opt/VBoxGuestAdditions-*" ]
	then		
		local ISO_FILE="VBoxGuestAdditions_${VBOX_VER}.iso"
	
		if [ ! -f "${ISO_FILE}" ]; then
			wget http://download.virtualbox.org/virtualbox/${VBOX_VER}/${ISO_FILE}
		fi
		
		if [ -f "${ISO_FILE}" ]; then
		
			local FOLDER="/media/${USER_ID}/VBOXADDITIONS_${VBOX_VER}"
			if [ ! -d "${FOLDER}" ]; then sudo mkdir -p ${FOLDER}; fi
	
			sudo mount -o loop ${ISO_FILE} ${FOLDER}
	
			if [ -f "${FOLDER}/VBoxLinuxAdditions.run" ]; then
				sudo sh ${FOLDER}/VBoxLinuxAdditions.run --nox11
			fi
			
			sleep 5
		
			sudo umount ${FOLDER}
			sudo rm -rf ${FOLDER}
			
			rm -rf ${ISO_FILE}
		fi
	fi
}

if [ `echo ${OS_RELEASE} | grep -c "ubuntu"` -gt 0 ] || [ `echo ${OS_RELEASE} | grep -c "linuxmint"` -gt 0 ] || [ `echo ${OS_RELEASE} | grep -c "debian"` -gt 0 ] || [ `echo ${OS_RELEASE} | grep -c "zorin"` -gt 0 ] || [ `echo ${OS_RELEASE} | grep -c "elementary"` -gt 0 ]
then
	sudo apt install linux-headers-$(uname -r) -y
	sudo apt install gcc cpp make perl libelf-dev -y

	install_VBOXADDITIONS
	sudo usermod -aG vboxsf ${USER_ID}
	
	# sudo groupadd vboxusers
	# sudo adduser ${USER_ID} vboxusers

elif [ `echo ${OS_RELEASE} | grep -c 'ID=\"centos\"'` -gt 0 ] || [ `echo ${OS_RELEASE} | grep -c 'ID=\"rhel\"'` -gt 0 ]
then
	sudo yum install kernel-devel-$(uname -r) -y
	sudo yum install gcc gcc-c++ make perl elfutils-libelf-devel -y

	install_VBOXADDITIONS
	sudo usermod -aG vboxsf ${USER_ID}

elif [ `echo ${OS_RELEASE} | grep -c 'ID=fedora'` -gt 0 ]
then
	sudo dnf install kernel-devel-$(uname -r) -y
	sudo dnf install gcc gcc-c++ make perl elfutils-libelf-devel -y

	install_VBOXADDITIONS
	sudo usermod -aG vboxsf ${USER_ID}

elif [ `echo ${OS_RELEASE} | grep -c "opensuse"` -gt 0 ]
then
	sudo zypper install kernel-devel
	sudo zypper install gcc gcc-c++ make perl libelf-devel

	install_VBOXADDITIONS
	sudo usermod -aG vboxsf ${USER_ID}

elif [ `echo ${OS_RELEASE} | grep -c "manjaro"` -gt 0 ] || [ `echo ${OS_RELEASE} | grep -c "antergos"` -gt 0 ]
then
	install_VBOXADDITIONS
	
	sudo systemctl enable vboxservice
	sudo systemctl start vboxservice
	
	sudo gpasswd -a ${USER_ID} vboxsf
	sudo chmod -R 755 /media

elif [ `echo ${OS_RELEASE} | grep -c "solus"` -gt 0 ]
then
	sudo eopkg up -y
	
	sudo eopkg install gcc make g++ autoconf binutils xorg-server-devel -y
	sudo eopkg install -c system.devel -y
	
	sudo eopkg install linux-lts-headers -y
	sudo eopkg install linux-current-headers -y
	
	install_VBOXADDITIONS
	sudo usermod -aG vboxsf ${USER_ID}
	sudo chmod -R 755 /media

elif [ `echo ${OS_RELEASE} | grep y-c "mageia"` -gt 0 ]
then
	urpmi kernel-devel
	urpmi gcc

	# 去 [安装增强功能], 然后运行以下, 再重启
	# usermod -aG vboxsf ${USER_ID}
fi
