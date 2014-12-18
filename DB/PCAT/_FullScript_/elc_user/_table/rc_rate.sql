DROP TABLE ELC_USER.RC_RATE CASCADE CONSTRAINTS;

CREATE TABLE ELC_USER.RC_RATE
(
  RC_RATE_ID           NUMBER(10)               NOT NULL,
  RESELLER_VERSION_ID  NUMBER(18)               NOT NULL,
  RC_TERM_NAME         VARCHAR2(240 BYTE)       NOT NULL,
  RC_TERM_ID           NUMBER(10)               NOT NULL,
  OFFER_ID             NUMBER(10)               NOT NULL,
  PERIOD_FREQUENCE     VARCHAR2(240 BYTE),
  CURRENCY_NAME        VARCHAR2(240 BYTE)       NOT NULL,
  CURRENCY_CODE        NUMBER(6)                NOT NULL,
  RATE                 NUMBER(18)               NOT NULL
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
