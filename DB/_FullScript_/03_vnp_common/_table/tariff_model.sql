DROP TABLE VNP_COMMON.TARIFF_MODEL CASCADE CONSTRAINTS;

CREATE TABLE VNP_COMMON.TARIFF_MODEL
(
  TARIFF_MODEL_ID      NUMBER(10),
  TARIFF_MODEL_NAME    VARCHAR2(720 BYTE),
  RESELLER_VERSION_ID  NUMBER(18),
  STEP                 NUMBER,
  TIER_FROM            NUMBER,
  TIER_TO              NUMBER,
  BEAT                 NUMBER(22,8),
  FACTOR               NUMBER(22,8),
  CHARGE_BASE          NUMBER(22,8),
  DESCRIPTION          VARCHAR2(2160 BYTE)
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
