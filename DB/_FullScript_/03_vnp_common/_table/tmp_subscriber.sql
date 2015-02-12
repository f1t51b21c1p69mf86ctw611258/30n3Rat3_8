DROP TABLE VNP_COMMON.TMP_SUBSCRIBER CASCADE CONSTRAINTS;

CREATE TABLE VNP_COMMON.TMP_SUBSCRIBER
(
  SUBSCRIBER_ID   NUMBER(15)                    NOT NULL,
  SUBSCRIBER_NO   VARCHAR2(31 BYTE)             NOT NULL,
  SUBSCRIBER_NUM  NUMBER(11)
)
TABLESPACE VNP_COMMON
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            MAXSIZE          UNLIMITED
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


GRANT DELETE, INSERT, SELECT, UPDATE ON VNP_COMMON.TMP_SUBSCRIBER TO VNP_DATA;

GRANT SELECT ON VNP_COMMON.TMP_SUBSCRIBER TO VNP_VIEW;
