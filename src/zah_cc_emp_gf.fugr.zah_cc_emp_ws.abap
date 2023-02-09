FUNCTION zah_cc_emp_ws.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_EMP) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     VALUE(ET_CC_EMP) TYPE  ZAH_TT_CC_EMP
*"----------------------------------------------------------------------

  DATA: lo_zah_cl_pep_cc_emp TYPE REF TO zah_cl_pep_cc_emp.

  CREATE OBJECT lo_zah_cl_pep_cc_emp.

  lo_zah_cl_pep_cc_emp->get_cc_emp(
    EXPORTING
      it_num_emp =  it_num_emp   " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_cc_emp  = et_cc_emp  " Tabela retorna centros de custo associados ao cola
  ).



ENDFUNCTION.
