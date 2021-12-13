/*
||  Name:          apply_plsql_lab12.sql
||  Date:          3 Dec 2021
||  Purpose:       Complete 325 Chapter 13 lab
||  Student:       Jay Johnson
*/

-- Call seeding libraries.
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab12.txt

/*  ===================================================================================  */

SET SERVEROUTPUT ON SIZE UNLIMITED;

CREATE OR REPLACE TYPE item_obj IS OBJECT
(
  title         VARCHAR2(60),
  subtitle      VARCHAR2(60),
  rating        VARCHAR2(8),
  release_date  DATE
);
/


CREATE OR REPLACE TYPE item_tab IS TABLE OF item_obj;
/


CREATE OR REPLACE FUNCTION item_list
  (
    pv_start_date DATE,
    pv_end_date   DATE DEFAULT TRUNC(SYSDATE + 1)
  )
  RETURN item_tab IS

    TYPE item_rec IS RECORD
    (
      title         VARCHAR2(60),
      subtitle      VARCHAR2(60),
      rating        VARCHAR2(8),
      release_date  DATE
    );

    item_cur  SYS_REFCURSOR;
    item_row  ITEM_REC;
    item_set  ITEM_TAB := item_tab();

    stmt  VARCHAR2(2000);

  BEGIN

    stmt := 'SELECT item_title title, item_subtitle subtitle, '
        ||  'item_rating rating, item_release_date release_date '
        ||  'FROM item '
        ||  'WHERE item_rating_agency = ''MPAA'' '
        ||  'AND item_release_date BETWEEN :start_date AND :end_date';

    OPEN item_cur FOR stmt USING pv_start_date, pv_end_date;
    LOOP

      FETCH item_cur INTO item_row;
      EXIT WHEN item_cur%NOTFOUND;

      item_set.EXTEND;
      item_set(item_set.COUNT) :=
            item_obj( title         => item_row.title,
                      subtitle      => item_row.subtitle,
                      rating        => item_row.rating,
                      release_date  =>  item_row.release_date  );
    END LOOP;

    RETURN item_set;
  END item_list;
/

SHOW ERRORS

/*  ===================================================================================  */

DESC item_obj
DESC item_tab
DESC item_list

/*  ===================================================================================  */
COL title   FORMAT A12 HEADING "TITLE"
COL rating  FORMAT A12 HEADING "RATING"
SELECT  ilist.title,
        ilist.rating
FROM TABLE(item_list('01-JAN-2000')) ilist
ORDER BY 1;

/*  ===================================================================================  */

-- Close log file.
SPOOL OFF

QUIT;
/