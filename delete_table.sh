#!/bin/bash

source ./list_table.sh

delete_table() {

    list_tables

    # Choose table
    while true; do
        read -p "Enter table name: " table_name
        table_name=${table_name,,}

        if [[ -f "$table_name" && -f ".$table_name.meta" ]]; then
            break
        else
            echo "Table does not exist."
        fi
    done

    meta_file=".$table_name.meta"

    echo
    echo "1) Delete ALL rows"
    echo "2) Delete with condition"
    echo "3) Back"
    read -p "Choice: " choice

    case $choice in

    # ================= DELETE ALL =================
    1)
        read -p "Are you sure you want to delete ALL rows? (y/n): " confirm
        confirm=${confirm,,}

        if [[ "$confirm" == "y" ]]; then
            > "$table_name"   # truncate file
            echo "All rows deleted successfully."
        else
            echo "Delete canceled."
        fi
        ;;
    # ================= DELETE WHERE =================
    2)

        # Read metadata
        mapfile -t cols  < <(cut -d: -f1 "$meta_file")
        mapfile -t types < <(cut -d: -f2 "$meta_file")

        # Read condition
        read -p "Enter condition (col = value): " condition
        condition=${condition,,}
        condition=${condition// /}

        # Validate condition
        if [[ ! "$condition" =~ ^[a-zA-Z_][a-zA-Z0-9_]*=.*$ ]]; then
            echo "Invalid condition format. Use: col=value"
            return
        fi

        where_col="${condition%%=*}"
        where_val="${condition#*=}"

        # Find column index
        where_index=-1
        for i in "${!cols[@]}"; do
            if [[ "${cols[i]}" == "$where_col" ]]; then
                where_index=$i
                break
            fi
        done

        if [[ $where_index -eq -1 ]]; then
            echo "Column '$where_col' not found"
            return
        fi

        tmp_file=".$table_name.tmp"
        deleted=0

        # Read table and write non-matching rows
        while IFS=: read -r -a row; do

            if [[ "${row[where_index],,}" == "$where_val" ]]; then
                ((deleted++))
                continue   # skip this row (DELETE)
            fi

            # keep row
            echo "${row[*]}" | tr ' ' ':' >> "$tmp_file"

        done < "$table_name"

        # Replace table
        mv "$tmp_file" "$table_name"

        if [[ $deleted -eq 0 ]]; then
            echo "No matching rows found."
        else
            echo "$deleted row(s) deleted successfully."
        fi
    ;;
    3)
        return
        ;;
    *)
        echo "Invalid choice."
        ;;
    esac

}
