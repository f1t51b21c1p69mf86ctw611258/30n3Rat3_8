/* Formatted on 07/12/2014 11:52:09 PM (QP5 v5.215.12089.38647) */
-- *** CBS_OWNER

GRANT EXECUTE ON ELC_USER.CBS_OWNER_FILTER TO cbs_owner;

GRANT EXECUTE ON VNP_COMMON.ELC_USER_FILTER_2 TO cbs_owner;

-- *** ELC_USER

GRANT CREATE JOB TO elc_user;

-- GRANT MANAGE SCHEDULER TO elc_user;

GRANT CREATE DATABASE LINK TO elc_user;
GRANT CREATE DATABASE LINK TO vnp_common;

--GRANT EXECUTE ON VNP_COMMON.ELC_USER_FILTER@EONERATE_VNP_COMMON TO ELC_USER;



-- *** VNP_COMMON

GRANT CREATE JOB TO vnp_common;

GRANT EXECUTE ON VNP_DATA.RR_UPDATE_COUNTER TO vnp_common;

BEGIN
   FOR R IN (SELECT OWNER, TABLE_NAME
               FROM ALL_TABLES
              WHERE OWNER = 'VNP_DATA')
   LOOP
      EXECUTE IMMEDIATE
            'GRANT SELECT, INSERT, DELETE, UPDATE ON '
         || R.OWNER
         || '.'
         || R.TABLE_NAME
         || ' TO VNP_COMMON';
   END LOOP;
END;

BEGIN
   FOR R IN (SELECT OWNER, VIEW_NAME
               FROM ALL_VIEWS
              WHERE OWNER = 'CBS_OWNER')
   LOOP
      EXECUTE IMMEDIATE
            'GRANT SELECT ON '
         || R.OWNER
         || '.'
         || R.VIEW_NAME
         || ' TO VNP_COMMON';
   END LOOP;
END;

BEGIN
   FOR R IN (SELECT OWNER, TABLE_NAME
               FROM ALL_TABLES
              WHERE OWNER = 'VNP_DATA')
   LOOP
      EXECUTE IMMEDIATE
            'GRANT SELECT ON '
         || R.OWNER
         || '.'
         || R.TABLE_NAME
         || ' TO VNP_VIEW';
   END LOOP;
END;

BEGIN
   FOR R IN (SELECT OWNER, TABLE_NAME
               FROM ALL_TABLES
              WHERE OWNER = 'VNP_COMMON_2')
   LOOP
      EXECUTE IMMEDIATE
            'GRANT SELECT, INSERT, DELETE, UPDATE ON '
         || R.OWNER
         || '.'
         || R.TABLE_NAME
         || ' TO VNP_COMMON';
   END LOOP;
END;

BEGIN
   FOR R IN (SELECT OWNER, TABLE_NAME
               FROM ALL_TABLES
              WHERE OWNER = 'VNP_COMMON')
   LOOP
      EXECUTE IMMEDIATE
            'GRANT SELECT ON '
         || R.OWNER
         || '.'
         || R.TABLE_NAME
         || ' TO VNP_VIEW';
   END LOOP;
END;

BEGIN
   FOR R IN (SELECT OWNER, TABLE_NAME
               FROM ALL_TABLES
              WHERE OWNER = 'VNP_COMMON')
   LOOP
      EXECUTE IMMEDIATE
            'GRANT SELECT, INSERT, DELETE, UPDATE ON '
         || R.OWNER
         || '.'
         || R.TABLE_NAME
         || ' TO VNP_DATA';
   END LOOP;
END;

BEGIN
   FOR R IN (SELECT OWNER, TABLE_NAME
               FROM ALL_TABLES
              WHERE OWNER = 'VNP_COMMON')
   LOOP
      EXECUTE IMMEDIATE
            'GRANT SELECT, INSERT, DELETE, UPDATE ON '
         || R.OWNER
         || '.'
         || R.TABLE_NAME
         || ' TO VNP_COMMON_PROP';
   END LOOP;
END;

BEGIN
   FOR R IN (SELECT OWNER, TABLE_NAME
               FROM ALL_TABLES
              WHERE OWNER = 'VNP_DATA')
   LOOP
      EXECUTE IMMEDIATE
            'GRANT SELECT, INSERT, DELETE, UPDATE ON '
         || R.OWNER
         || '.'
         || R.TABLE_NAME
         || ' TO VNP_COMMON_2';
   END LOOP;
END;

BEGIN
   FOR R IN (SELECT OWNER, TABLE_NAME
               FROM ALL_TABLES
              WHERE OWNER = 'VNP_COMMON')
   LOOP
      EXECUTE IMMEDIATE
            'GRANT SELECT, INSERT, DELETE, UPDATE ON '
         || R.OWNER
         || '.'
         || R.TABLE_NAME
         || ' TO VNP_COMMON_2';
   END LOOP;
END;