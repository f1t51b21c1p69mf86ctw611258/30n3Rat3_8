/* Formatted on 3/24/2014 1:52:26 PM (QP5 v5.215.12089.38647) */
SELECT t1.TARIFF_SET_MEMBER_ID AS tariffSetMemberId,
       t1.RESELLER_VERSION_ID AS resellerVersionId,
       t4.DISPLAY_VALUE AS tariffSetIdKey,
       t1.TARIFF_SET_ID AS tariffSetId,
       t7.DISPLAY_VALUE AS tariffKey,
       t1.TARIFF_ID AS tariffId,
       t10.DISPLAY_VALUE AS timeTypeKey,
       t1.TIME_TYPE_ID AS timeTypeId,
       t1.IS_PRIMARY AS isPrimary
  FROM cbs_owner.TARIFF_SET_MEMBER t1
       INNER JOIN cbs_owner.TARIFF_SET_ID_KEY t2
          ON t1.TARIFF_SET_ID = t2.TARIFF_SET_ID
       INNER JOIN cbs_owner.TARIFF_SET_ID_REF t3
          ON     t2.TARIFF_SET_ID = t3.TARIFF_SET_ID
             AND t3.RESELLER_VERSION_ID = t1.RESELLER_VERSION_ID
       INNER JOIN cbs_owner.TARIFF_SET_ID_VALUES t4
          ON     t2.TARIFF_SET_ID = t4.TARIFF_SET_ID
             AND t4.RESELLER_VERSION_ID = t1.RESELLER_VERSION_ID
             AND t4.LANGUAGE_CODE = 1
       LEFT OUTER JOIN cbs_owner.TARIFF_KEY t5
          ON t1.TARIFF_ID = t5.TARIFF_ID
       LEFT OUTER JOIN cbs_owner.TARIFF_REF t6
          ON     t5.TARIFF_ID = t6.TARIFF_ID
             AND t6.RESELLER_VERSION_ID = t1.RESELLER_VERSION_ID
       LEFT OUTER JOIN cbs_owner.TARIFF_VALUES t7
          ON     t5.TARIFF_ID = t7.TARIFF_ID
             AND t7.RESELLER_VERSION_ID = t1.RESELLER_VERSION_ID
             AND t7.LANGUAGE_CODE = t4.LANGUAGE_CODE
       INNER JOIN cbs_owner.TIME_TYPE_KEY t8
          ON t1.TIME_TYPE_ID = t8.TIME_TYPE_ID
       INNER JOIN cbs_owner.TIME_TYPE_REF t9
          ON     t8.TIME_TYPE_ID = t9.TIME_TYPE_ID
             AND t9.RESELLER_VERSION_ID = t1.RESELLER_VERSION_ID
       INNER JOIN cbs_owner.TIME_TYPE_VALUES t10
          ON     t8.TIME_TYPE_ID = t10.TIME_TYPE_ID
             AND t10.RESELLER_VERSION_ID = t1.RESELLER_VERSION_ID
             AND t10.LANGUAGE_CODE = t4.LANGUAGE_CODE
 WHERE t1.RESELLER_VERSION_ID = 2;