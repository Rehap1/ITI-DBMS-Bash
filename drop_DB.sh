#!/bin/bash

drop_Database() {
    read -p "Enter database name to drop: " dbname
    DB="$databaseDir/$dbname"

    if [[ -z "$dbname" ]]; then
            echo -e "\nDatabase name cannot be empty!\n"
	    return
    fi


    if [[ -d "$DB" ]]; then
        read -p "Are you sure you want to drop database '$dbname'? This action cannot be undone. (y/n): " confirm
        confirm=${confirm,,}  # convert to lowercase
        if [[ "$confirm" != "y" ]]; then
            echo -e "\nDrop database canceled.\n"
            return
        else
            rm -r "$DB"
            echo -e "\nDatabase $dbname dropped successfully.\n"
        fi
  
    else
        echo -e "\nDatabase $dbname does not exist.\n"
    fi
}
