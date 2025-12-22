#!/bin/bash
databaseDir="./databases"
export databaseDir

source ./create_DB.sh
source ./list_DB.sh
source ./connect_DB.sh
source ./drop_DB.sh


#Main Menu Funtion 
main_menu() {
	while true; do
		clear
		echo "Main Menu"
		echo "1. Create Database"
		echo "2. List Database"
		echo "3. Connect To Database"
		echo "4. Drop Database"
		echo "5. Exit"
		read -r -p "Enter you choice: " choice
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
