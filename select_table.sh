source ./list_DB.sh

# Function to print a dynamic separator line based on number of columns
print_separator() {
    local cols_array=("$@")   # Accept array of column names
    local line=""
    for col in "${cols_array[@]}"; do
        line+="-----------------"
    done
    echo "$line"
}


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

    while true; do
        
    
        meta_file=".$table_name.meta"
        
        # Read metadata
        mapfile -t cols  < <(cut -d: -f1 "$meta_file")
        mapfile -t types < <(cut -d: -f2 "$meta_file")

       
        echo
        echo "1. Select ALL"
        echo "2. Select ALL with WHERE condition"
        echo "3. Select Specific Columns"
        echo "4. Select Specific Columns with WHERE condition"
        echo "5. Back"

        read -p "Choice: " choice

        case $choice in
            # ================= SELECT * =================
            1) 
            echo
            printf "%-15s\t" "${cols[@]}" 
            echo
            print_separator "${cols[@]}" 
            while IFS=: read -r -a row; do
                    printf "%-15s\t" "${row[@]}"
                    echo
            done < "$table_name"
            ;;

            # ================= SELECT ALL WHERE =================
            2) 
            echo
            read -p "Enter condition (column_name = value): " condition
            condition=${condition,,}
            condition=${condition// /}  # remove spaces

            if [[ ! "$condition" =~ ^([a-z_][a-z0-9_]*)=([^=]+)$ ]]; then
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
                echo
                printf "%-15s\t" "${cols[@]}"
                echo
                print_separator "${cols[@]}" 

                while IFS=: read -r -a row; do
                    if [[ "${row[where_index],,}" == "$where_val" ]]; then
                        printf "%-15s\t" "${row[@]}"
                        echo
                    fi
                done < "$table_name"
            ;;

            # ================= SELECT COLUMNS =================
            3) 
                echo
                read -p "Enter column names (comma separated): " input
                IFS=',' read -r -a selected_cols <<< "$input"

                indexes=()
                for sel_col in "${selected_cols[@]}"; do
                    found=0
                    sel_col=${sel_col,,}  # convert to lowercase
                    sel_col=${sel_col// /}  # remove spaces
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

                echo
                printf "%-15s\t" "${selected_cols[@]}"
                echo
                print_separator "${selected_cols[@]}"

                while IFS=: read -r -a row; do
                    for idx in "${indexes[@]}"; do
                        printf "%-15s\t" "${row[idx]}"
                    done
                    echo
                done < "$table_name"
            ;;

            # ================= SELECT COLUMNS WHERE =================
            4) 
            echo
            read -p "Enter column names (comma separated): " input
            IFS=',' read -r -a selected_cols <<< "$input"

            # Convert to lowercase and find indexes
            indexes=()
            for sel_col in "${selected_cols[@]}"; do
                found=0
                sel_col=${sel_col,,}
                sel_col=${sel_col// /}
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

            read -p "Enter condition (column_name = value): " condition
            condition=${condition,,}
            condition=${condition// /}

            if [[ ! "$condition" =~ ^([a-z_][a-z0-9_]*)=([^=]+)$ ]]; then
                echo "Invalid condition format. Use column_name = value."
                return
            else
                where_col="${BASH_REMATCH[1]}"
                where_val="${BASH_REMATCH[2]}"
            fi

            # Find where column index
            where_index=-1
            for i in "${!cols[@]}"; do
                if [[ "${cols[i]}" == "$where_col" ]]; then
                    where_index=$i
                    break
                fi
            done
            [[ $where_index -eq -1 ]] && { echo "Column $where_col does not exist"; return; }

            # Print header
            echo
            printf "%-15s\t" "${selected_cols[@]}"
            echo
            print_separator "${selected_cols[@]}"

            while IFS=: read -r -a row; do
                if [[ "${row[where_index],,}" == "$where_val" ]]; then
                    for idx in "${indexes[@]}"; do
                        printf "%-15s\t" "${row[idx]}"
                    done
                    echo
                fi
            done < "$table_name"


            ;;

            5) return ;;
            *)  echo "Invalid choice!" ;;

        esac
    done

}




















