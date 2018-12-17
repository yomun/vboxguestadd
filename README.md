# vboxguestadd
Help for 'install Guest Additions' on VirtualBox's Linux Virtual Machine /<br>
在 VirtualBox 帮助 Linux 虚拟机安装增强功能 (VBoxGuestAdditions_X.X.X.iso)<br>
<br>
$ wget https://github.com/yomun/vboxguestadd/raw/master/virtualbox.sh<br>
<br>
#### VBOX_VER="5.2.22"<br>
http://download.virtualbox.org/virtualbox<br>
$ sed -i 's/VBOX_VER="5.2.10"/VBOX_VER="<LATEST_VBOXGuestAdditions_VERSION>"/' virtualbox.sh<br>

#### USER_ID="yomun"<br>
$ sed -i 's/USER_ID="yomun"/USER_ID="<YOUR_USER_ID>"/' virtualbox.sh<br>
<br><br>
$ sudo bash virtualbox.sh
