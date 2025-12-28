#!/bin/bash

create_table() {
    read -p "Enter table name: " table_name
    table_name=${table_name,,}

    if [[ ! "$table_name" =~ ^[a-z_][a-z0-9_]*$ ]]; then
        echo -e "\nInvalid table name!\n"
        return
    fi

    if [[ -f "$table_name" ]]; then
        echo -e "\nError: Table already exists.\n"
        return
    fi

    read -p "Enter number of columns: " colNum
    if [[ ! "$colNum" =~ ^[1-9][0-9]*$ ]]; then
        echo -e "\nInvalid number of columns.\n"
        return
    fi

    echo -e "\nNote: Column 1 is PRIMARY KEY by default."

    # -------------------------------
    # TEMP metadata file
    # -------------------------------
    tmp_meta=".$table_name.meta.tmp"
    > "$tmp_meta"   # create empty temp file

    for ((i=1; i<=colNum; i++)); do
        while true; do
            echo -e "\nDefining Column $i:"
            read -p "Column $i name: " col_name
            col_name=${col_name,,}

            if [[ ! "$col_name" =~ ^[a-z_][a-z0-9_]*$ ]]; then
                echo "Invalid column name."
                continue
            fi

            if grep -q "^$col_name:" "$tmp_meta"; then
                echo "Column name already exists!"
                continue
            fi

            break
        done

        if [[ $i -eq 1 ]]; then
            while true; do
                read -p "Choose PRIMARY KEY datatype (int/string): " pk_type
                pk_type=${pk_type,,}

                if [[ "$pk_type" == "int" || "$pk_type" == "string" ]]; then
                    echo "$col_name:$pk_type:pk" >> "$tmp_meta"
                    break
                else
                    echo "Primary key must be int or string."
                fi
            done
        else
            while true; do
                read -p "Column $i datatype (int/string/bool): " datatype
                datatype=${datatype,,}

                if [[ "$datatype" =~ ^(int|string|bool)$ ]]; then
                    echo "$col_name:$datatype" >> "$tmp_meta"
                    break
                else
                    echo "Invalid datatype."
                fi
            done
        fi
    done

    # -------------------------------
    # ALL STEPS PASSED → CREATE TABLE
    # -------------------------------
    meta_file=".$table_name.meta"
    mv "$tmp_meta" "$meta_file"
    touch "$table_name"

    echo -e "\nTable '$table_name' created successfully with $colNum columns.\n"
}
