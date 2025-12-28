#!/bin/bash

source ./list_table.sh

# Datatype validation
validate_datatype() {
    local value="$1"
    local type="$2"

    case "$type" in
        int)
            [[ "$value" =~ ^-?[0-9]+$ ]]
            ;;
        bool)
            [[ "$value" =~ ^(true|false|0|1)$ ]]
            ;;
        string)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

update_table() {
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

    # Read metadata
    mapfile -t cols  < <(cut -d: -f1 "$meta_file")
    mapfile -t types < <(cut -d: -f2 "$meta_file")

    while true; do
        echo
        echo "1) Update ALL rows"
        echo "2) Update with WHERE condition"
        echo "3) Back"
        read -p "Choice: " choice

        case $choice in
        # ================= UPDATE ALL =================
        1)
            read -p "Enter SET clause (col=value): " set_clause
            set_clause=${set_clause,,}
            set_clause=${set_clause// /}

            if [[ ! "$set_clause" =~ ^[a-z_][a-z0-9_]*=.*$ ]]; then
                echo "Invalid SET format. Use: col=value"
                continue
            fi

            set_col="${set_clause%%=*}"
            set_val="${set_clause#*=}"

            # Find column index
            set_index=-1
            for i in "${!cols[@]}"; do
                if [[ "${cols[i],,}" == "$set_col" ]]; then
                    set_index=$i
                    break
                fi
            done

            if [[ $set_index -eq -1 ]]; then
                echo "Column '$set_col' not found"
                continue
            fi

            # Prevent PK update
            if [[ $set_index -eq 0 ]]; then
                echo "Cannot update primary key!"
                continue
            fi

            # Datatype validation
            if ! validate_datatype "$set_val" "${types[set_index]}"; then
                echo "Invalid value '$set_val' for datatype '${types[set_index]}'"
                continue
            fi

            tmp_file=".$table_name.tmp"
            updated=0
            > "$tmp_file"

            while IFS=: read -r -a row; do
                row[set_index]="$set_val"
                ((updated++))
                echo "${row[*]}" | tr ' ' ':' >> "$tmp_file"
            done < "$table_name"

            mv "$tmp_file" "$table_name"
            echo "$updated row(s) updated successfully."
            ;;

        # ================= UPDATE WHERE =================
        2)
            read -p "Enter SET clause (col=value): " set_clause
            set_clause=${set_clause,,}
            set_clause=${set_clause// /}

            if [[ ! "$set_clause" =~ ^[a-z_][a-z0-9_]*=.*$ ]]; then
                echo "Invalid SET format. Use: col=value"
                continue
            fi

            set_col="${set_clause%%=*}"
            set_val="${set_clause#*=}"

            set_index=-1
            for i in "${!cols[@]}"; do
                if [[ "${cols[i],,}" == "$set_col" ]]; then
                    set_index=$i
                    break
                fi
            done

            if [[ $set_index -eq -1 ]]; then
                echo "Column '$set_col' not found"
                continue
            fi

            if [[ $set_index -eq 0 ]]; then
                echo "Cannot update primary key!"
                continue
            fi

            if ! validate_datatype "$set_val" "${types[set_index]}"; then
                echo "Invalid value '$set_val' for datatype '${types[set_index]}'"
                continue
            fi

            # WHERE clause
            read -p "Enter WHERE clause (col=value): " where_clause
            where_clause=${where_clause,,}
            where_clause=${where_clause// /}

            if [[ ! "$where_clause" =~ ^[a-z_][a-z0-9_]*=.*$ ]]; then
                echo "Invalid WHERE format. Use: col=value"
                continue
            fi

            where_col="${where_clause%%=*}"
            where_val="${where_clause#*=}"

            where_index=-1
            for i in "${!cols[@]}"; do
                if [[ "${cols[i],,}" == "$where_col" ]]; then
                    where_index=$i
                    break
                fi
            done

            if [[ $where_index -eq -1 ]]; then
                echo "Column '$where_col' not found"
                continue
            fi

            tmp_file=".$table_name.tmp"
            updated=0
            > "$tmp_file"

            while IFS=: read -r -a row; do
                if [[ "${row[where_index],,}" == "$where_val" ]]; then
                    row[set_index]="$set_val"
                    ((updated++))
                fi
                echo "${row[*]}" | tr ' ' ':' >> "$tmp_file"
            done < "$table_name"

            mv "$tmp_file" "$table_name"
            echo "$updated row(s) updated successfully."
            ;;

        3)
            return
            ;;
        *)
            echo "Invalid choice"
            ;;
        esac
    done
}
