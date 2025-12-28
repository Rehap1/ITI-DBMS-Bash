#!/bin/bash
databaseDir="./databases"
export databaseDir

source ./create_DB.sh
source ./list_DB.sh
source ./connect_DB.sh
source ./drop_DB.sh


#color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
Reset='\033[0m'

#Main Menu Funtion 
main_menu() {
	while true; do
		clear
		echo    "========== Main Menu =========="
        echo -e "${GREEN}1.Create Database"
        echo -e "${GREEN}2.List Databases"
        echo -e "${GREEN}3.Connect To Database"
        echo -e "${GREEN}4.Drop Database"
        echo -e "${RED}5.Exit${Reset}"
        echo "=============================="

		read -r -p "Enter your choice: " choice
		echo ""

		case $choice in
			1) create_Database ;;
			2) list_Databases ;;
			3) connect_Database ;;
			4) drop_Database ;;
			5) exit 0;;
			*) echo "Invalid Choice!" ;;
		esac
		read -r -s -p "Press any key to return to the main menu..." n1
	done



}

#Call main menu function
main_menu
