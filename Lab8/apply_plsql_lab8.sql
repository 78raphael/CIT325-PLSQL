
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

SET SERVEROUTPUT ON SIZE UNLIMITED;

CREATE OR REPLACE PACKAGE contact_package IS
  PROCEDURE insert_contact  (
    pv_first_name         VARCHAR2,
    pv_middle_name        VARCHAR2,
    pv_last_name          VARCHAR2,
    pv_user_name          VARCHAR2
  );

END contact_package;
/

CREATE OR REPLACE PACKAGE BODY contact_package IS
  PROCEDURE insert_contact  (
    pv_first_name         VARCHAR2,
    pv_middle_name        VARCHAR2,
    pv_last_name          VARCHAR2,
    pv_user_name          VARCHAR2
  ) IS

  BEGIN

    dbms_output.put_line('First Name: '||pv_first_name);
    dbms_output.put_line('Middle Name: '||pv_middle_name);
    dbms_output.put_line('Last Name: '||pv_last_name);
    dbms_output.put_line('User Name: '||pv_user_name);

  END insert_contact;
END contact_package;
/

BEGIN
  contact_package.insert_contact(
      pv_first_name         => 'Charlie',
      pv_middle_name        => NULL,
      pv_last_name          => 'Brown',
      pv_user_name          => 'DBA 3'
  );
END;
/


QUIT;
/