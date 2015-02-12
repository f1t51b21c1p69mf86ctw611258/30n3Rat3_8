ALTER TABLE VNP_COMMON.SFTP_LASTEST
 DROP PRIMARY KEY CASCADE;

DROP TABLE VNP_COMMON.SFTP_LASTEST CASCADE CONSTRAINTS;

CREATE TABLE VNP_COMMON.SFTP_LASTEST
(
  SLU               VARCHAR2(63 BYTE),
  DATE_FOLDER       VARCHAR2(15 BYTE),
  LASTEST_CDR_TIME  NUMBER(15)
)
TABLESPACE VNP_COMMON
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX VNP_COMMON.SFTP_LASTEST_PK ON VNP_COMMON.SFTP_LASTEST
(SLU, DATE_FOLDER)
LOGGING
TABLESPACE VNP_COMMON
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;

ALTER TABLE VNP_COMMON.SFTP_LASTEST ADD (
  CONSTRAINT SFTP_LASTEST_PK
  PRIMARY KEY
  (SLU, DATE_FOLDER)
  USING INDEX VNP_COMMON.SFTP_LASTEST_PK
  ENABLE VALIDATE);

GRANT DELETE, INSERT, SELECT, UPDATE ON VNP_COMMON.SFTP_LASTEST TO VNP_DATA;

GRANT SELECT ON VNP_COMMON.SFTP_LASTEST TO VNP_VIEW;
