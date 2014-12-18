/* Formatted on 26/04/2014 13:29:39 (QP5 v5.227.12220.39754) */
GRANT EXECUTE ON VNP_DATA.RR_UPDATE_COUNTER TO pcat_filter;

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