DROP PACKAGE VNP_COMMON.DML_TABLE;

CREATE OR REPLACE PACKAGE VNP_COMMON.DML_TABLE
IS
   FUNCTION INS_SFTP_FILE (
      in_SFTP_FILE   IN VNP_COMMON.SFTP_FILE.SFTP_FILE%TYPE,
      in_SLU         IN VNP_COMMON.SFTP_FILE.SLU%TYPE,
      in_SEQ         IN VNP_COMMON.SFTP_FILE.SEQ%TYPE,
      in_FILE_SIZE   IN VNP_COMMON.SFTP_FILE.FILE_SIZE%TYPE,
      in_STATUS      IN VNP_COMMON.SFTP_FILE.STATUS%TYPE,
      in_RETRY       IN VNP_COMMON.SFTP_FILE.RETRY%TYPE,
      in_NOTE        IN VNP_COMMON.SFTP_FILE.NOTE%TYPE)
      RETURN NUMBER;

   PROCEDURE UPD_SFTP_FILE (
      in_SFTP_FILE   IN VNP_COMMON.SFTP_FILE.SFTP_FILE%TYPE,
      in_SLU         IN VNP_COMMON.SFTP_FILE.SLU%TYPE,
      in_SEQ         IN VNP_COMMON.SFTP_FILE.SEQ%TYPE,
      in_FILE_SIZE   IN VNP_COMMON.SFTP_FILE.FILE_SIZE%TYPE,
      in_STATUS      IN VNP_COMMON.SFTP_FILE.STATUS%TYPE,
      in_RETRY       IN VNP_COMMON.SFTP_FILE.RETRY%TYPE,
      in_NOTE        IN VNP_COMMON.SFTP_FILE.NOTE%TYPE);

   PROCEDURE INS_SFTP_LASTEST (
      in_SLU                IN VNP_COMMON.SFTP_LASTEST.SLU%TYPE,
      in_DATE_FOLDER        IN VNP_COMMON.SFTP_LASTEST.DATE_FOLDER%TYPE,
      in_LASTEST_CDR_TIME   IN VNP_COMMON.SFTP_LASTEST.LASTEST_CDR_TIME%TYPE);

   PROCEDURE UPD_SFTP_LASTEST (
      in_SLU                IN VNP_COMMON.SFTP_LASTEST.SLU%TYPE,
      in_DATE_FOLDER        IN VNP_COMMON.SFTP_LASTEST.DATE_FOLDER%TYPE,
      in_LASTEST_CDR_TIME   IN VNP_COMMON.SFTP_LASTEST.LASTEST_CDR_TIME%TYPE);

   PROCEDURE MERGE_SFTP_LASTEST (
      in_SLU                IN VNP_COMMON.SFTP_LASTEST.SLU%TYPE,
      in_DATE_FOLDER        IN VNP_COMMON.SFTP_LASTEST.DATE_FOLDER%TYPE,
      in_LASTEST_CDR_TIME   IN VNP_COMMON.SFTP_LASTEST.LASTEST_CDR_TIME%TYPE);
END DML_TABLE;
/
