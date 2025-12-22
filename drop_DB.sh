#!/bin/bash

drop_Database() {
    read -p "Enter database name to drop: " dbname
    DB="$databaseDir/$dbname"

    if [[ -z "$dbname" ]]; then
            echo -e "\nDatabase name cannot be empty!\n"
	    return
    fi


    if [[ -d "$DB" ]]; then
        rm -r "$DB"
        echo -e "\nDatabase $dbname dropped successfully.\n"
    else
        echo -e "\nDatabase $dbname does not exist.\n"
    fi
}
