class ZAH_CL_EMP_PEP definition
  public
  inheriting from ZAH_CL_PORTAL_COL
  final
  create public .

public section.

  methods GET_EMPLOYEE_PEP
    importing
      value(IT_NUM_EMP) type ZAH_TT_NUM_EMP
    exporting
      !EX_EMP_PEP type ZAH_TT_EMP_PEP .
protected section.
private section.
ENDCLASS.



CLASS ZAH_CL_EMP_PEP IMPLEMENTATION.


  METHOD get_employee_pep.

    CONSTANTS: lc_5(1) TYPE n VALUE 5.

    DATA: ls_emp_pep TYPE zah_s_emp_pep.

    zah_i_common_methods~validate_num_emp(
      EXPORTING
        it_num_emp           = it_num_emp    " tabela de importação/exportação do número de colaborador
      IMPORTING
        et_num_emp_validated = it_num_emp    " tabela de importação/exportação do número de colaborador
    ).

    LOOP AT it_num_emp INTO DATA(ls_num_emp).

      CLEAR: ls_emp_pep.


      CONCATENATE lc_5 ls_num_emp-num_emp+6(2) INTO DATA(lv_emp_pep).

      ls_emp_pep-num_emp = ls_num_emp-num_emp.
      ls_emp_pep-emp_pep = lv_emp_pep.

      APPEND ls_emp_pep TO ex_emp_pep.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
