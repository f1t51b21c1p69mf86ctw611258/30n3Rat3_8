/* Formatted on 05/05/2014 11:33:18 (QP5 v5.227.12220.39754) */
DROP TABLE VNP_COMMON.PRODUCT_SETTING;

CREATE TABLE VNP_COMMON.PRODUCT_SETTING
(
   OFFER_NAME           VARCHAR2 (720 BYTE) NOT NULL,
   OFFER_ABBREVIATION   VARCHAR2 (15 BYTE),
   UNBILL               CHAR (1 BYTE) DEFAULT '0' NOT NULL,
   B_NUMBER_ENRICH      VARCHAR2 (87 BYTE),
   PRODUCT_GROUP_TYPE   VARCHAR2 (23 BYTE),
   PARENT_ID            NUMBER (7)
);