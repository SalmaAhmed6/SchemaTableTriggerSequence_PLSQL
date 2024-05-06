set serveroutput on size 1000000

declare
max_n number(30) ;

-- tables cursor
cursor tables_cursor is 
         SELECT a.OBJECT_NAME AS TABLE_NAME, MIN(c.column_name) AS pk_column
        FROM ALL_OBJECTS a
        JOIN all_cons_columns c ON a.OBJECT_NAME = c.TABLE_NAME
        WHERE a.OWNER = 'HR'
          AND a.OBJECT_TYPE = 'TABLE'
          AND c.constraint_name IN (SELECT constraint_name FROM all_constraints WHERE CONSTRAINT_TYPE = 'P')
        GROUP BY a.OBJECT_NAME
        HAVING COUNT(c.column_name) = 1  -- Only consider tables with a single-column primary key
           AND MIN(c.column_name) NOT IN (SELECT column_name FROM user_tab_columns WHERE data_type <> 'NUMBER');

 
                            

-- sequence names cursor
cursor sequence_name_cursor is 
    select sequence_name from user_sequences;
    
Begin

        -- drop all sequences
        for sequence_name_record in sequence_name_cursor loop
                Execute immediate '
                 drop sequence '||sequence_name_record.sequence_name;
            end loop;      
            
               
            
        for t_record in tables_cursor loop
                -- Get Maximum ID
                    EXECUTE IMMEDIATE '
                    SELECT (NVL(MAX('||t_record.pk_column||'),0)+1) 
                    FROM HR.' || t_record.table_name
                    INTO max_n;

                -- Create sequence for the table
                Execute immediate '
                 CREATE SEQUENCE '||t_record.table_name||'_SEQ
                  START WITH '||max_n||'
                  INCREMENT BY 1
                  NOCYCLE
                  CACHE 20
                  NOORDER';
                  
                  -- Create Trigger
                Execute immediate'
                CREATE OR REPLACE TRIGGER '||t_record.table_name||'_tr
                BEFORE INSERT
                ON HR.'||t_record.table_name||'
                REFERENCING NEW AS New OLD AS Old
                FOR EACH ROW
                BEGIN
                  :new.'||t_record.pk_column||' := '||t_record.table_name||'_SEQ.nextval;
                        END;';
           
                        dbms_output.put_line('table_name:'||t_record.table_name||'    pk_column:'||t_record.pk_column||'   max_n:'|| max_n);
            end loop;             
end;