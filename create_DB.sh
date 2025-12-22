#!/bin/bash


create_Database() {
	
	if [[ ! -d "$databaseDir" ]]; then
		mkdir -p "$databaseDir"
	fi

	while true; do 
		read -p "Please enter the Database Name or type exit to return to the Main Menu: " databaseName
		databaseName=${databaseName,,}

		if [[ $databaseName == "exit" ]]; then
			echo -e "\nReturn to Main Menu\n"
			
			return
		fi


		#1.Reserved Words
		if [[ "$databaseName" == "databases" || 
		      "$databaseName" == "select" || 
		      "$databaseName" == "update" || 
      		      "$databaseName" == "delete" || 
		      "$databaseName" == "insert" || 
		      "$databaseName" == "drop" || 
      		      "$databaseName" == "truncate" ]]; then 
				      echo -e "\nInvalid database name. '$databaseName' is a reserved keyword\n"
				      continue #go back to the loop
		fi
		
		#2.Not Empty
		if [[ -z "$databaseName" ]]; then
			echo -e "\nDatabase name cannot be empty!\n"
			continue   
		fi
		
		#3.Database Exist
		if [[ -d "$databaseDir/$databaseName" ]]; then
			echo -e "\nDatabase '$databaseName' already exists. Choose another Name!\n"
			continue
		fi
		

		#4.Valid Name
		if [[ ! "$databaseName" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
    		echo -e "\nInvalid database name. Use letters, numbers, and underscores only.\n"
    		continue
		fi

		mkdir -p "$databaseDir/$databaseName"
		echo -e "\nDatabase '$databaseName' created.\n"

		break
	done


}
