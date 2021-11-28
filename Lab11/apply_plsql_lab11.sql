/*
||  Name:          apply_plsql_lab11.sql
||  Date:          26 Nov 2021
||  Purpose:       Complete 325 Chapter 12 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
||  Student:       Jay Johnson
*/

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql


-- Open log file.
SPOOL apply_plsql_lab11.txt

/*  ===================================================================================  */

DROP TABLE logger;
DROP SEQUENCE logger_s;
SET SERVEROUTPUT ON SIZE UNLIMITED;

BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'ITEM_INSERT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

ALTER TABLE item
  ADD text_file_name VARCHAR2(40);

COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM'
ORDER BY 2;

/*  ===================================================================================  */

CREATE TABLE logger
( logger_id               NUMBER,
  old_item_id             NUMBER,
  old_item_barcode        VARCHAR2(20),
  old_item_type           NUMBER,
  old_item_title          VARCHAR2(60),
  old_item_subtitle       VARCHAR2(60),
  old_item_rating         VARCHAR2(8),
  old_item_rating_agency  VARCHAR2(4),
  old_item_release_date   DATE,
  old_created_by          NUMBER,
  old_creation_date       DATE,
  old_last_updated_by     NUMBER,
  old_last_update_date    DATE,
  old_text_file_name      VARCHAR2(40),
  new_item_id             NUMBER,
  new_item_barcode        VARCHAR2(20),
  new_item_type           NUMBER,
  new_item_title          VARCHAR2(60),
  new_item_subtitle       VARCHAR2(60),
  new_item_rating         VARCHAR2(8),
  new_item_rating_agency  VARCHAR2(4),
  new_item_release_date   DATE,
  new_created_by          NUMBER,
  new_creation_date       DATE,
  new_last_updated_by     NUMBER,
  new_last_update_date    DATE,
  new_text_file_name      VARCHAR2(40),
  CONSTRAINT logger_pk PRIMARY KEY (logger_id)
);

CREATE SEQUENCE logger_s;

DESC item
DESC logger

/*  ===================================================================================  */

DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'Brave Heart';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP

    -- dbms_output.put_line('item_id: '||i.item_id);
    -- dbms_output.put_line('text_file_name: '||i.text_file_name);

    INSERT INTO logger
    ( logger_id,
      old_item_id,
      old_item_barcode,
      old_item_type,
      old_item_title,
      old_item_subtitle,
      old_item_rating,
      old_item_rating_agency,
      old_item_release_date,
      old_created_by,
      old_creation_date,
      old_last_updated_by,
      old_last_update_date,
      old_text_file_name,
      new_item_id,
      new_item_barcode,
      new_item_type,
      new_item_title,
      new_item_subtitle,
      new_item_rating,
      new_item_rating_agency,
      new_item_release_date,
      new_created_by,
      new_creation_date,
      new_last_updated_by,
      new_last_update_date,
      new_text_file_name
    )
    VALUES
    ( logger_s.NEXTVAL,
      i.item_id,
      i.item_barcode,
      i.item_type,
      i.item_title,
      i.item_subtitle,
      i.item_rating,
      i.item_rating_agency,
      i.item_release_date,
      i.created_by,
      i.creation_date,
      i.last_updated_by,
      i.last_update_date,
      i.text_file_name,
      i.item_id,
      i.item_barcode,
      i.item_type,
      i.item_title,
      i.item_subtitle,
      i.item_rating,
      i.item_rating_agency,
      i.item_release_date,
      i.created_by,
      i.creation_date,
      i.last_updated_by,
      i.last_update_date,
      i.text_file_name
     );

  END LOOP;
END;
/


/* Query the logger table. */
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

/*  ===================================================================================  */

