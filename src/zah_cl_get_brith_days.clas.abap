class ZAH_CL_GET_BRITH_DAYS definition
  public
  inheriting from ZAH_CL_PORTAL_COL
  final
  create public .

public section.

  methods GET_BIRTH_DAYS
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      !ET_BRITH_DAYS type ZAH_TT_BIRTH_DAY .
protected section.
private section.
ENDCLASS.



CLASS ZAH_CL_GET_BRITH_DAYS IMPLEMENTATION.


  METHOD get_birth_days.

    DATA: ls_birth_days TYPE zah_s_birth_day,
          lv_subrc      TYPE sy-subrc,
          lt_infty_2    TYPE TABLE OF p0002,
          ls_infty_2    TYPE  p0002.

    CONSTANTS: lc_infotype(4) TYPE c VALUE '0002'.

    "metodo validar os numeros do colaborador importados
    "casa nao sejam importados nenhum o metodo retorna todos os colaboradores ativos
    zah_i_common_methods~validate_num_emp(
    EXPORTING
      it_num_emp           =  it_num_emp   " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_num_emp_validated =  DATA(lt_num_emps)   " tabela de importação/exportação do número de colaborador
  ).

    LOOP AT lt_num_emps INTO DATA(ls_num_emp).
      FREE: lt_infty_2,
             ls_infty_2,
             ls_birth_days.

      CALL FUNCTION 'HR_READ_INFOTYPE'
        EXPORTING
          pernr     = ls_num_emp-num_emp
          infty     = lc_infotype
          begda     = sy-datum
          endda     = sy-datum
        IMPORTING
          subrc     = lv_subrc
        TABLES
          infty_tab = lt_infty_2.

      IF lv_subrc EQ 0.

        READ TABLE lt_infty_2 INTO ls_infty_2 INDEX 1.
        IF sy-subrc EQ 0.


          ls_birth_days-num_col = ls_num_emp-num_emp.
          ls_birth_days-birth_day = ls_infty_2-gbdat.

          APPEND ls_birth_days TO et_brith_days.

        ENDIF.
      ENDIF.



    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
