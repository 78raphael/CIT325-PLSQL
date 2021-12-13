-- ======================================================================
--  Name:    insert_instances.sql
--  Author:  Michael McLaughlin
--  Date:    02-Apr-2020
-- ------------------------------------------------------------------
--  Purpose: Prepare final project environment.
-- ======================================================================

-- Open the log file.
SPOOL insert_instances.txt

-- Here's a sample insert.
INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  man_t(  oid   => tolkien_s.CURRVAL,
          genus => 'Men',
          oname => 'Man',
          name  => 'Boromir' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  man_t(  oid   => tolkien_s.CURRVAL,
          genus => 'Men',
          oname => 'Man',
          name  => 'Faramir' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  hobbit_t( oid   => tolkien_s.CURRVAL,
            genus => 'Hobbits',
            oname => 'Hobbit',
            name  => 'Bilbo' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  hobbit_t( oid   => tolkien_s.CURRVAL,
            genus => 'Hobbits',
            oname => 'Hobbit',
            name  => 'Frodo' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  hobbit_t( oid   => tolkien_s.CURRVAL,
            genus => 'Hobbits',
            oname => 'Hobbit',
            name  => 'Merry' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  hobbit_t( oid   => tolkien_s.CURRVAL,
            genus => 'Hobbits',
            oname => 'Hobbit',
            name  => 'Pippin' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  hobbit_t( oid   => tolkien_s.CURRVAL,
            genus => 'Hobbits',
            oname => 'Hobbit',
            name  => 'Samwise' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  dwarf_t(  oid   => tolkien_s.CURRVAL,
            genus => 'Dwarves',
            oname => 'Dwarf',
            name  => 'Gimli' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  noldor_t( oid     => tolkien_s.CURRVAL,
            genus   => 'Elves',
            oname   => 'Elf',
            name    => 'Feanor',
            elfkind => 'Noldor' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  silvan_t( oid     => tolkien_s.CURRVAL,
            genus   => 'Elves',
            oname   => 'Elf',
            name    => 'Tauriel',
            elfkind => 'Silvan' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  teleri_t( oid     => tolkien_s.CURRVAL,
            genus   => 'Elves',
            oname   => 'Elf',
            name    => 'Earwen',
            elfkind => 'Teleri' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  teleri_t( oid     => tolkien_s.CURRVAL,
            genus   => 'Elves',
            oname   => 'Elf',
            name    => 'Celeborn',
            elfkind => 'Teleri' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  sindar_t( oid     => tolkien_s.CURRVAL,
            genus   => 'Elves',
            oname   => 'Elf',
            name    => 'Thranduil',
            elfkind => 'Sindar' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  sindar_t( oid     => tolkien_s.CURRVAL,
            genus   => 'Elves',
            oname   => 'Elf',
            name    => 'Legolas',
            elfkind => 'Sindar' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  orc_t(  oid     => tolkien_s.CURRVAL,
          genus   => 'Orcs',
          oname   => 'Orc',
          name    => 'Azog the Defiler' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  orc_t(  oid     => tolkien_s.CURRVAL,
          genus   => 'Orcs',
          oname   => 'Orc',
          name    => 'Bolg' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  maia_t( oid     => tolkien_s.CURRVAL,
          genus   => 'Maiar',
          oname   => 'Maia',
          name    => 'Gandalf the Gray' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  maia_t( oid     => tolkien_s.CURRVAL,
          genus   => 'Maiar',
          oname   => 'Maia',
          name    => 'Radagast the Brown' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  maia_t( oid     => tolkien_s.CURRVAL,
          genus   => 'Maiar',
          oname   => 'Maia',
          name    => 'Saruman the White' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  goblin_t( oid     => tolkien_s.CURRVAL,
            genus   => 'Goblins',
            oname   => 'Goblin',
            name    => 'The Great Goblin' ));

INSERT INTO tolkien
( tolkien_id,
  tolkien_character )
VALUES
( tolkien_s.NEXTVAL,
  man_t(  oid     => tolkien_s.CURRVAL,
          genus   => 'Men',
          oname   => 'Man',
          name    => 'Aragorn' ));


-- Close the log file.
SPOOL OFF

QUIT;
/