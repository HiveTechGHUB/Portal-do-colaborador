class ZAH_CL_PORTAL_COL definition
  public
  create public .

public section.

  interfaces ZAH_I_COMMON_METHODS .
protected section.
private section.

  data GV_AUX_DATE type SY-DATUM .
ENDCLASS.



CLASS ZAH_CL_PORTAL_COL IMPLEMENTATION.


  METHOD zah_i_common_methods~get_all_employee.


    CONSTANTS: lc_active(1) TYPE c VALUE '3'.

    gv_aux_date = sy-datum.

    "colaboradores ativos à data
    SELECT pernr
      INTO TABLE et_all_pernr
      FROM pa0000
      WHERE begda LE gv_aux_date
      AND endda GE gv_aux_date
      AND stat2 EQ lc_active"ativo
      ORDER BY pernr ASCENDING.

  ENDMETHOD.


  METHOD zah_i_common_methods~get_by_employee.

    DATA: lt_emp     TYPE TABLE OF p0000,
          ls_num_emp TYPE zah_s_num_emp,
          lv_subrc TYPE sy-subrc.

    "Se o parametro inicial estiver preenchido
    IF it_num_emp IS NOT INITIAL.

      "Percorrer o parametro inicial de modo a ler todos os dados introduzidos.
      LOOP AT it_num_emp INTO ls_num_emp-num_emp.

        "Chamada do RFC "HR_READ_INFOTYPE" para a recolha de dados e verificação do utilizador
        CALL FUNCTION 'HR_READ_INFOTYPE'
          EXPORTING
            pernr           = ls_num_emp-num_emp
            infty           = '0000'
            begda           = sy-datum
            endda           = '99991231'
          IMPORTING
            subrc           = lv_subrc
          TABLES
            infty_tab       = lt_emp.
*          EXCEPTIONS
*            infty_not_found = 1
*            OTHERS          = 2.

        "No caso do utilizador não existir
        IF lv_subrc NE 0.

          "Iremos colocar o numero de colaborador para uma tabela
          "de modo a informar o utilizador que este nao existe
          APPEND ls_num_emp-num_emp TO it_non_existing_num_emp.
          SORT it_non_existing_num_emp BY num_emp DESCENDING.

        ENDIF.

      ENDLOOP.

    ENDIF.

    CLEAR it_num_emp.

    "Se o parametro stat2 não for inicial,
    "iremos verificar se o utilizador está ativo ou não
    LOOP AT lt_emp INTO DATA(ls_emp) WHERE stat2 IS NOT INITIAL.

      "Estando ativo
      IF ls_emp-stat2 EQ '3'.

        APPEND ls_emp-pernr TO it_num_emp.
        SORT it_num_emp BY num_emp DESCENDING.

      "Não está ativo
      ELSE.

        APPEND ls_emp-pernr TO it_num_emp_not_active.
        SORT it_num_emp_not_active BY num_emp DESCENDING.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD zah_i_common_methods~get_company.

    CONSTANTS: lc_infty_0001 TYPE infty VALUE '0001'.

    DATA: lt_infty_0001 TYPE TABLE OF p0001,
          ls_company    TYPE zah_s_company,
          lv_subrc      TYPE sy-subrc.

    "loop à tabela de colaboradores
    LOOP AT it_num_emp INTO DATA(ls_num_emp).

      FREE: lt_infty_0001, ls_company.
      "recolhe informação do infotipo 1
      CALL FUNCTION 'HR_READ_INFOTYPE'
        EXPORTING
          pernr           = ls_num_emp-num_emp
          infty           = lc_infty_0001
          begda           = sy-datum
          endda           = sy-datum
        IMPORTING
          subrc           = lv_subrc
        TABLES
          infty_tab       = lt_infty_0001
        EXCEPTIONS
          infty_not_found = 1
          OTHERS          = 2.

*      CHECK lv_subrc = 0.

      "le a linha recohida
      READ TABLE lt_infty_0001 INTO DATA(ls_infty_0001) WITH KEY pernr = ls_num_emp-num_emp.

      "guarda o godigo da empresa do mesmo
      ls_company-num_emp = ls_num_emp-num_emp.
      ls_company-company = ls_infty_0001-bukrs.

      "insere na tabela de exportaçao
      APPEND ls_company TO et_company.

      FREE:ls_infty_0001.

    ENDLOOP.


  ENDMETHOD.


  METHOD zah_i_common_methods~validate_num_emp.

    IF it_num_emp IS INITIAL.
      zah_i_common_methods~get_all_employee(
        IMPORTING
          et_all_pernr = et_num_emp_validated    " tabela de importação/exportação do número de colaborador
      ).

    ELSE.
      DATA(lt_num_emp) = it_num_emp.

      zah_i_common_methods~get_by_employee(
        IMPORTING
          it_non_existing_num_emp = DATA(lt_non_existing_num_emp)    " tabela de importação/exportação do número de colaborador
          it_num_emp_not_active   = DATA(lt_num_emp_not_active)    " tabela de importação/exportação do número de colaborador
        CHANGING
          it_num_emp              =  lt_num_emp   " tabela de importação/exportação do número de colaborador
      ).

      et_num_emp_validated = lt_num_emp.
    ENDIF.
    SORT et_num_emp_validated ASCENDING by num_emp.

  ENDMETHOD.
ENDCLASS.
