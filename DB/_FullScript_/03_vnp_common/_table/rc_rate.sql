DROP TABLE VNP_COMMON.RC_RATE CASCADE CONSTRAINTS;

CREATE TABLE VNP_COMMON.RC_RATE
(
  RC_RATE_ID           NUMBER(10)               NOT NULL,
  RESELLER_VERSION_ID  NUMBER(18)               NOT NULL,
  RC_TERM_NAME         VARCHAR2(720 BYTE)       NOT NULL,
  RC_TERM_ID           NUMBER(10)               NOT NULL,
  OFFER_ID             NUMBER(10)               NOT NULL,
  PERIOD_FREQUENCE     VARCHAR2(720 BYTE),
  CURRENCY_NAME        VARCHAR2(720 BYTE)       NOT NULL,
  CURRENCY_CODE        NUMBER(6)                NOT NULL,
  RATE                 NUMBER(18)               NOT NULL
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
