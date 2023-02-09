FUNCTION zah_missing_hours_days_ws.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_EMP) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     VALUE(ET_DAYS_MISSING_HOURS) TYPE  ZAH_TT_DAYS_MISSING_HOURS
*"----------------------------------------------------------------------

  DATA:
          lo_zah_cl_get_missing_hours TYPE REF TO zah_cl_get_missing_hours.

  CREATE OBJECT lo_zah_cl_get_missing_hours.

  lo_zah_cl_get_missing_hours->get_days_missing_hours(
    EXPORTING
      it_num_emp            = it_num_emp     " Estrutura de importação/exportação do número de colaborador
    IMPORTING
      et_days_missing_hours =  et_days_missing_hours  " tabela exportação dias e respetivas horas em falta
  ).



ENDFUNCTION.
