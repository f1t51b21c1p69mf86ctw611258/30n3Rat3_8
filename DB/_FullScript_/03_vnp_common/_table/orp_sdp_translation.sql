DROP TABLE VNP_COMMON.ORP_SDP_TRANSLATION CASCADE CONSTRAINTS;

CREATE TABLE VNP_COMMON.ORP_SDP_TRANSLATION
(
  PRODUCT_ID    VARCHAR2(15 BYTE),
  SDIP          NUMBER,
  DIALEDDIGITS  VARCHAR2(30 BYTE)
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


GRANT DELETE, INSERT, SELECT, UPDATE ON VNP_COMMON.ORP_SDP_TRANSLATION TO VNP_DATA;

GRANT SELECT ON VNP_COMMON.ORP_SDP_TRANSLATION TO VNP_VIEW;
