FUNCTION ZAH_MISSING_HOURS_WS.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_EMP) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     VALUE(ET_MISSING_HOURS) TYPE  ZAH_TT_MISSING_HOURS
*"----------------------------------------------------------------------

DATA:
        lo_zah_cl_get_missing_hours TYPE REF TO zah_cl_get_missing_hours.

  CREATE OBJECT lo_zah_cl_get_missing_hours.

  lo_zah_cl_get_missing_hours->get_missing_hours(
    EXPORTING
      it_num_emp       =  it_num_emp  " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_missing_hours =   et_missing_hours  " tabela exportação horas que faltam marcar ao colaborador
  ).



ENDFUNCTION.
