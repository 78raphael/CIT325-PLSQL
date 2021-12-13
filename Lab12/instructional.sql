/*  ===================================================================================  */

-- Call seeding libraries.
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

/*  ===================================================================================  */

CREATE OR REPLACE
  TYPE contact_obj IS OBJECT
  ( first_name   VARCHAR2(20)
  , middle_name  VARCHAR2(20)
  , last_name    VARCHAR2(20));
/

/*  ===================================================================================  */

CREATE OR REPLACE
  TYPE contact_tab IS TABLE of contact_obj;
/

/*  ===================================================================================  */
  
CREATE OR REPLACE
  FUNCTION customer_list
  ( pv_last_name  VARCHAR2 ) RETURN contact_tab IS

    /* Declare a record type. */
    TYPE customer_rec IS RECORD
    ( first_name   VARCHAR2(20)
    , middle_name  VARCHAR2(20)
    , last_name    VARCHAR2(20));

    /* Declare reference cursor for an NDS cursor. */
    customer_cur   SYS_REFCURSOR;

    /* Declare a customer row for output from an NDS cursor. */
    customer_row   CUSTOMER_REC;
    customer_set   CONTACT_TAB := contact_tab();

    /* Declare dynamic statement. */
    stmt  VARCHAR2(2000);
  BEGIN
    /* Create a dynamic statement. */
    stmt := 'SELECT first_name, middle_name, last_name '
         || 'FROM   contact '
         || 'WHERE  REGEXP_LIKE(last_name,''^.*''||:input||''.*$'')';

    /* Open and read dynamic cursor. */
    OPEN customer_cur FOR stmt USING pv_last_name;
    LOOP
      /* Fetch the cursror into a customer row. */
      FETCH customer_cur INTO customer_row;
      EXIT WHEN customer_cur%NOTFOUND;

      /* Extend space and assign a value collection. */
      customer_set.EXTEND;
      customer_set(customer_set.COUNT) :=
        contact_obj( first_name  => customer_row.first_name
                   , middle_name => customer_row.middle_name
                   , last_name   => customer_row.last_name );
    END LOOP;

    /* Return customer set. */
    RETURN customer_set;
  END customer_list;
/

/*  ===================================================================================  */

COL last_name   FORMAT A12 HEADING "Last Name"
COL first_name  FORMAT A12 HEADING "First Name"
COL middle_name FORMAT A12 HEADING "Middle Name"
SELECT   il.last_name
,        il.first_name
,        il.middle_name
FROM     TABLE(customer_list('Potter')) il
ORDER BY 1, 2, 3;

/*  ===================================================================================  */