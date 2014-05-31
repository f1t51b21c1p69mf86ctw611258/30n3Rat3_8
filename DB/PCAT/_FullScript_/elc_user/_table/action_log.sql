DROP TABLE ELC_USER.ACTION_LOG CASCADE CONSTRAINTS;

CREATE TABLE ELC_USER.ACTION_LOG
(
  LOG_TITLE     VARCHAR2(255 BYTE),
  LOG_GROUP     VARCHAR2(127 BYTE),
  LOG_CONTENT   VARCHAR2(1023 BYTE),
  LOG_LEVEL     NUMBER(1),
  CREATED_TIME  DATE                            DEFAULT SYSDATE
)
TABLESPACE ELC_USER
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          80K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;
