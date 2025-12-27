source ./list_DB.sh

select_table(){
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
    
    # Read metadata
    mapfile -t cols  < <(cut -d: -f1 "$meta_file")
    mapfile -t types < <(cut -d: -f2 "$meta_file")

    echo
    echo "1) Select ALL"
    echo "2) Select Specific Columns"
    echo "3) Select with WHERE condition"
    echo "4) Back"

    read -p "Choice: " choice

    case $choice in
        # ================= SELECT * =================
        1) printf "%s\t" "${cols[@]}" 
           echo
           echo "-----------------------------------"
           while IFS=: read -r -a row; do
                printf "%s\t" "${row[@]}"
                echo
           done < "$table_name"
        ;;

        # ================= SELECT COLUMNS =================
        2) read -p "Enter column names (comma separated): " input
            IFS=',' read -r -a selected_cols <<< "$input"

            indexes=()
            for sel_col in "${selected_cols[@]}"; do
                found=0
                for i in "${!cols[@]}"; do
                    if [[ "${cols[i]}" == "$sel_col" ]]; then
                        indexes+=("$i")
                        found=1
                        break
                    fi
                done
                if [[ $found -eq 0 ]]; then
                    echo "Column $sel_col does not exist."
                    return
                fi
            done

            printf "%s\t" "${selected_cols[@]}"
            echo
            echo "--------------------------------"

            while IFS=: read -r -a row; do
                for idx in "${indexes[@]}"; do
                    printf "%s\t" "${row[idx]}"
                done
                echo
            done < "$table_name"
        ;;

        # ================= SELECT WHERE =================
        3) read -p "Enter condition (column_name = value): " condition
           
           condition=${condition// /}  # remove spaces

           if [[ ! "$condition" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)=([^=]+)$ ]]; then
               echo "Invalid condition format. Use column_name = value."
               return
            else
               where_col="${BASH_REMATCH[1]}"
               where_val="${BASH_REMATCH[2]}"
           fi
           

            where_index=-1
            for i in "${!cols[@]}"; do
                if [[ "${cols[i]}" == "$where_col" ]]; then
                    where_index=$i
                    break
                fi
            done

            if [[ $where_index -eq -1 ]]; then
                echo "Column $where_col does not exist."
                return
            fi

            printf "%s\t" "${cols[@]}"
            echo
            echo "-----------------------------------"

            while IFS=: read -r -a row; do
                if [[ "${row[where_index]}" == "$where_val" ]]; then
                    printf "%s\t" "${row[@]}"
                    echo
                fi
            done < "$table_name"
        ;;

        4) return ;;
        *)  echo "Invalid choice!" ;;

    esac
}




















