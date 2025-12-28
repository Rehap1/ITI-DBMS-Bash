#!/bin/bash


source ./list_table.sh

insert_table() {
    list_tables

    while true; do
        read -p "Enter table name: " table_name
        table_name=${table_name,,}  # convert to lowercase
        if [[ ! -f "$table_name" || ! -f ".$table_name.meta" ]]; then
            echo "Table does not exist."
            continue
        fi
        break
    done

    meta_file=".$table_name.meta"
    mapfile -t cols < <(cut -d: -f1 "$meta_file")
    mapfile -t types < <(cut -d: -f2 "$meta_file")

    pk_index=0
    row=""

    for i in "${!cols[@]}"; do
        while true; do
            read -p "Enter value for ${cols[i]} (${types[i]}): " value

            # Check for empty input
            if [[ -z "$value" ]]; then
                echo "Value cannot be empty!"
                continue
            fi

            # lowercase bool
            [[ "${types[i]}" == "bool" ]] && value=${value,,}

            # validation
            if [[ "${types[i]}" == "int" ]]; then
                if ! [[ $value =~ ^[0-9]+$ ]]; then
                    echo "Must be an integer"
                    continue
                fi
            elif [[ "${types[i]}" == "bool" ]]; then
                if [[ $value != "true" && $value != "false" ]]; then
                    echo "Must be true/false"
                    continue
                fi
            fi

             # check uniqueness
            if grep -q "^$value:" "$table_name"; then
                echo "Primary key already exists!"
                continue
            fi


            break
        done

        # append to row
        row="${row:+$row:}$value"
    done

    echo "$row" >> "$table_name"
    echo "Row inserted successfully"
}
