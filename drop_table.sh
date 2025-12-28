#!/bin/bash

source ./list_table.sh

drop_table() {
   # Optional: show tables first (same style as insert_table)
   if declare -f list_tables >/dev/null 2>&1; then
       list_tables
   fi
   read -r -p "Enter table name to drop: " table_name
   table_name=${table_name,,}  # convert to lowercase
   # empty check
   if [[ -z "$table_name" ]]; then
       echo -e "\nTable name cannot be empty!\n"
       return
   fi
   # Validate table name (same as create_table)
   if [[ ! "$table_name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
       echo -e "\nInvalid table name!\n"
       return
   fi
   table_file="$table_name"
   meta_file=".$table_name.meta"
   # Check existence (table + meta)
   if [[ ! -f "$table_file" || ! -f "$meta_file" ]]; then
       echo -e "\nTable '$table_name' does not exist.\n"
       return
   fi
   # Confirmation
   read -p "Are you sure you want to drop table '$table_name'? This action cannot be undone. (y/n): " confirm
   if [[ "$confirm" == "yes" || "$confirm" == "y" ]]; then
       rm -f "$table_file" "$meta_file"
       echo -e "\nTable '$table_name' dropped successfully.\n"
   else
       echo -e "\nDrop table canceled.\n"
   fi
}
