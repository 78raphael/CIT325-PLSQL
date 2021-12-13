CREATE OR REPLACE
  TYPE order_subcomp UNDER order_comp
    ( subtitle  VARCHAR2(20)
    , CONSTRUCTOR FUNCTION order_subcomp
    ( who       VARCHAR2
    , movie     VARCHAR2
    , subtitle  VARCHAR2)
    RETURN SELF AS RESULT
    , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 )
    INSTANTIABLE FINAL;
/


CREATE OR REPLACE TYPE BODY order_subcomp IS

  /* Implement a default constructor. */
  CONSTRUCTOR FUNCTION order_subcomp
    ( who       VARCHAR2
    , movie     VARCHAR2
    , subtitle  VARCHAR2)
    RETURN SELF AS RESULT IS
    BEGIN
      self.who := who;
      self.movie := movie;
      self.subtitle := subtitle;
      RETURN;
    END order_subcomp;

  /* Implement an overriding to_string function with
     generalized invocation. */
  OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN (self AS order_comp).to_string||'['||self.subtitle||']';
    END to_string;
END;
/


SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  lv_order  ORDER_COMP := order_subcomp('Clark Kent','Superman','The Quest for Peace');
BEGIN
  dbms_output.put_line(lv_order.to_string);
END;
/