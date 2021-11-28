
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
      1,
      SYSDATE,
      1,
      SYSDATE
    );

    COMMIT;

    EXCEPTION
      WHEN OTHERS THEN
        SHOW ERRORS;

  END insert_contact;

  SHOW ERRORS;

END contact_package;
/

DESC contact_package;

DESC system_user;

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