CREATE OR REPLACE PACKAGE manage_item AS
  PROCEDURE item_insert(
    pv_new_item_id             NUMBER,
    pv_new_item_barcode        VARCHAR2,
    pv_new_item_type           NUMBER,
    pv_new_item_title          VARCHAR2,
    pv_new_item_subtitle       VARCHAR2,
    pv_new_item_rating         VARCHAR2,
    pv_new_item_rating_agency  VARCHAR2,
    pv_new_item_release_date   DATE,
    pv_new_created_by          NUMBER,
    pv_new_creation_date       DATE,
    pv_new_last_updated_by     NUMBER,
    pv_new_last_update_date    DATE,
    pv_new_text_file_name      VARCHAR2
  ),

  PROCEDURE item_insert(
    pv_old_item_id             NUMBER,
    pv_old_item_barcode        VARCHAR2,
    pv_old_item_type           NUMBER,
    pv_old_item_title          VARCHAR2,
    pv_old_item_subtitle       VARCHAR2,
    pv_old_item_rating         VARCHAR2,
    pv_old_item_rating_agency  VARCHAR2,
    pv_old_item_release_date   DATE,
    pv_old_created_by          NUMBER,
    pv_old_creation_date       DATE,
    pv_old_last_updated_by     NUMBER,
    pv_old_last_update_date    DATE,
    pv_old_text_file_name      VARCHAR2,
    pv_new_item_id             NUMBER,
    pv_new_item_barcode        VARCHAR2,
    pv_new_item_type           NUMBER,
    pv_new_item_title          VARCHAR2,
    pv_new_item_subtitle       VARCHAR2,
    pv_new_item_rating         VARCHAR2,
    pv_new_item_rating_agency  VARCHAR2,
    pv_new_item_release_date   DATE,
    pv_new_created_by          NUMBER,
    pv_new_creation_date       DATE,
    pv_new_last_updated_by     NUMBER,
    pv_new_last_update_date    DATE,
    pv_new_text_file_name      VARCHAR2
  );

  -- PROCEDURE item_insert(
  --   pv_old_item_id             NUMBER,
  --   pv_old_item_barcode        VARCHAR2,
  --   pv_old_item_type           NUMBER,
  --   pv_old_item_title          VARCHAR2,
  --   pv_old_item_subtitle       VARCHAR2,
  --   pv_old_item_rating         VARCHAR2,
  --   pv_old_item_rating_agency  VARCHAR2,
  --   pv_old_item_release_date   DATE,
  --   pv_old_created_by          NUMBER,
  --   pv_old_creation_date       DATE,
  --   pv_old_last_updated_by     NUMBER,
  --   pv_old_last_update_date    DATE,
  --   pv_old_text_file_name      VARCHAR2
  -- );

END manage_item;
/

CREATE OR REPLACE PACKAGE BODY manage_item AS

  PROCEDURE item_insert(
    pv_new_item_id             NUMBER,
    pv_new_item_barcode        VARCHAR2,
    pv_new_item_type           NUMBER,
    pv_new_item_title          VARCHAR2,
    pv_new_item_subtitle       VARCHAR2,
    pv_new_item_rating         VARCHAR2,
    pv_new_item_rating_agency  VARCHAR2,
    pv_new_item_release_date   DATE,
    pv_new_created_by          NUMBER,
    pv_new_creation_date       DATE,
    pv_new_last_updated_by     NUMBER,
    pv_new_last_update_date    DATE,
    pv_new_text_file_name      VARCHAR2
  ) IS

    lv_logger_id  NUMBER;

  BEGIN
    lv_logger_id := logger_s.NEXTVAL;

    INSERT INTO logger
    ( logger_id,
      old_item_id,
      old_item_barcode,
      old_item_type,
      old_item_title,
      old_item_subtitle,
      old_item_rating,
      old_item_rating_agency,
      old_item_release_date,
      old_created_by,
      old_creation_date,
      old_last_updated_by,
      old_last_update_date,
      old_text_file_name,
      new_item_id,
      new_item_barcode,
      new_item_type,
      new_item_title,
      new_item_subtitle,
      new_item_rating,
      new_item_rating_agency,
      new_item_release_date,
      new_created_by,
      new_creation_date,
      new_last_updated_by,
      new_last_update_date,
      new_text_file_name
    )
    VALUES
    ( logger_s.NEXTVAL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      pv_new_item_id,
      pv_new_item_barcode,
      pv_new_item_type,
      pv_new_item_title,
      pv_new_item_subtitle,
      pv_new_item_rating,
      pv_new_item_rating_agency,
      pv_new_item_release_date,
      pv_new_created_by,
      pv_new_creation_date,
      pv_new_last_updated_by,
      pv_new_last_update_date,
      pv_new_text_file_name
     );
  END item_insert;

  PROCEDURE item_insert(
    pv_old_item_id             NUMBER,
    pv_old_item_barcode        VARCHAR2,
    pv_old_item_type           NUMBER,
    pv_old_item_title          VARCHAR2,
    pv_old_item_subtitle       VARCHAR2,
    pv_old_item_rating         VARCHAR2,
    pv_old_item_rating_agency  VARCHAR2,
    pv_old_item_release_date   DATE,
    pv_old_created_by          NUMBER,
    pv_old_creation_date       DATE,
    pv_old_last_updated_by     NUMBER,
    pv_old_last_update_date    DATE,
    pv_old_text_file_name      VARCHAR2,
    pv_new_item_id             NUMBER,
    pv_new_item_barcode        VARCHAR2,
    pv_new_item_type           NUMBER,
    pv_new_item_title          VARCHAR2,
    pv_new_item_subtitle       VARCHAR2,
    pv_new_item_rating         VARCHAR2,
    pv_new_item_rating_agency  VARCHAR2,
    pv_new_item_release_date   DATE,
    pv_new_created_by          NUMBER,
    pv_new_creation_date       DATE,
    pv_new_last_updated_by     NUMBER,
    pv_new_last_update_date    DATE,
    pv_new_text_file_name      VARCHAR2
  ) IS

    lv_logger_id  NUMBER;

  BEGIN
    lv_logger_id := logger_s.NEXTVAL;

    INSERT INTO logger
    ( logger_id,
      old_item_id,
      old_item_barcode,
      old_item_type,
      old_item_title,
      old_item_subtitle,
      old_item_rating,
      old_item_rating_agency,
      old_item_release_date,
      old_created_by,
      old_creation_date,
      old_last_updated_by,
      old_last_update_date,
      old_text_file_name,
      new_item_id,
      new_item_barcode,
      new_item_type,
      new_item_title,
      new_item_subtitle,
      new_item_rating,
      new_item_rating_agency,
      new_item_release_date,
      new_created_by,
      new_creation_date,
      new_last_updated_by,
      new_last_update_date,
      new_text_file_name
    )
    VALUES
    ( logger_s.NEXTVAL,
      pv_old_item_id,
      pv_old_item_barcode,
      pv_old_item_type,
      pv_old_item_title,
      pv_old_item_subtitle,
      pv_old_item_rating,
      pv_old_item_rating_agency,
      pv_old_item_release_date,
      pv_old_created_by,
      pv_old_creation_date,
      pv_old_last_updated_by,
      pv_old_last_update_date,
      pv_old_text_file_name,
      pv_new_item_id,
      pv_new_item_barcode,
      pv_new_item_type,
      pv_new_item_title,
      pv_new_item_subtitle,
      pv_new_item_rating,
      pv_new_item_rating_agency,
      pv_new_item_release_date,
      pv_new_created_by,
      pv_new_creation_date,
      pv_new_last_updated_by,
      pv_new_last_update_date,
      pv_new_text_file_name
     );
  END item_insert;


