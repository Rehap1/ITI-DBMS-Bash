# ITI-DBMS-Bash
Database Management System using Bash Script

A **Bash-based Mini DBMS project** that simulates core database operations using shell scripting and file system storage. This project is designed for **learning purposes**, focusing on **Linux, Bash scripting, Git, and basic DBMS concepts**.

---
## 📂 Project Structure
```
ShellScriptDB/
├── main.sh               # Main menu script
├── create_DB.sh          # Create database function
├── list_DB.sh            # List databases
├── connect_DB.sh         # Connect to a database
├── drop_DB.sh            # Drop database
├── create_table.sh       # Table creation logic
├── insert_table.sh       # Insert row into table
├── select_table.sh       # Select/query table data
├── update_table.sh       # Update table rows
├── delete_table.sh       # Delete table rows
└── databases/            # Folder containing created databases
|
├── .gitignore           # Ignored files and directories
└── README.md            # Project documentation
```
---

## Features

- **Database Management**
  - Create a database
  - List all databases
  - Connect to a database
  - Drop a database (with confirmation prompt)

- **Table Management**
  - Create tables with customizable columns
  - Set the **first column as primary key** (int or string)
  - Define column data types: `int`, `string`, `bool`

- **Data Manipulation**
  - Insert rows into tables
  - Update rows with conditions
  - Delete rows with or without conditions
  - Select data:
    - Select all columns
    - Select specific columns
    - Select rows based on conditions
    - Combination of columns + condition
---

## Installation
1. Clone the repository:
    - git clone https://github.com/Rehap1/ITI-DBMS-Bash.git
    - cd ITI-DBMS-Bash

2. Make the main script executable:
    - chmod +x main.sh

3. Run the main menu:
    - ./main.sh

---

## Notes

- All database and table names are converted to lowercase automatically.

- Primary key uniqueness is enforced.

- Input validation is performed for:

    - Database/table names

    - Column names

    - Column data types

    - SQL-like conditions


 