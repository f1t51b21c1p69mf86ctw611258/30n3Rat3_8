DROP TABLE VNP_COMMON.CDR_MAPPING_ERROR_CODE CASCADE CONSTRAINTS;

CREATE TABLE VNP_COMMON.CDR_MAPPING_ERROR_CODE
(
  ERROR_CODE   VARCHAR2(7 BYTE)                 NOT NULL,
  DESCRIPTION  VARCHAR2(511 BYTE)
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

COMMENT ON COLUMN VNP_COMMON.CDR_MAPPING_ERROR_CODE.ERROR_CODE IS 'Error code for mapping CDR';

COMMENT ON COLUMN VNP_COMMON.CDR_MAPPING_ERROR_CODE.DESCRIPTION IS 'Descriptiption eror code';


GRANT DELETE, INSERT, SELECT, UPDATE ON VNP_COMMON.CDR_MAPPING_ERROR_CODE TO VNP_DATA;

GRANT SELECT ON VNP_COMMON.CDR_MAPPING_ERROR_CODE TO VNP_VIEW;