END manage_item;
/

/*  ===================================================================================  */

DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'King Arthur';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP

      manage_item.item_insert(
      pv_new_item_id => i.item_id,
      pv_new_item_barcode => i.item_barcode,
      pv_new_item_type => i.item_type,
      pv_new_item_title => i.item_title || '-Inserted',
      pv_new_item_subtitle => i.item_subtitle,
      pv_new_item_rating => i.item_rating,
      pv_new_item_rating_agency => i.item_rating_agency,
      pv_new_item_release_date => i.item_release_date,
      pv_new_created_by => i.created_by,
      pv_new_creation_date => i.creation_date,
      pv_new_last_updated_by => i.last_updated_by,
      pv_new_last_update_date => i.last_update_date,
      pv_new_text_file_name =>i.text_file_name
    );

    manage_item.item_insert(
      pv_old_item_id => i.item_id,
      pv_old_item_barcode => i.item_barcode,
      pv_old_item_type => i.item_type,
      pv_old_item_title => i.item_title,
      pv_old_item_subtitle => i.item_subtitle,
      pv_old_item_rating => i.item_rating,
      pv_old_item_rating_agency => i.item_rating_agency,
      pv_old_item_release_date => i.item_release_date,
      pv_old_created_by => i.created_by,
      pv_old_creation_date => i.creation_date,
      pv_old_last_updated_by => i.last_updated_by,
      pv_old_last_update_date => i.last_update_date,
      pv_old_text_file_name => i.text_file_name,
      pv_new_item_id => i.item_id,
      pv_new_item_barcode => i.item_barcode,
      pv_new_item_type => i.item_type,
      pv_new_item_title => i.item_title || '-Changed',
      pv_new_item_subtitle => i.item_subtitle,
      pv_new_item_rating => i.item_rating,
      pv_new_item_rating_agency => i.item_rating_agency,
      pv_new_item_release_date => i.item_release_date,
      pv_new_created_by => i.created_by,
      pv_new_creation_date => i.creation_date,
      pv_new_last_updated_by => i.last_updated_by,
      pv_new_last_update_date => i.last_update_date,
      pv_new_text_file_name =>i.text_file_name
    );

  END LOOP;
END;
/

SHOW ERRORS

/*  ===================================================================================  */

/* Query the logger table. */
/* Query the logger table. */
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

/*  ===================================================================================  */


/*  ===================================================================================  */

-- Close log file.
SPOOL OFF

QUIT;
/