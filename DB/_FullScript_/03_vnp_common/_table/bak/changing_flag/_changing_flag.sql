/* Formatted on 28/04/2014 09:35:04 (QP5 v5.227.12220.39754) */
-- DROP TABLE VNP_COMMON.CHANGE_FLAG CASCADE CONSTRAINTS;

CREATE TABLE VNP_COMMON.CHANGE_FLAG (IS_CHANGING NUMBER (1));

INSERT INTO VNP_COMMON.CHANGE_FLAG (IS_CHANGING)
     VALUES (0);

COMMIT;