/*
||  Name:          apply_plsql_lab8.sql
||  Date:          05 Nov 2021
||  Purpose:       Complete 325 Chapter 9 lab.
||  Student:       Jay Johnson
*/

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

SPOOL apply_plsql_lab8.txt;

/*  ===================================================================================  */
CREATE OR REPLACE PACKAGE contact_package IS

  PROCEDURE insert_contact  (
    pv_first_name         VARCHAR2,
    pv_middle_name        VARCHAR2,
    pv_last_name          VARCHAR2,
    pv_contact_type       VARCHAR2,
    pv_account_number     VARCHAR2,
    pv_member_type        VARCHAR2,
    pv_credit_card_number VARCHAR2,
    pv_credit_card_type   VARCHAR2,
    pv_city               VARCHAR2,
    pv_state_province     VARCHAR2,
    pv_postal_code        VARCHAR2,
    pv_address_type       VARCHAR2,
    pv_country_code       VARCHAR2,
    pv_area_code          VARCHAR2,
    pv_telephone_number   VARCHAR2,
    pv_telephone_type     VARCHAR2,
    pv_user_name          VARCHAR2
  );


  -- PROCEDURE insert_contact  (
  --   pv_first_name         VARCHAR2,
  --   pv_middle_name        VARCHAR2,
  --   pv_last_name          VARCHAR2,
  --   pv_contact_type       VARCHAR2,
  --   pv_account_number     VARCHAR2,
  --   pv_member_type        VARCHAR2,
  --   pv_credit_card_number VARCHAR2,
  --   pv_credit_card_type   VARCHAR2,
  --   pv_city               VARCHAR2,
  --   pv_state_province     VARCHAR2,
  --   pv_postal_code        VARCHAR2,
  --   pv_address_type       VARCHAR2,
  --   pv_country_code       VARCHAR2,
  --   pv_telephone_number   VARCHAR2,
  --   pv_telephone_type     VARCHAR2,
  --   pv_user_id            NUMBER DEFAULT NULL
  -- );

END contact_package;
/

/*  ===================================================================================  */
CREATE OR REPLACE PACKAGE BODY contact_package IS

  PROCEDURE insert_contact
  (
    pv_first_name         VARCHAR2,
    pv_middle_name        VARCHAR2,
    pv_last_name          VARCHAR2,
    pv_contact_type       VARCHAR2,
    pv_account_number     VARCHAR2,
    pv_member_type        VARCHAR2,
    pv_credit_card_number VARCHAR2,
    pv_credit_card_type   VARCHAR2,
    pv_city               VARCHAR2,
    pv_state_province     VARCHAR2,
    pv_postal_code        VARCHAR2,
    pv_address_type       VARCHAR2,
    pv_country_code       VARCHAR2,
    pv_area_code          VARCHAR2,
    pv_telephone_number   VARCHAR2,
    pv_telephone_type     VARCHAR2,
    pv_user_name          VARCHAR2
  ) IS

    lv_address_type       VARCHAR2(30);
    lv_contact_type       VARCHAR2(30);
    lv_credit_card_type   VARCHAR2(30);
    lv_member_type        VARCHAR2(30);
    lv_telephone_type     VARCHAR2(30);
    lv_user_id            NUMBER;
    pv_created_by         NUMBER :=1;
    pv_creation_date      DATE :=SYSDATE;
    pv_last_updated_by    NUMBER :=1;
    pv_last_update_date   DATE :=SYSDATE;

    FUNCTION get_id (pv_user_name VARCHAR2)  RETURN NUMBER IS
      lv_get_id NUMBER := 0;

      CURSOR get_system_user_id (cv_user_name VARCHAR2) IS
        SELECT system_user_id
        FROM system_user
        WHERE system_user_name = cv_user_name;

      BEGIN

        FOR i IN get_system_user_id(pv_user_name) LOOP
          lv_get_id := i.system_user_id;
        END LOOP;

        RETURN lv_get_id;

    END get_id;

    BEGIN
      lv_address_type     := pv_address_type;
      lv_contact_type     := pv_contact_type;
      lv_credit_card_type := pv_credit_card_type;
      lv_member_type      := pv_member_type;
      lv_telephone_type   := pv_telephone_type;

      SAVEPOINT starting;

      lv_user_id := get_id(pv_user_name);

      IF lv_user_id = 0 THEN

        INSERT INTO system_user
        ( system_user_id,
          system_user_name,
          system_user_group_id,
          system_user_type,
          first_name,
          middle_name,
          last_name,
          created_by,
          creation_date,
          last_updated_by,
          last_update_date )
        VALUES
        ( system_user_s1.NEXTVAL,
          pv_user_name,
          1,
          'DBA',
          pv_first_name,
          pv_middle_name,
          pv_last_name,
          pv_created_by,
          pv_creation_date,
          pv_last_updated_by,
          pv_last_update_date
        );

        lv_user_id := system_user_s1.CURRVAL;

        INSERT INTO member
        ( member_id,
          member_type,
          account_number,
          credit_card_number,
          credit_card_type,
          created_by,
          creation_date,
          last_updated_by,
          last_update_date
        )
        VALUES
        (
          member_s1.NEXTVAL,
          ( SELECT   common_lookup_id
            FROM     common_lookup
            WHERE    common_lookup_table = 'MEMBER'
            AND      common_lookup_column = 'MEMBER_TYPE'
            AND      common_lookup_type = lv_member_type),
          pv_account_number,
          pv_credit_card_number,
          ( SELECT   common_lookup_id
            FROM     common_lookup
            WHERE    common_lookup_table = 'MEMBER'
            AND      common_lookup_column = 'CREDIT_CARD_TYPE'
            AND      common_lookup_type = lv_credit_card_type),
          lv_user_id,
          pv_creation_date,
          lv_user_id,
          pv_last_update_date
        );

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
        SHOW ERRORS;
      END IF;

      SHOW ERRORS;

    EXCEPTION
      WHEN OTHERS THEN
        SHOW ERRORS;
        ROLLBACK TO starting;
  END insert_contact;

  SHOW ERRORS;

END contact_package;


/*  ===================================================================================  */
-- DESC contact_package;

-- DESC system_user;

/*  ===================================================================================  */

BEGIN

  contact_package.insert_contact(
    pv_first_name         => 'Charlie',
    pv_middle_name        => NULL,
    pv_last_name          => 'Brown',
    pv_contact_type       => 'CUSTOMER',
    pv_account_number     => 'SLC-000011',
    pv_member_type        => 'GROUP',
    pv_credit_card_number => '8888-6666-8888-4444',
    pv_credit_card_type   => 'VISA_CARD',
    pv_city               => 'Lehi',
    pv_state_province     => 'Utah',
    pv_postal_code        => '84043',
    pv_address_type       => 'HOME',
    pv_country_code       => '001',
    pv_area_code          => '207',
    pv_telephone_number   => '877-4321',
    pv_telephone_type     => 'HOME',
    pv_user_name          => 'DBA 3'
  );

END;
/

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
WHERE  c.last_name IN ('Brown','Patty');



/*  ===================================================================================  */
-- Close log file.
SPOOL OFF

QUIT;
/