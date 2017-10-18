#!/bin/bash
clear


INPUT='/tmp/menu.output'
# numbers are Width x Length

dialog \
--backtitle "Update_Computer_GUI v1.0.0 ALPHA" \
--menu "Please choose one option UP/DOWN arrow keys to select then ENTER to proceed:" 15 55 4 \
1 "About Computer" \
2 "Update Computer" \
3 "Fix dpkg 'lock'" \
4 "Exit" 2>"${INPUT}"

menuitem=$(<"${INPUT}")



################## GETS SUDO PASSWORD ###############################

passwords(){

local pass=$(tempfile 2>/dev/null)

trap "rm -f $pass" 0 1 2 5 15

dialog --title "Sudo Password" --clear --insecure --passwordbox "Password:" 10 10 2>$pass

password=$(<"${pass}")


}















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
            passwords
            case $response in
                0) echo $password | sudo -S apt install screenfetch && clear && screenfetch && read -p "Press enter to continue" && bash Welcome.sh;;    
                1) bash Welcome.sh && exit;; 
                255) echo "Something went wrong"; break;;
            esac
    fi

}

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
                passwords
                case $update in
                    0) echo $password | sudo -S apt update && echo $password | sudo -S apt upgrade -yy && echo $password | sudo -S apt dist-upgrade -yy && echo $password | sudo -S apt autoremove -yy && echo $password | sudo -S apt autoclean;;
                    1) bash Welcome.sh && exit;;
                    255) echo "Something went wrong"; break;;
                esac



fi




}








Exit(){

    dialog --clear
    clear
    exit 0;
}







Fix_Dpkg(){

passwords

echo $password | sudo -S apt install -f
bash Welcome.sh                                    
exit 0;

}




case $menuitem in 
    1) screenFetch;;
    2) Update_computer;;
    3) Fix_Dpkg;;
    4) Exit;;
esac


