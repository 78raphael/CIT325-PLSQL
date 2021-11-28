/*
||  Name:          apply_plsql_lab7.sql
||  Date:          29 Oct 2021
||  Purpose:       Complete 325 Chapter 8 lab.
||  Name:          Jay Johnson
*/

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab7.txt

-- Enter your solution here.
/*  ===================================================================================  */
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name = 'DBA';

UPDATE system_user
SET    system_user_name = 'DBA'
WHERE  system_user_name LIKE 'DBA%';


DECLARE
  /* Create a local counter variable. */
  lv_counter  NUMBER := 2;

  /* Create a collection of two-character strings. */
  TYPE numbers IS TABLE OF NUMBER;

  /* Create a variable of the roman_numbers collection. */
  lv_numbers  NUMBERS := numbers(1,2,3,4);

BEGIN
  /* Update the system_user names to make them unique. */
  FOR i IN 1..lv_numbers.COUNT LOOP
    /* Update the system_user table. */
    UPDATE system_user
    SET    system_user_name = system_user_name || ' ' || lv_numbers(i)
    WHERE  system_user_id = lv_counter;

    /* Increment the counter. */
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/

SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name LIKE 'DBA%';
/*  ===================================================================================  */

BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE insert_contact
( pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2 := ''
, pv_last_name           VARCHAR2
, pv_contact_type        VARCHAR2
, pv_account_number      VARCHAR2
, pv_member_type         VARCHAR2
, pv_credit_card_number  VARCHAR2
, pv_credit_card_type    VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_address_type        VARCHAR2
, pv_country_code        VARCHAR2
, pv_area_code           VARCHAR2
, pv_telephone_number    VARCHAR2
, pv_telephone_type      VARCHAR2
, pv_creation_date       DATE     := SYSDATE
, pv_last_update_date    DATE     := SYSDATE
, pv_user_name           VARCHAR2 ) IS

  -- Local variables, to leverage subquery assignments in INSERT statements.
  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30);
  lv_user_id             NUMBER;

  CURSOR find_user_id
    (pv_user_name VARCHAR2) IS
    SELECT system_user_id
    FROM system_user
    WHERE system_user_name = pv_user_name;

BEGIN
--  dbms_output.put_line('Getting this far');
  -- Assign parameter values to local variables for nested assignments to DML subqueries.
  lv_address_type := pv_address_type;
  lv_contact_type := pv_contact_type;
  lv_credit_card_type := pv_credit_card_type;
  lv_member_type := pv_member_type;
  lv_telephone_type := pv_telephone_type;

  FOR i IN find_user_id(pv_user_name) LOOP
    lv_user_id := i.system_user_id;
  END LOOP;

--  dbms_output.put_line('lv_user_id: '||lv_user_id);



  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;

  INSERT INTO member
  ( member_id
  , member_type
  , account_number
  , credit_card_number
  , credit_card_type
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date )
  VALUES
  ( member_s1.NEXTVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'MEMBER'
    AND      common_lookup_column = 'MEMBER_TYPE'
    AND      common_lookup_type = lv_member_type)
  , pv_account_number
  , pv_credit_card_number
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'MEMBER'
    AND      common_lookup_column = 'CREDIT_CARD_TYPE'
    AND      common_lookup_type = lv_credit_card_type)
  , lv_user_id
  , pv_creation_date
  , lv_user_id
  , pv_last_update_date );

  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , middle_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( contact_s1.NEXTVAL
  , member_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'CONTACT'
    AND      common_lookup_column = 'CONTACT_TYPE'
    AND      common_lookup_type = lv_contact_type)
  , pv_last_name
  , pv_first_name
  , pv_middle_name
  , lv_user_id
  , pv_creation_date
  , lv_user_id
  , pv_last_update_date );

  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'ADDRESS'
    AND      common_lookup_column = 'ADDRESS_TYPE'
    AND      common_lookup_type = lv_address_type)
  , pv_city
  , pv_state_province
  , pv_postal_code
  , lv_user_id
  , pv_creation_date
  , lv_user_id
  , pv_last_update_date );

  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL
  , contact_s1.CURRVAL
  , address_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'TELEPHONE'
    AND      common_lookup_column = 'TELEPHONE_TYPE'
    AND      common_lookup_type = lv_telephone_type)
  , pv_country_code
  , pv_area_code
  , pv_telephone_number
  , lv_user_id
  , pv_creation_date
  , lv_user_id
  , pv_last_update_date);

  COMMIT;

-- EXCEPTION
--   WHEN OTHERS THEN
--     ROLLBACK TO starting_point;
--     RETURN;
END insert_contact;
/

-- Display any compilation errors.
SHOW ERRORS

BEGIN
  insert_contact(
    pv_first_name         => 'Charles',
    pv_middle_name        => 'Francis',
    pv_last_name          => 'Xavier',
    pv_contact_type       => 'CUSTOMER',
    pv_account_number     => 'SLC-000008',
    pv_member_type        => 'INDIVIDUAL',
    pv_credit_card_number => '7777-6666-5555-4444',
    pv_credit_card_type   => 'DISCOVER_CARD',
    pv_city               => 'Milbridge',
    pv_state_province     => 'Maine',
    pv_postal_code        => '04658',
    pv_address_type       => 'HOME',
    pv_country_code       => '001',
    pv_area_code          => '207',
    pv_telephone_number   => '111-1234',
    pv_telephone_type     => 'HOME',
    pv_user_name          => 'DBA 2'
  );
END;
/

--DESC common_lookup

--DESC member

--DESC contact

--DESC address

--DESC telephone

--DESC system_user


/*  ===================================================================================  */
COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Xavier';

/*  ===================================================================================  */



/*  ===================================================================================  */



/*  ===================================================================================  */

-- Close log file.
SPOOL OFF

QUIT;
/