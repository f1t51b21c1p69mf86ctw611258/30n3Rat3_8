/* Formatted on 12/21/2014 2:56:54 PM (QP5 v5.215.12089.38647) */
CREATE TABLESPACE hot_rated_off_p0
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_off_p0.dbf'
    SIZE 50M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_off_p1
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_off_p1.dbf'
    SIZE 50M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_off_p2
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_off_p2.dbf'
    SIZE 50M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_off_p3
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_off_p3.dbf'
    SIZE 50M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_off_p4
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_off_p4.dbf'
    SIZE 50M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_off_p5
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_off_p5.dbf'
    SIZE 50M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_off_p6
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_off_p6.dbf'
    SIZE 50M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_off_p7
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_off_p7.dbf'
    SIZE 50M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_off_p8
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_off_p8.dbf'
    SIZE 50M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_off_p9
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_off_p9.dbf'
    SIZE 50M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;


CREATE TABLE VNP_DATA.HOT_RATED_CDR_OFF
(
   -- MAP_ID                 NUMBER (9),
   A_NUMBER               VARCHAR2 (15 BYTE),
   CDR_TYPE               NUMBER (2),
   CREATED_TIME           DATE DEFAULT SYSDATE,
   CDR_START_TIME         DATE,
   DATA_PART              NUMBER (2),
   DURATION               NUMBER (11),
   TOTAL_USAGE            NUMBER (11),
   B_NUMBER               VARCHAR2 (31 BYTE),
   B_ZONE                 VARCHAR2 (127 BYTE),
   NW_GROUP               VARCHAR2 (15 BYTE),
   SERVICE_FEE            NUMBER (15, 3),
   SERVICE_FEE_ID         NUMBER (3),
   CHARGE_FEE             NUMBER (15, 3),
   CHARGE_FEE_ID          NUMBER (5),
   LAC                    VARCHAR2 (23 BYTE),
   CELL_ID                VARCHAR2 (23 BYTE),
   SUBSCRIBER_UNBILL      CHAR (2 BYTE),
   BU_ID                  VARCHAR2 (3 BYTE),
   OLD_BU_ID              VARCHAR2 (3 BYTE),
   OFFER_COST             NUMBER (15, 3),
   OFFER_FREE_BLOCK       NUMBER (21),
   INTERNAL_COST          NUMBER (15, 3),
   INTERNAL_FREE_BLOCK    NUMBER (11),
   DIAL_DIGIT             VARCHAR2 (31 BYTE),
   CDR_RECORD_HEADER_ID   NUMBER (11),
   CDR_SEQUENCE_NUMBER    NUMBER (11),
   LOCATION_NO            VARCHAR2 (31 BYTE),
   MSC_ID                 VARCHAR2 (31 BYTE),
   UNIT_TYPE_ID           NUMBER (2) NOT NULL,
   PRIMARY_OFFER_ID       NUMBER (10),
   DISCOUNT_ITEM_ID       NUMBER (6),
   BALANCE_CHANGE         VARCHAR2 (500 BYTE),
   RERATE_FLAG            NUMBER (2),
   AUT_FINAL_ID           NUMBER (6),
   TARIFF_PLAN_ID         NUMBER (6),
   ERROR_CODE             VARCHAR2 (6 BYTE) DEFAULT 0,
   PAYMENT_ID             NUMBER (6)
)
PARTITION BY RANGE (DATA_PART)
   (PARTITION P0 VALUES LESS THAN (1)
       TABLESPACE hot_rated_off_p0,
    PARTITION P1 VALUES LESS THAN (2)
       TABLESPACE hot_rated_off_p1,
    PARTITION P2 VALUES LESS THAN (3)
       TABLESPACE hot_rated_off_p2,
    PARTITION P3 VALUES LESS THAN (4)
       TABLESPACE hot_rated_off_p3,
    PARTITION P4 VALUES LESS THAN (5)
       TABLESPACE hot_rated_off_p4,
    PARTITION P5 VALUES LESS THAN (6)
       TABLESPACE hot_rated_off_p5,
    PARTITION P6 VALUES LESS THAN (7)
       TABLESPACE hot_rated_off_p6,
    PARTITION P7 VALUES LESS THAN (8)
       TABLESPACE hot_rated_off_p7,
    PARTITION P8 VALUES LESS THAN (9)
       TABLESPACE hot_rated_off_p8,
    PARTITION P9 VALUES LESS THAN (10)
       TABLESPACE hot_rated_off_p9);