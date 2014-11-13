DROP VIEW VNP_COMMON.OFFER_PRIORITY_VIEW;

/* Formatted on 25/04/2014 16:23:27 (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW VNP_COMMON.OFFER_PRIORITY_VIEW
(
   PO_OFFER_ID,
   PO_OFFER_NAME,
   RESELLER_VERSION_ID,
   UPSELL_TEMPLATE_NAME,
   UPSELL_TEMPLATE_ID,
   UPSELL_TEMPLATE_MAP_ID,
   BUNDLE_NAME,
   BUNDLE_ID,
   UPSELL_TMP_OFFER_NAME,
   UPSELL_TMP_OFFER_ID,
   TARIFF_PRIORITY,
   RC_PRIORITY,
   DISCOUNT_PRIORITY,
   BALANCE_PRIORITY,
   DISPLAY_PRIORITY
)
AS
   SELECT PRODUCT_OFFER.OFFER_ID AS PO_OFFER_ID,
          PRODUCT_OFFER.OFFER_NAME AS PO_OFFER_NAME,
          PRODUCT_OFFER.RESELLER_VERSION_ID,
          UPSELL_TEMPLATE_NAME,
          OFFER_PRIORITY.UPSELL_TEMPLATE_ID,
          UPSELL_TEMPLATE_MAP_ID,
          BUNDLE_NAME,
          BUNDLE_ID,
          UPSELL_TMP_OFFER_NAME,
          UPSELL_TMP_OFFER_ID,
          TARIFF_PRIORITY,
          RC_PRIORITY,
          DISCOUNT_PRIORITY,
          BALANCE_PRIORITY,
          DISPLAY_PRIORITY
     FROM PRODUCT_OFFER
          INNER JOIN
          OFFER_PRIORITY
             ON     (PRODUCT_OFFER.UPSELL_TEMPLATE_ID =
                        OFFER_PRIORITY.UPSELL_TEMPLATE_ID)
                AND (PRODUCT_OFFER.RESELLER_VERSION_ID =
                        OFFER_PRIORITY.RESELLER_VERSION_ID)
    WHERE PRODUCT_OFFER.UPSELL_TEMPLATE_ID IS NOT NULL
   UNION
   SELECT PRODUCT_OFFER.OFFER_ID AS PO_OFFER_ID,
          PRODUCT_OFFER.OFFER_NAME AS PO_OFFER_NAME,
          PRODUCT_OFFER.RESELLER_VERSION_ID,
          UPSELL_TEMPLATE_NAME,
          OFFER_PRIORITY.UPSELL_TEMPLATE_ID,
          UPSELL_TEMPLATE_MAP_ID,
          BUNDLE_NAME,
          BUNDLE_ID,
          PRODUCT_OFFER.OFFER_NAME AS UPSELL_TMP_OFFER_NAME,
          PRODUCT_OFFER.OFFER_ID AS UPSELL_TMP_OFFER_ID,
          --       *** NOTE
          --       UPSELL_TMP_OFFER_NAME,
          --       UPSELL_TMP_OFFER_ID,
          -1 * PRODUCT_OFFER.OFFER_ID AS TARIFF_PRIORITY,
          -1 * PRODUCT_OFFER.OFFER_ID AS RC_PRIORITY,
          -1 * PRODUCT_OFFER.OFFER_ID AS DISCOUNT_PRIORITY,
          -1 * PRODUCT_OFFER.OFFER_ID AS BALANCE_PRIORITY,
          -1 * PRODUCT_OFFER.OFFER_ID AS DISPLAY_PRIORITY
     FROM PRODUCT_OFFER
          LEFT OUTER JOIN
          OFFER_PRIORITY
             ON     (PRODUCT_OFFER.UPSELL_TEMPLATE_ID =
                        OFFER_PRIORITY.UPSELL_TEMPLATE_ID)
                AND (PRODUCT_OFFER.RESELLER_VERSION_ID =
                        OFFER_PRIORITY.RESELLER_VERSION_ID)
    WHERE PRODUCT_OFFER.UPSELL_TEMPLATE_ID IS NULL

--       AND PRODUCT_OFFER.OFFER_TYPE = 'PO'
;
