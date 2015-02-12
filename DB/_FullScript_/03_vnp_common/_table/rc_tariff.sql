DROP TABLE VNP_COMMON.RC_TARIFF CASCADE CONSTRAINTS;

CREATE TABLE VNP_COMMON.RC_TARIFF
(
  NUMBER_OF_DAYS     NUMBER(2)                  NOT NULL,
  OFFER_ID           NUMBER(11)                 NOT NULL,
  RC_TARIFF_TYPE_ID  NUMBER(3)                  NOT NULL,
  STATUS_ID          NUMBER(3),
  TARIFF_VALUE       NUMBER(15,3),
  FULL_CYCLE         CHAR(1 CHAR),
  TARIFF_ID          NUMBER
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


CREATE OR REPLACE TRIGGER VNP_COMMON.RC_TARIFF_TRG
BEFORE INSERT
ON VNP_COMMON.RC_TARIFF
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
-- For Toad:  Highlight column TARIFF_ID
  :new.TARIFF_ID := RC_TARIFF_SEQ.nextval;
END RC_TARIFF_TRG;
/


GRANT DELETE, INSERT, SELECT, UPDATE ON VNP_COMMON.RC_TARIFF TO VNP_DATA;

GRANT SELECT ON VNP_COMMON.RC_TARIFF TO VNP_VIEW;
