FUNCTION zah_pep_emp_ws.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_EMP) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     VALUE(ET_PEP_EMP) TYPE  ZAH_TT_PEP_EMP
*"----------------------------------------------------------------------

  DATA: lo_zah_cl_pep_cc_emp TYPE REF TO zah_cl_pep_cc_emp.

  CREATE OBJECT lo_zah_cl_pep_cc_emp.


  lo_zah_cl_pep_cc_emp->get_pep_emp(
    EXPORTING
      it_num_emp = it_num_emp  " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_pep_emp = et_pep_emp " Tabela PEPs por colaborador
  ).



ENDFUNCTION.
