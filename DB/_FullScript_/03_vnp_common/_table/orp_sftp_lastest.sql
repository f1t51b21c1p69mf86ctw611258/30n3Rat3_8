DROP TABLE VNP_COMMON.ORP_SFTP_LASTEST CASCADE CONSTRAINTS;

CREATE TABLE VNP_COMMON.ORP_SFTP_LASTEST
(
  SLU               VARCHAR2(63 BYTE),
  LASTEST_CDR_TIME  NUMBER(19)
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


GRANT DELETE, INSERT, SELECT, UPDATE ON VNP_COMMON.ORP_SFTP_LASTEST TO VNP_DATA;

GRANT SELECT ON VNP_COMMON.ORP_SFTP_LASTEST TO VNP_VIEW;
