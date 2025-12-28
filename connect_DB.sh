#!/bin/bash


source ./list_DB.sh
source ./create_table.sh
source ./list_table.sh
source ./drop_table.sh
source ./insert_table.sh
source ./select_table.sh
source ./delete_table.sh
source ./update_table.sh

CURRENT_DB=""
BASE_DIR=$(pwd)



connect_Database() {
    # Check if databases directory exists and is not empty
    if [ ! -d "$databaseDir" ] || [ -z "$(ls -A "$databaseDir")" ]; then
        echo -e "No databases to connect. Please create a database first.\n"
        return
    fi

    # Build array of database names
    databases=()
    for db in "$databaseDir"/*/; do
        [ -d "$db" ] && databases+=("$(basename "$db")")
    done

	
    PS3="Select Database: "
    select db_name in "${databases[@]}" "Back to Main Menu"; do
        if [[ "$REPLY" -eq $((${#databases[@]}+1)) ]]; then
            echo "Returning to main menu..."
            return
        elif [[ -n "$db_name" ]]; then

			cd "$databaseDir/$db_name" || return
			CURRENT_DB=$db_name
			echo "Connected to database: $db_name"
			DatabaseActions
            cd "$BASE_DIR"
            break
        else
            echo "Invalid option, try again."
        fi
    done
}

DatabaseActions() {

	while true; do
		clear
        	echo -e "\nDatabase $CURRENT_DB Menu\n"
        	echo "1. Create Table"
        	echo "2. List Tables"
        	echo "3. Drop Table"
        	echo "4. Insert into Table"
        	echo "5. Select From Table"
        	echo "6. Delete From Table"
        	echo "7. Update Table"
        	echo "8. Disconnect"
			echo ""
        	read -r -p "Enter your choice: " choice
        	case $choice in
					1) create_table ;;
            		2) list_tables;;  
            		3) drop_table ;;
            		4) insert_table ;;
            		5) select_table ;;
            		6) delete_table ;;
            		7) update_table ;;
            		8) break ;;  # Exit the loop to disconnect
            		*) echo "Invalid choice!" ;;
        	esac
        	read -r -p "Press any key to return to the menu..." -n1 -s
    	done

}

