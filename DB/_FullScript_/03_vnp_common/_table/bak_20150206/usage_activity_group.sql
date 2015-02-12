DROP TABLE VNP_COMMON.USAGE_ACTIVITY_GROUP CASCADE CONSTRAINTS;

CREATE TABLE VNP_COMMON.USAGE_ACTIVITY_GROUP
(
  UA_MAP_ID            NUMBER(10)               NOT NULL,
  UA_GROUP_NAME        VARCHAR2(720 BYTE)       NOT NULL,
  UA_GROUP_ID          NUMBER(6)                NOT NULL,
  UA_NAME              VARCHAR2(720 BYTE),
  UA_ID                NUMBER(10),
  RESELLER_VERSION_ID  NUMBER(18)               NOT NULL
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
