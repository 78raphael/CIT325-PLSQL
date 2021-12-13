-- ======================================================================
--  Name:    base_t.sql
--  Author:  Michael McLaughlin
--  Date:    02-Apr-2020
-- ------------------------------------------------------------------
--  Purpose: Prepare final project environment.
-- ======================================================================

-- DROP TYPE dwarf_t FORCE;
-- DROP TYPE goblin_t FORCE;
-- DROP TYPE hobbit_t FORCE;
-- DROP TYPE maia_t FORCE;
-- DROP TYPE man_t FORCE;
-- DROP TYPE orc_t FORCE;
-- DROP TYPE noldor_t FORCE;
-- DROP TYPE silvan_t FORCE;
-- DROP TYPE teleri_t FORCE;
-- DROP TYPE noldor_t FORCE;

-- DROP TYPE elf_t FORCE;
DROP TYPE base_t FORCE;


-- Open log file.
SPOOL base_t.txt

CREATE OR REPLACE TYPE base_t IS OBJECT
    ( oid   NUMBER,
      oname VARCHAR2(30),

    CONSTRUCTOR FUNCTION base_t
    ( oid   NUMBER,
      oname VARCHAR2)
    RETURN SELF AS RESULT,

    MEMBER FUNCTION get_oname RETURN VARCHAR2,
    MEMBER PROCEDURE set_oname
    ( oname  VARCHAR2 ),
    MEMBER FUNCTION get_name RETURN VARCHAR2,
    MEMBER FUNCTION to_string RETURN VARCHAR2 )
  INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE
  TYPE BODY base_t IS

  CONSTRUCTOR FUNCTION base_t
  ( oid   NUMBER
  , oname VARCHAR2 )
  RETURN SELF AS RESULT IS
  BEGIN
    self.oid := oid;
    self.oname := oname;
    RETURN;
  END base_t;

  MEMBER FUNCTION get_oname
    RETURN VARCHAR2 IS
    BEGIN
      RETURN self.oname;
    END get_oname;

  MEMBER PROCEDURE set_oname
    ( oname  VARCHAR2 ) IS
    BEGIN
      self.oname := oname;
    END set_oname;

  MEMBER FUNCTION get_name
    RETURN VARCHAR2 IS
    BEGIN
      RETURN NULL;
    END get_name;

  MEMBER FUNCTION to_string
    RETURN VARCHAR2 IS
    BEGIN
      RETURN '['||self.oid||']';
    END to_string;
END;
/

SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  lv_object  BASE_T := base_t(1,'BASE_T');
BEGIN
  dbms_output.put_line(lv_object.to_string);
END;
/

SHOW ERRORS
DESC base_t

-- Close log file.
SPOOL OFF

-- Quit SQL*Plus session.
QUIT;
/