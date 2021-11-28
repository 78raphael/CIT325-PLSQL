/*
||  Name:          apply_plsql_lab10.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 11 lab
||  Student:       Jay Johnson
*/

-- Open log file.
SPOOL apply_plsql_lab10.txt;

/*  ===================================================================================  */
DROP TABLE logger;
DROP TYPE base_t FORCE;
SET SERVEROUTPUT ON SIZE UNLIMITED;

CREATE OR REPLACE
  TYPE base_t IS OBJECT
  ( oname VARCHAR2(30)
  , name  VARCHAR2(30)
  , CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT
  , CONSTRUCTOR FUNCTION base_t
    ( oname  VARCHAR2
    , name   VARCHAR2 ) RETURN SELF AS RESULT
  , MEMBER FUNCTION get_name RETURN VARCHAR2
  , MEMBER FUNCTION get_oname RETURN VARCHAR2
  , MEMBER PROCEDURE set_oname (oname VARCHAR2)
  , MEMBER FUNCTION to_string RETURN VARCHAR2)
  INSTANTIABLE NOT FINAL;
/

CREATE TABLE logger(
  logger_id NUMBER,
  log_text  BASE_T
);

CREATE SEQUENCE logger_s;


CREATE OR REPLACE
  TYPE BODY base_t IS

    CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT IS
    BEGIN
      SELF.oname := 'BASE_T';
      RETURN;
    END;

    CONSTRUCTOR FUNCTION base_t
    ( oname  VARCHAR2
    , name   VARCHAR2 ) RETURN SELF AS RESULT IS
    BEGIN
      SELF.oname := oname;
      SELF.name := name;

      RETURN;
    END;

    MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
      RETURN SELF.name;
    END get_name;

    MEMBER FUNCTION get_oname RETURN VARCHAR2 IS
    BEGIN
      RETURN SELF.oname;
    END get_oname;

    MEMBER PROCEDURE set_oname
    ( oname VARCHAR2 ) IS
    BEGIN
      SELF.oname := oname;
    END set_oname;

    MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN '['||SELF.oname||']';
    END to_string;
  END;
/

/*  ===================================================================================  */

SHOW ERRORS

DESC base_t
DESC logger

/*  ===================================================================================  */

DECLARE
  lv_instance  BASE_T := base_t();
BEGIN

  dbms_output.put_line('Default  : ['||lv_instance.get_oname()||']');

  lv_instance.set_oname('SUBSTITUTE');

  dbms_output.put_line('Override : ['||lv_instance.get_oname()||']');
END;
/

/*  ===================================================================================  */

INSERT INTO logger
VALUES (logger_s.NEXTVAL, base_t());

DECLARE
  lv_base  BASE_T;

BEGIN

  lv_base := base_t(
      oname => 'BASE_T'
    , name => 'NEW' );

    INSERT INTO logger
    VALUES (logger_s.NEXTVAL, lv_base);

    COMMIT;
END;
/

COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      NVL(t.log.get_name(),'Unset') AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname = 'BASE_T';

/*  ===================================================================================  */

/*  ===================================================================================  */

DROP TYPE item_t FORCE;
DROP TYPE contact_t FORCE;

CREATE OR REPLACE
  TYPE item_t UNDER base_t
  ( item_id             NUMBER,
    item_barcode        VARCHAR2(20),
    item_type           NUMBER,
    item_title          VARCHAR2(60),
    item_subtitle       VARCHAR2(60),
    item_rating         VARCHAR2(8),
    item_rating_agency  VARCHAR2(4),
    item_release_date   DATE,
    created_by          NUMBER,
    creation_date       DATE,
    last_updated_by     NUMBER,
    last_updated_date   DATE,

    CONSTRUCTOR FUNCTION item_t
    ( oname               VARCHAR2,
      name                VARCHAR2,
      item_id             NUMBER,
      itme_barcode        VARCHAR2,
      item_type           NUMBER,
      item_title          VARCHAR2,
      item_subtitle       VARCHAR2,
      item_rating         VARCHAR2,
      item_rating_agency  VARCHAR2,
      item_release_date   DATE,
      created_by          NUMBER,
      creation_date       DATE,
      last_updated_by     NUMBER,
      last_updated_date   DATE
    )  RETURN SELF AS RESULT,
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2,
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2
  )
  INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE
  TYPE contact_t UNDER base_t
  ( contact_id        NUMBER,
    member_id         NUMBER,
    contact_type      NUMBER,
    first_name        VARCHAR2(60),
    middle_name       VARCHAR2(60),
    last_name         VARCHAR2(8),
    created_by        NUMBER,
    creation_date     DATE,
    last_updated_by   NUMBER,
    last_updated_date DATE,

    CONSTRUCTOR FUNCTION contact_t
    ( oname               VARCHAR2,
      name                VARCHAR2,
      contact_id          NUMBER,
      member_id           NUMBER,
      contact_type        NUMBER,
      first_name          VARCHAR2,
      middle_name         VARCHAR2,
      last_name           VARCHAR2,
      created_by          NUMBER,
      creation_date       DATE,
      last_updated_by     NUMBER,
      last_updated_date   DATE
    )  RETURN SELF AS RESULT,
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2,
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2
  )
  INSTANTIABLE NOT FINAL;
/

/*  ===================================================================================  */

DESC item_t
DESC contact_t

/*  ===================================================================================  */

/*  ===================================================================================  */

/*  ===================================================================================  */

COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      t.log.get_name() AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname IN ('CONTACT_T','ITEM_T');

/*  ===================================================================================  */
-- Close log file.
SPOOL OFF;

QUIT;
/