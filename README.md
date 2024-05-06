# Sequence Trigger Pair for all Schema's Tables PLSQL

## Description
This PLSQL script automates the creation of sequence/trigger pairs for each table within a database schema that lacks them. It addresses the challenge of managing primary key values across multiple tables by automatically generating unique sequences and triggers for each table with a primary key ending with "_ID". This simplifies database management and enhances data integrity.

## How it Works
The script employs a cursor to identify relevant tables and columns. It drops any existing sequences and then creates new sequence/trigger pairs with starting values based on the current maximum value in the primary key column.

## Project Goals
- Simplify database management.
- Ensure data integrity.

## Tools and Technologies
- PLSQL
- Sequences
- Triggers
- TOAD

## Usage
1. Modify the script according to specific schema requirements.
2. Execute the script to automate sequence/trigger creation for each relevant table.

