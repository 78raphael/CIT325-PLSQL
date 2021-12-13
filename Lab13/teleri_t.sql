DROP TYPE teleri_t;


CREATE OR REPLACE
  TYPE teleri_t UNDER elf_t
  ( elfkind    VARCHAR2(30),

    CONSTRUCTOR FUNCTION teleri_t
    ( elfkind  VARCHAR2 )
    RETURN SELF AS RESULT,

    MEMBER FUNCTION get_elfkind RETURN VARCHAR2,
    MEMBER PROCEDURE set_elfkind(elfkind VARCHAR2),
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2,
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 )
  INSTANTIABLE NOT FINAL;
/


CREATE OR REPLACE TYPE BODY teleri_t IS

  CONSTRUCTOR FUNCTION teleri_t
    ( elfkind  VARCHAR2 )
    RETURN SELF AS RESULT IS
    BEGIN
      self.elfkind := elfkind;
      RETURN;
    END teleri_t;

  OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
      RETURN self.name;
    END get_name;

  MEMBER FUNCTION get_elfkind
    RETURN VARCHAR2 IS
    BEGIN
      RETURN self.elfkind;
    END get_elfkind;

  MEMBER PROCEDURE set_elfkind
  ( elfkind VARCHAR2  ) IS
  BEGIN
    self.elfkind := elfkind;
  END set_elfkind;

  OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN (self AS base_t).to_string||'['||self.name||']['||self.genus||']['||self.elfkind||']';
    END to_string;
END;
/

SHOW ERRORS
DESC teleri_t


QUIT;
/