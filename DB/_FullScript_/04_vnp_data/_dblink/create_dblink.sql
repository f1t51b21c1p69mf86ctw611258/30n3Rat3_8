/* Formatted on 13/12/2014 6:22:22 PM (QP5 v5.215.12089.38647) */
DROP DATABASE LINK BAK_VNP_COMMON;

CREATE DATABASE LINK BAK_VNP_COMMON
 CONNECT TO vnp_common
 IDENTIFIED BY vnp_common
 USING 'EONERATE_BACKUP';

DROP DATABASE LINK BAK_VNP_DATA;

CREATE DATABASE LINK BAK_VNP_DATA
 CONNECT TO vnp_data
 IDENTIFIED BY vnp_data
 USING 'EONERATE_BACKUP';

DROP DATABASE LINK PROD_VNP_COMMON;

CREATE DATABASE LINK PROD_VNP_COMMON
 CONNECT TO vnp_common
 IDENTIFIED BY vnp_common
 USING 'EONERATE_PRODUCT';

DROP DATABASE LINK PROD_VNP_DATA;

CREATE DATABASE LINK PROD_VNP_DATA
 CONNECT TO vnp_data
 IDENTIFIED BY vnp_data
 USING 'EONERATE_PRODUCT';

--EONERATE_BACKUP =
--  (DESCRIPTION =
--    (ADDRESS = (PROTOCOL = TCP)(HOST = backupdb)(PORT = 1521))
--    (CONNECT_DATA =
--      (SERVER = DEDICATED)
--      (SERVICE_NAME = eonerate)
--    )
--  )

--EONERATE_PRODUCT =
--  (DESCRIPTION=
--    (LOAD_BALANCE=on)
--    (ADDRESS_LIST=
--      (ADDRESS=
--        (PROTOCOL=TCP)
--        (HOST=10.149.3.111)
--        (PORT=1521)
--      )
--      (ADDRESS=
--        (PROTOCOL=TCP)
--        (HOST=10.149.3.112)
--        (PORT=1521)
--      )
--    )
--    (CONNECT_DATA=
--      (SERVICE_NAME=eonerate)
--    )
--  )