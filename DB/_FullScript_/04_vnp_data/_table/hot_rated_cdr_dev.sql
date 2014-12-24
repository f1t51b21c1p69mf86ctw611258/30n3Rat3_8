/* Formatted on 12/22/2014 11:04:37 AM (QP5 v5.215.12089.38647) */
DROP TABLE VNP_DATA.HOT_RATED_CDR_DEV;

CREATE TABLESPACE hot_rated_dev_p0
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_dev_p0.dbf'
    SIZE 100M
    REUSE
    AUTOEXTEND ON NEXT 100 M MAXSIZE UNLIMITED;

CREATE TABLESPACE hot_rated_dev_p1
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_dev_p1.dbf'
    SIZE 100M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_dev_p2
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_dev_p2.dbf'
    SIZE 100M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_dev_p3
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_dev_p3.dbf'
    SIZE 100M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_dev_p4
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_dev_p4.dbf'
    SIZE 100M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_dev_p5
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_dev_p5.dbf'
    SIZE 100M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_dev_p6
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_dev_p6.dbf'
    SIZE 100M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_dev_p7
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_dev_p7.dbf'
    SIZE 100M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_dev_p8
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_dev_p8.dbf'
    SIZE 100M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;

CREATE TABLESPACE hot_rated_dev_p9
  DATAFILE '+DATA/eonerate/datafile/vnp_data/hot_rated_dev_p9.dbf'
    SIZE 100M
    REUSE
    AUTOEXTEND ON NEXT 50 M MAXSIZE 2 G;


CREATE TABLE HOT_RATED_CDR_DEV
(
  MAP_ID NUMBER(9, 0) 
, A_NUMBER VARCHAR2(15 BYTE) 
, CDR_TYPE NUMBER(2, 0) 
, CREATED_TIME DATE DEFAULT SYSDATE 
, CDR_START_TIME DATE 
, DATA_PART NUMBER(2, 0) 
, DURATION NUMBER(11, 0) 
, TOTAL_USAGE NUMBER(11, 0) 
, B_NUMBER VARCHAR2(31 BYTE) 
, B_ZONE VARCHAR2(127 BYTE) 
, NW_GROUP VARCHAR2(15 BYTE) 
, SERVICE_FEE NUMBER(15, 3) 
, SERVICE_FEE_ID NUMBER(3, 0) 
, CHARGE_FEE NUMBER(31, 3) 
, CHARGE_FEE_ID NUMBER(5, 0) 
, LAC VARCHAR2(23 BYTE) 
, CELL_ID VARCHAR2(23 BYTE) 
, SUBSCRIBER_UNBILL CHAR(2 BYTE) 
, BU_ID VARCHAR2(3 BYTE) 
, OLD_BU_ID VARCHAR2(3 BYTE) 
, OFFER_COST NUMBER(15, 3) 
, OFFER_FREE_BLOCK NUMBER(21, 0) 
, INTERNAL_COST NUMBER(15, 3) 
, INTERNAL_FREE_BLOCK NUMBER(11, 0) 
, DIAL_DIGIT VARCHAR2(31 BYTE) 
, CDR_RECORD_HEADER_ID NUMBER(11, 0) 
, CDR_SEQUENCE_NUMBER NUMBER(11, 0) 
, LOCATION_NO VARCHAR2(31 BYTE) 
, MSC_ID VARCHAR2(31 BYTE) 
, UNIT_TYPE_ID NUMBER(2, 0) 
, PRIMARY_OFFER_ID NUMBER(10, 0) 
, DISCOUNT_ITEM_ID NUMBER(6, 0) 
, BALANCE_CHANGE VARCHAR2(500 BYTE) 
, RERATE_FLAG NUMBER(2, 0) 
, AUT_FINAL_ID NUMBER(6, 0) 
, TARIFF_PLAN_ID NUMBER(6, 0) 
, ERROR_CODE VARCHAR2(6 BYTE) DEFAULT 0 
, PAYMENT_ID NUMBER(6, 0) 
) 
PARTITION BY RANGE (DATA_PART)
   (PARTITION P0 VALUES LESS THAN (1)
       TABLESPACE hot_rated_dev_p0,
    PARTITION P1 VALUES LESS THAN (2)
       TABLESPACE hot_rated_dev_p1,
    PARTITION P2 VALUES LESS THAN (3)
       TABLESPACE hot_rated_dev_p2,
    PARTITION P3 VALUES LESS THAN (4)
       TABLESPACE hot_rated_dev_p3,
    PARTITION P4 VALUES LESS THAN (5)
       TABLESPACE hot_rated_dev_p4,
    PARTITION P5 VALUES LESS THAN (6)
       TABLESPACE hot_rated_dev_p5,
    PARTITION P6 VALUES LESS THAN (7)
       TABLESPACE hot_rated_dev_p6,
    PARTITION P7 VALUES LESS THAN (8)
       TABLESPACE hot_rated_dev_p7,
    PARTITION P8 VALUES LESS THAN (9)
       TABLESPACE hot_rated_dev_p8,
    PARTITION P9 VALUES LESS THAN (10)
       TABLESPACE hot_rated_dev_p9);

CREATE INDEX IDX_HRC_DEV_A_NUMBER
   ON HOT_RATED_CDR_DEV (A_NUMBER)
   TABLESPACE VNP_DATA_HRC;


CREATE INDEX IDX_HRC_DEV_CDR_REC_HEAD_ID
   ON HOT_RATED_CDR_DEV (CDR_RECORD_HEADER_ID)
   TABLESPACE VNP_DATA_HRC;