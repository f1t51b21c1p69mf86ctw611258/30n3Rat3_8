/* Formatted on 3/20/2014 12:13:39 AM (QP5 v5.227.12220.39754) */
SELECT t1.OFFER_ID AS offer_id,                                    -- offerId,
       t3.DISPLAY_VALUE AS offer_name,                        -- displayValue,
       NULL AS offer_abbreviation,
       0 AS unbill,
       NULL AS b_number_enrich,
       NULL AS product_group_type,
       NULL AS parent_id,
       CASE T2.OFFER_TYPE WHEN 2 THEN 'PO' WHEN 3 THEN 'SO' ELSE 'AO' END
          AS offer_type,
       t2.RESELLER_VERSION_ID
  FROM cbs_owner.OFFER_KEY t1
       INNER JOIN cbs_owner.OFFER_REF t2 ON t1.OFFER_ID = t2.OFFER_ID
       INNER JOIN
       cbs_owner.OFFER_VALUES t3
          ON     t2.OFFER_ID = t3.OFFER_ID
             AND t3.RESELLER_VERSION_ID = t2.RESELLER_VERSION_ID
       INNER JOIN cbs_owner.SERVICE_CATEGORY_KEY t45
          ON t2.SERVICE_CATEGORY_ID = t45.SERVICE_CATEGORY_ID
       INNER JOIN
       cbs_owner.SERVICE_CATEGORY_VALUES t46
          ON     t2.SERVICE_CATEGORY_ID = t46.SERVICE_CATEGORY_ID
             AND t46.LANGUAGE_CODE = t3.LANGUAGE_CODE
             AND t46.service_version_id = 1
 WHERE t2.RESELLER_VERSION_ID = 2 AND t3.LANGUAGE_CODE = 1;