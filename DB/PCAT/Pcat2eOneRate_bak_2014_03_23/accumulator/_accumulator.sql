select
    t1.ACCUMULATOR_ID as accumulatorId,
    t2.RESELLER_VERSION_ID as resellerVersionId,
--    t5.SERVICE_VERSION_ID as serviceVersionId,
    t6.DISPLAY_VALUE as unitsTypeKey,
    t2.UNIT_TYPE as unitType,
    t8.DISPLAY_VALUE as period,
    t2.RESET_POINT as resetPoint,
    t10.DISPLAY_VALUE as accumulatorType,
    t12.DISPLAY_VALUE as countType,
--    t14.DISPLAY_VALUE as accQualifyType,
--    t3.LANGUAGE_CODE as languageCode,
    t3.DISPLAY_VALUE as displayValue,
    t3.DESCRIPTION as description
from
    ACCUMULATOR_KEY t1
    inner join ACCUMULATOR_REF t2 on t1.ACCUMULATOR_ID = t2.ACCUMULATOR_ID
    inner join ACCUMULATOR_VALUES t3 on t2.ACCUMULATOR_ID = t3.ACCUMULATOR_ID
        and t2.RESELLER_VERSION_ID = t3.RESELLER_VERSION_ID
    inner join UNITS_TYPE_KEY t4 on t2.UNIT_TYPE = t4.UNIT_TYPE
    inner join UNITS_TYPE_REF t5 on t4.UNIT_TYPE = t5.UNIT_TYPE
        and t5.SERVICE_VERSION_ID = 1
    inner join UNITS_TYPE_VALUES t6 on t4.UNIT_TYPE = t6.UNIT_TYPE
        and t6.SERVICE_VERSION_ID = t5.SERVICE_VERSION_ID
        and t6.LANGUAGE_CODE = t3.LANGUAGE_CODE
    left outer join GUI_INDICATOR_REF t7 on t7.table_name = 'ACCUMULATOR_REF'
        and t7.field_name = lower('PERIOD')
        and t7.integer_value = t2.PERIOD
    left outer join GUI_INDICATOR_VALUES t8 on t8.table_name = t7.table_name
        and t8.field_name = t7.field_name
        and t8.integer_value = t7.integer_value
        and t8.LANGUAGE_CODE = t3.LANGUAGE_CODE
    left outer join GENERIC_ENUMERATION_REF t9 on t9.enumeration_key = lower('ACCUMULATOR_TYPE')
        and t9.value = t2.ACCUMULATOR_TYPE
    left outer join GENERIC_ENUMERATION_VALUES t10 on t10.enumeration_key = t9.enumeration_key
        and t10.value = t9.value
        and t10.LANGUAGE_CODE = t3.LANGUAGE_CODE
    left outer join GENERIC_ENUMERATION_REF t11 on t11.enumeration_key = lower('COUNT_TYPE')
        and t11.value = t2.COUNT_TYPE
    left outer join GENERIC_ENUMERATION_VALUES t12 on t12.enumeration_key = t11.enumeration_key
        and t12.value = t11.value
        and t12.LANGUAGE_CODE = t3.LANGUAGE_CODE
    left outer join GENERIC_ENUMERATION_REF t13 on t13.enumeration_key = lower('ACC_QUALIFY_TYPE')
        and t13.value = t2.ACC_QUALIFY_TYPE
    left outer join GENERIC_ENUMERATION_VALUES t14 on t14.enumeration_key = t13.enumeration_key
        and t14.value = t13.value
        and t14.LANGUAGE_CODE = t3.LANGUAGE_CODE
where
    t2.RESELLER_VERSION_ID = 2
    and t3.LANGUAGE_CODE = 1;
