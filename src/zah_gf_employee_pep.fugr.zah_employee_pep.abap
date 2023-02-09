FUNCTION ZAH_EMPLOYEE_PEP.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_EMP) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     VALUE(EX_EMP_PEP) TYPE  ZAH_TT_EMP_PEP
*"----------------------------------------------------------------------

  DATA: lr_emp_pep TYPE REF TO zah_cl_emp_pep.

  CREATE OBJECT lr_emp_pep.

  lr_emp_pep->get_employee_pep(
    EXPORTING
      it_num_emp = it_num_emp    " tabela de importação/exportação do número de colaborador
    IMPORTING
      ex_emp_pep = ex_emp_pep    " Estrutura para retorno do PEP do colaborador
  ).

ENDFUNCTION.
