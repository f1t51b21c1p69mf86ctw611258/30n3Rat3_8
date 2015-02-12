DROP TABLE VNP_COMMON.PAYMENT_ITEM CASCADE CONSTRAINTS;

CREATE TABLE VNP_COMMON.PAYMENT_ITEM
(
  PAYMENT_ITEM_ID    NUMBER(3)                  NOT NULL,
  PAYMENT_ITEM_NAME  VARCHAR2(63 BYTE)          NOT NULL,
  USD                NUMBER(1),
  BONUS_TYPE         NUMBER(3)
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


GRANT DELETE, INSERT, SELECT, UPDATE ON VNP_COMMON.PAYMENT_ITEM TO VNP_DATA;

GRANT SELECT ON VNP_COMMON.PAYMENT_ITEM TO VNP_VIEW;
