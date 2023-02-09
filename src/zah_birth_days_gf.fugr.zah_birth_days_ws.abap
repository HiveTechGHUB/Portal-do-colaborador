FUNCTION zah_birth_days_ws.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_EMP) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     VALUE(ET_BRITH_DAYS) TYPE  ZAH_TT_BIRTH_DAY
*"----------------------------------------------------------------------

  DATA: lr_zah_cl_get_brith_days TYPE REF TO zah_cl_get_brith_days.

  CREATE OBJECT lr_zah_cl_get_brith_days.

  lr_zah_cl_get_brith_days->get_birth_days(
    EXPORTING
      it_num_emp    =  it_num_emp   " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_brith_days = ET_BRITH_DAYS    " tabela importação/exportaçao datas de aniversario
  ).


ENDFUNCTION.
