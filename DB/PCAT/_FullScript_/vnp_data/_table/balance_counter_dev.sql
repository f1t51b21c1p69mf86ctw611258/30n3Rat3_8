DROP TABLE VNP_DATA.BALANCE_COUNTER_DEV CASCADE CONSTRAINTS;

CREATE TABLE VNP_DATA.BALANCE_COUNTER_DEV
(
  BAL_GROUP_ID  NUMBER(15),
  COUNTER_ID    NUMBER(11),
  RECORD_ID     NUMBER(11),
  VALID_FROM    NUMBER(11),
  VALID_TO      NUMBER(11),
  CURRENT_BAL   NUMBER(15,3)
)
TABLESPACE VNP_DATA
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
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
