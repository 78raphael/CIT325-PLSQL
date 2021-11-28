CREATE OR REPLACE PACKAGE BODY twotable IS
/*  ===================================================================================  */
  PROCEDURE warner_brother
  ( pv_grandma_house       VARCHAR2
  , pv_tweetie_bird_house  VARCHAR2 ) IS

    /* Declare a local variable for an existing grandma_id. */
    lv_grandma_id   NUMBER;

    FUNCTION get_grandma_id
    ( pv_grandma_house  VARCHAR2 ) RETURN NUMBER IS
      /* Local return variable. */
      lv_retval  NUMBER := 0;  -- Default value is 0.

      /* Use a cursor, which will not raise an exception at runtime. */
      CURSOR find_grandma_id
      ( cv_grandma_house  VARCHAR2 ) IS
        SELECT grandma_id
        FROM   grandma
        WHERE  grandma_house = cv_grandma_house;

    BEGIN

      /* Assign a value when a row exists. */
      FOR i IN find_grandma_id(pv_grandma_house) LOOP
        lv_retval := i.grandma_id;
      END LOOP;

      /* Return 0 when no row found and the ID # when row found. */
      RETURN lv_retval;
    END get_grandma_id;

  BEGIN

    /* Set the savepoint. */
    SAVEPOINT starting;

    /* Check for existing grandma row. */
    lv_grandma_id := get_grandma_id(pv_grandma_house);

    IF lv_grandma_id = 0 THEN

      /* Insert grandma. */
      INSERT INTO grandma
      ( grandma_id
      , grandma_house )
      VALUES
      ( grandma_seq.NEXTVAL
      , pv_grandma_house );

      /* Assign grandma_seq.currval to local variable. */
      lv_grandma_id := grandma_seq.CURRVAL;

    END IF;

    /* Insert tweetie bird. */
    INSERT INTO tweetie_bird
    ( tweetie_bird_id
    , tweetie_bird_house
    , grandma_id )
    VALUES
    ( tweetie_bird_seq.NEXTVAL
    , pv_tweetie_bird_house
    , lv_grandma_id );

    /* If the program gets here, both insert statements work. Commit it. */
    COMMIT;

  EXCEPTION

    /* When anything is broken do this. */
    WHEN OTHERS THEN
      /* Until any partial results. */
      ROLLBACK TO starting;

  END warner_brother;

/*  ===================================================================================  */

  FUNCTION warner_brother
  ( pv_grandma_house       VARCHAR2
  , pv_tweetie_bird_house  VARCHAR2 ) RETURN NUMBER IS

    /* Declare a local variable for an existing grandma_id and return variable. */
    lv_grandma_id  NUMBER;
    lv_retval      NUMBER := 1;

    FUNCTION get_grandma_id
    ( pv_grandma_house  VARCHAR2 ) RETURN NUMBER IS
      /* Local return variable. */
      lv_retval  NUMBER := 0;  -- Default value is 0.

      /* Use a cursor, which will not raise an exception at runtime. */
      CURSOR find_grandma_id
      ( cv_grandma_house  VARCHAR2 ) IS
        SELECT grandma_id
        FROM   grandma
        WHERE  grandma_house = cv_grandma_house;

    BEGIN

      /* Assign a value when a row exists. */
      FOR i IN find_grandma_id(pv_grandma_house) LOOP
        lv_retval := i.grandma_id;
      END LOOP;

      /* Return 0 when no row found and the ID # when row found. */
      RETURN lv_retval;
    END get_grandma_id;

  BEGIN

    /* Set the savepoint. */
    SAVEPOINT starting;

    /* Check for existing grandma row. */
    lv_grandma_id := get_grandma_id(pv_grandma_house);

    IF lv_grandma_id = 0 THEN

      /* Insert grandma. */
      INSERT INTO grandma
      ( grandma_id
      , grandma_house )
      VALUES
      ( grandma_seq.NEXTVAL
      , pv_grandma_house );

      /* Assign grandma_seq.currval to local variable. */
      lv_grandma_id := grandma_seq.CURRVAL;

    END IF;

    /* Insert tweetie bird. */
    INSERT INTO tweetie_bird
    ( tweetie_bird_id
    , tweetie_bird_house
    , grandma_id )
    VALUES
    ( tweetie_bird_seq.NEXTVAL
    , pv_tweetie_bird_house
    , lv_grandma_id );

    /* If the program gets here, both insert statements work. Commit it. */
    COMMIT;

    /* Return the value. */
    lv_retval := 0;

    /* Return the value. */
    RETURN lv_retval;
  EXCEPTION

    /* When anything is broken do this. */
    WHEN OTHERS THEN
      /* Until any partial results. */
      ROLLBACK TO starting;
  END warner_brother;
/*  ===================================================================================  */
END twotable;
/