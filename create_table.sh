#!/bin/bash

create_table(){
    read -p "Enter table name: " table_name
    table_name=${table_name,,}  # convert to lowercase

    # Validate table name
    if [[ ! "$table_name" =~ ^[a-z_][a-z0-9_]*$ ]]; then
        echo -e "\nInvalid table name!\n"
        return
    fi

    #Check if table exist
    if [[ -f $table_name ]]; then
        echo -e "\nError: Table name already exist.\n"
        return
    fi



    read -p "Enter number of Coloumns: " colNum
    if [[ ! "$colNum" =~ ^[1-9][0-9]*$ ]]; then
        echo -e "\nInvalid number of columns. Please enter a positive integer.\n"
        return
    fi

  
    #Create table and meta data files
    meta_file=".$table_name.meta"
    touch "$meta_file"
    touch "$table_name" 



    echo "Note: Column 1 is INTEGER PRIMARY KEY by default."

    for ((i=1; i<=colNum; i++)); do
        
            
        while true; do
            read -p "Column $i name: " col_name
             # Column name validation
            if [[ ! "$col_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                echo -e "\nInvalid column name\n"
                continue
            fi

            if grep -q "^$col_name:" "$meta_file"; then
                echo -e "\nColumn name already exists!\n"
                continue
            fi

            break
        done

        
        if [ "$i" -eq 1 ]; then
            echo "$col_name:int:pk" >> "$meta_file"
        else
            while true; do

                read -p "Column $i datatype(int/string/bool): " datatype
                datatype=${datatype,,}   # convert to lowercase
                if [[ "$datatype" != "int" && "$datatype" != "string"  && "$datatype" != "bool" ]]; then
                    echo "Invalid datatype. Choose int , string or bool."
                    continue
                fi
                break
            done
             echo "$col_name:$datatype" >> "$meta_file"
        fi
    done


}
