/* Formatted on 28/04/2014 10:02:36 (QP5 v5.227.12220.39754) */
DROP DATABASE LINK EONERATE_VNP_COMMON;

CREATE DATABASE LINK EONERATE_VNP_COMMON
 CONNECT TO vnp_common
 IDENTIFIED BY vnp_common
 USING 'ELC_C1_EONERATE';
 
ELC_C1_EONERATE =
  (DESCRIPTION=
    (ADDRESS=
      (PROTOCOL=TCP)
      (HOST=192.168.6.207)
      (PORT=1521)
    )
    (CONNECT_DATA=
      (SERVER=dedicated)
      (SERVICE_NAME=eonerate)
    )
  )