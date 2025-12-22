#!/bin/bash

# Function to list all databases


list_Databases() {
   
    if [ ! -d "$databaseDir" ] || [ -z "$(ls -A $databaseDir)" ]; then
        echo -e "\nYou don't have any databases yet\n"
    else
        for db in "$databaseDir"/*; do
            echo "$(basename "$db")"
        done
        echo ""
    fi
   
}

