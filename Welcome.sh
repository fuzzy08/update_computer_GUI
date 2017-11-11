#!/bin/bash


################## GETS SUDO PASSWORD ###############################

passwords(){

local pass=$(tempfile 2>/dev/null)

trap "rm -f $pass" 0 1 2 5 15

dialog --title "Sudo Password" --clear --insecure --passwordbox "Password:" 10 10 2>$pass

password=$(<"${pass}")


}






################ ABOUT COMPUTER SECTION #####################

screenFetch(){

if [ -f /usr/bin/screenfetch ]; then
        dialog --clear
        clear
        screenfetch
        read -p "Press enter to continue"
        main
        exit

    else
        dialog --clear
        dialog --title "Screenfetch Not Installed" \
        dialog --msgbox "\n You do not have screenfetch installed" 10 20
        dialog --title "Install?" --yesno "Want to install screenfetch?" 6 20
            response=$?

            case $response in
                0) passwords && echo $password | sudo -S apt install screenfetch && clear && screenfetch && read -p "Press enter to continue" && main;;
                1) main;;
                255) echo "Something went wrong"; break;;
            esac
    fi

}







####################### Updates Your Computer ###################



Update_computer(){

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

dialog --title "CTRL + SHIFT + V for the kernel you want to delete i.e linux-image-X.X.X-XX-generic" --backtitle "Select Kernel to Uninstall" --defaultno --inputbox "Kernel: " 15 70 2>$deleteKern
kernel=$?
dk=$(<"${deleteKern}")
clear
        case $kernel in
		0) if [ -d "/usr/src/xpad-0.4" ]; then
					sudo apt purge $dk && cd /usr/src/xpad-0.4 && sudo git fetch && sudo git checkout origin/master && sudo dkms remove -m xpad -v 0.4 --all && sudo dkms install -m xpad -v 0.4 && cd $path && sudo update-grub
					printf '\e[8;24;80t'
            if [ -f "/usr/bin/lsterminal" ]; then
                if [ -d "/usr/src/xpad-0.4" ]; then
					sudo apt purge $dk && cd /usr/src/xpad-0.4 && sudo git fetch && sudo git checkout origin/master && sudo dkms remove -m xpad -v 0.4 --all && sudo dkms install -m xpad -v 0.4 && cd $path && sudo update-grub
					lxterminal --geometry=80x24 -e main

                else
					sudo apt purge $dk && sudo update-grub
					lxterminal --geometry=80x24 -e main

                fi
            fi



		else
					sudo apt purge $dk && sudo update-grub
					printf '\e[8;24;80t'
		fi;;
        1) exit 0;;
        255) echo "something went wrong"; break;;
        esac
}



############ Fixes dpkg error ####################

Fix_Dpkg(){

passwords

echo $password | sudo -S apt install -f
main
exit 0;

}


######## Exit ##########


Exit(){

    dialog --clear
    clear
    exit 0;
}





######### auto update program #############

update_program(){


############# Checking for useless files ##############

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cd $path



if [[ -f ".update.sh" ]]; then
 rm -rf ".update.sh"

    elif [[ -f ".update.txt" ]]; then
    rm -rf .update.txt

        elif [[ -f ".update1.sh" ]]; then
        rm -rf .update1.sh

               elif [[ -f "test.sh use for debugging" ]]; then
               rm -rf "test.sh use for debugging"

                       elif [[ -f "_update1.sh - do not use" ]]; then
                       rm -rf "_update1.sh - do not use"

fi

############# Checking if Welcome.sh is executable ##########

if [[ ! -x Welcome.sh ]]; then

chmod a+x Welcome.sh

fi




########### Moving files to new folder #############

movePath=$(basename "$PWD");

if [[ $movePath == "update_computer_GUI-master" ]];
then
cd ..
path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P );
mv update_computer_GUI-master $path/update_computer_GUI
cd update_computer_GUI
main
exit
fi

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P );

############ AUTO UPDATER ########################

### Dialog Installer ##############
if [[ ! -f "/usr/bin/dialog" ]]; then
  clear
  echo "You do not have 'Dialog' installed"
  read -p "Would you like to install Dialog? y/n: " yes_to_dialog
    if [ "$yes_to_dialog" == "y" ]; then
      passwords && echo $password | sudo -S apt install dialog -y;
    fi
fi

##### Git Installer ###############
if [[ ! -f "/usr/bin/git" ]]; then
clear
dialog --infobox "You need to install git first..." 10 20

sleep 3
dialog --clear --yesno "Would you like to install git?" 10 20
update=$?
case $update in
    0) passwords && echo $password | sudo -S apt install git -y;;
    1) clear && exit 0;;
    255) echo "something went wrong"; break;;
esac

main
exit
fi


check="$(git fetch -v --dry-run 2>&1)"
echo "${check}" > .update.txt
	if [ -f ".old_update.txt" ]; then
check1=$(<.old_update.txt) 2>&1
    else
touch .old_update.txt
	fi

	if [[ "${check}" == "${check1}" ]]; then
rm .update.txt
clear
	fi

	if [[ "${check}" != "${check1}" ]]; then

git fetch https://github.com/krazynez/update_computer_GUI.git
git clone https://github.com/krazynez/update_computer_GUI.git temp
rsync -a temp/ $path
echo "${check}" > .old_update.txt
rm -rf temp
    fi
############# Checking if Welcome.sh is executable after update ##########

if [[ ! -x Welcome.sh ]]; then

chmod a+x Welcome.sh

fi




 	if [[ "$?" == "1" ]]; then
clear
echo ""
echo "something went wrong"

sleep 10

	fi








}


























################ OPTIONS ########################

main(){
update_program


####### Check if parent or child process is already running ##########

if pidof -o %PPID -x "Welcome.sh" >/dev/null; then
    dialog --infobox "Welcome.sh already running" 3 30
    sleep 5
    exit 0;
elif pidof -o %PPID -x ".update.sh" >/dev/null; then
    dialog --infobox ".update.sh already running" 3 30
    sleep 5
    exit 0;
fi





clear




INPUT='/tmp/menu.output'
# numbers are Height x Width x Menu Height

dialog \
--backtitle "Update_Computer_GUI v1.0.0 ALPHA" \
--nocancel --menu "Please choose one option UP/DOWN arrow keys to select then ENTER to proceed:" 15 55 4 \
1 "About Computer" \
2 "Update Computer" \
3 "Fix dpkg 'lock'" \
4 "Exit" 2>"${INPUT}"

menuitem=$(<"${INPUT}")


case $menuitem in
    1) screenFetch;;
    2) Update_computer;;
    3) Fix_Dpkg;;
    4) Exit;;
esac

}

main
