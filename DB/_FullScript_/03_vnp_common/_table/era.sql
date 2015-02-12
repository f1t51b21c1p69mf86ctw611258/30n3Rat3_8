DROP TABLE VNP_COMMON.ERA CASCADE CONSTRAINTS;

CREATE TABLE VNP_COMMON.ERA
(
  ID                  NUMBER(11)                NOT NULL,
  ACCOUNT_VERSION_ID  NUMBER(23),
  ERA_KEY             VARCHAR2(255 BYTE),
  ERA_VALUE           VARCHAR2(255 BYTE),
  ACCOUNT_ID          NUMBER(15),
  MODIFIED_DATE       DATE
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


GRANT DELETE, INSERT, SELECT, UPDATE ON VNP_COMMON.ERA TO VNP_DATA;

GRANT SELECT ON VNP_COMMON.ERA TO VNP_VIEW;
