/* Formatted on 05/03/2014 11:24:28 (QP5 v5.215.12089.38647) */
SELECT * FROM rate_currency;

CREATE TABLE RATE_CURRENCY
AS
   SELECT t1.CURRENCY_CODE AS currencyCode,
          t5.DISPLAY_VALUE AS type_name,
          t2.CURRENCY_TYPE AS type_id,
          t2.ACTIVE_DATE AS active_Date,
          t2.INACTIVE_DATE AS inactive_Date,
          t2.ROUNDING_FACTOR AS rounding_Factor,
          t2.IS_DEFAULT AS is_Default,
          t2.IS_INTERNAL AS is_Internal,
          t2.ISO_CODE AS iso_Code,
          t2.ISO_NUMBER AS iso_Number,
          t3.DISPLAY_VALUE AS display_Value,
          t3.DESCRIPTION AS description
     FROM cbs_owner.RATE_CURRENCY_KEY t1
          INNER JOIN cbs_owner.RATE_CURRENCY_REF t2
             ON t1.CURRENCY_CODE = t2.CURRENCY_CODE
          INNER JOIN cbs_owner.RATE_CURRENCY_VALUES t3
             ON     t2.CURRENCY_CODE = t3.CURRENCY_CODE
                AND t2.SERVICE_VERSION_ID = t3.SERVICE_VERSION_ID
          INNER JOIN cbs_owner.CURRENCY_TYPE_REF t4
             ON t2.CURRENCY_TYPE = t4.CURRENCY_TYPE
          INNER JOIN cbs_owner.CURRENCY_TYPE_VALUES t5
             ON     t4.CURRENCY_TYPE = t5.CURRENCY_TYPE
                AND t5.LANGUAGE_CODE = t3.LANGUAGE_CODE
    WHERE     t2.SERVICE_VERSION_ID = 1
          AND t3.LANGUAGE_CODE = 1
          AND t3.DISPLAY_VALUE = 'DONG';