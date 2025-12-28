#!/bin/bash

# Function to list all databases
list_Databases() {
    if [[ ! -d "$databaseDir" || -z "$(ls -A "$databaseDir")" ]]; then
        echo -e "\nYou don't have any databases yet\n"
        return
    fi

    echo
    i=1
    for db in "$databaseDir"/*; do
        echo "$i) $(basename "$db")"
        ((i++))
    done
    echo
}


