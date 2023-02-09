FUNCTION zah_unid_organizacionais.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(EXP_UNID_ORG) TYPE  ZAH_TT_UNID_ORGANIZACIONAIS
*"----------------------------------------------------------------------

  DATA: lt_unid_org TYPE zah_tt_unid_organizacionais.

  SELECT orgeh, orgtx
    FROM t527x
    WHERE endda >= @sy-datum
      AND begda <= @sy-datum
      AND sprsl = 'P'
      INTO TABLE @lt_unid_org.

  exp_unid_org = lt_unid_org.

ENDFUNCTION.
