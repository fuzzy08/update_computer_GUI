#!/bin/bash


################## GETS SUDO PASSWORD ###############################

passwords(){

local pass=$(tempfile 2>/dev/null)

trap "rm -f $pass" 0 1 2 5 15

dialog --title "Sudo Password" --clear --insecure --passwordbox "Password:" 10 10 2>$pass

password=$(<"${pass}")


}






################ ABOUT COMPUTER SECTION #####################

function screenFetch(){

if [ -f /usr/bin/screenfetch ]; then
        dialog --clear
        clear
        screenfetch
        read -p "Press enter to continue"
        bash Welcome.sh                        
        exit

    else
        dialog --clear
        dialog --title "Screenfetch Not Installed" \
        dialog --msgbox "\n You do not have screenfetch installed" 10 20
        dialog --title "Install?" --yesno "Want to install screenfetch?" 6 20
            response=$?
            
            case $response in
                0) passwords && echo $password | sudo -S apt install screenfetch && clear && screenfetch && read -p "Press enter to continue" && bash Welcome.sh;;    
                1) bash Welcome.sh && exit;; 
                255) echo "Something went wrong"; break;;
            esac
    fi

}







####################### Updates Your Computer ###################




Update_computer(){

if [ -f "/usr/bin/gnome-terminal" ]; then
            dialog --clear
            bash .update.sh
            exit
            else
            clear
            kl="$( echo $$ )"
            path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
            cd $path
            dialog --title "Update computer?" \
            dialog --msgbox "\n Do you want to update your computer?" 10 20
            dialog --title "Update?" --yesno "Do you wish to update your computer?" 6 20
                update=$?
                
                case $update in
                    0) passwords && echo $password | sudo -S apt update && echo $password | sudo -S apt upgrade -yy && echo $password | sudo -S apt dist-upgrade -yy && echo $password | sudo -S apt autoremove -yy && echo $password | sudo -S apt autoclean;;
                    1) bash Welcome.sh && exit;;
                    255) echo "Something went wrong"; break;;
                esac



fi




}



############ Fixes dpkg error ####################

Fix_Dpkg(){

passwords

echo $password | sudo -S apt install -f
bash Welcome.sh                                    
exit 0;

}


######## Exit ##########


Exit(){

    dialog --clear
    clear
    exit 0;
}







update_program(){

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
bash Welcome.sh
exit
fi

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P );

############ AUTO UPDATER ########################

if [[ ! -f "/usr/bin/git" ]]; then
clear
dialog --infobox "You need to install git first..." 10 20

sleep 3
dialog --clear --yesno "Would you like to install git?"
update=$?
case $update in
    0) passwords && echo $password | sudo -S apt install git -y;;
    1) clear && exit 0;;
    255) echo "something went wrong"; break;;
esac

bash Welcome.sh
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

bash Welcome.sh

exit 0;
	

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
