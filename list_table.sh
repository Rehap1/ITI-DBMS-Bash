#!/bin/bash

list_tables(){
    
    # List all files (tables) in the current connected database
    tables=$(ls)  

    # Check if there are tables in the database
    if [ -z "$tables" ]; then
        echo -e "\nNo tables found in the database.\n"
    else
        echo -e "\nList of Tables:"
        echo "$tables"
    fi
    echo
}