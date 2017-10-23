#!/bin/bash
clear
################## GETS SUDO PASSWORD ###############################

passwords(){

local pass=$(tempfile 2>/dev/null)

trap "rm -f $pass" 0 1 2 3 15

dialog --title "Sudo Password" --clear --insecure --passwordbox "Password:" 10 10 2>$pass

password=$(<"${pass}")


}


update(){

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cd $path


########## completely updates and removes old packages ###########
dialog --clear --yesno "Do you want to update your computer?" 10 30
update=$?

case $update in
    
    0) passwords && echo $password | sudo -S apt update && echo $password | sudo -S apt upgrade -yy && echo $password | sudo -S apt dist-upgrade -yy && echo $password | sudo -S apt autoremove -yy && echo $password | sudo -S apt autoclean;;
    1) clear && exit 0;;
    255) echo "something went wrong";;
esac

kernelUninstall

}

######### Uninstall old kernels #################

kernelUninstall(){
	dialog --title "Kernel Uninstall" --defaultno --yesno "Do you want to see if you can uninstall old kernels?" 10 30 
    kernel=$?






		case $kernel in
       0) kern=$(uname -r)
		dialog --infobox "!DO NOT DELETE THIS IF MOST CURRENT! \nCurrent Kernel: $kern" 10 50
        sleep 10
       kernel=$(dpkg --list | grep linux-image)
		 dialog --title "Copy just linux-image-X.X.X-XX-generic" --backtitle "Kernel to uninstall" --infobox "$kernel" 15 70
        sleep 20;;
        
        
        1) clear && exit 0;;	
           esac
local deleteKern=$(tempfile 2>/dev/null)
       
dialog --title "CTRL + SHIFT + V for the kernel you want to delete i.e linux-image-X.X.X-XX-generic" --backtitle "Select Kernel to Uninstall" --inputbox "Kernel: " 15 70 2>$deleteKern
kernel=$?
dk=$(<"${deleteKern}")
clear 
        case $kernel in
		0) if [ -d "/usr/src/xpad-0.4" ]; then
					sudo apt-get purge $dk && cd /usr/src/xpad-0.4 && sudo git fetch && sudo git checkout origin/master && sudo dkms remove -m xpad -v 0.4 --all && sudo dkms install -m xpad -v 0.4 && cd $path && sudo update-grub
					printf '\e[8;24;80t'
            if [ -f "/usr/bin/lsterminal" ]; then
                if [ -d "/usr/src/xpad-0.4" ]; then
					sudo apt-get purge $dk && cd /usr/src/xpad-0.4 && sudo git fetch && sudo git checkout origin/master && sudo dkms remove -m xpad -v 0.4 --all && sudo dkms install -m xpad -v 0.4 && cd $path && sudo update-grub
					lxterminal --geometry=80x24 -e bash Welcome.sh
                
                else
					sudo apt-get purge $dk && sudo update-grub
					lxterminal --geometry=80x24 -e bash Welcome.sh

                fi
            fi


				
		else
					sudo apt-get purge $dk && sudo update-grub
					printf '\e[8;24;80t'
		fi;;
        1) exit 0;;
        255) echo "something went wrong"; break;;
        esac
}

update


