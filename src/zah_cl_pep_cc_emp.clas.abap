class ZAH_CL_PEP_CC_EMP definition
  public
  inheriting from ZAH_CL_PORTAL_COL
  final
  create public .

public section.

  methods GET_CC_EMP
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      !ET_CC_EMP type ZAH_TT_CC_EMP .
  methods GET_PEP_EMP
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      !ET_PEP_EMP type ZAH_TT_PEP_EMP .
protected section.
private section.
ENDCLASS.



CLASS ZAH_CL_PEP_CC_EMP IMPLEMENTATION.


  method GET_CC_EMP.

    DATA: ls_export TYPE zah_s_cc_emp.

    DATA: lt_infty27 TYPE TABLE OF p0027,
          ls_infty27 TYPE  p0027.

    DATA: lv_subrc TYPE sy-subrc.

    DATA: lv_fname   TYPE rollname,
          lv_counter TYPE numc2 VALUE 01.

    FIELD-SYMBOLS: <fs_cc>  TYPE any.

    "metodo validar os numeros do colaborador importados
    "casa nao sejam importados nenhum o metodo retorna todos os colaboradores ativos
    zah_i_common_methods~validate_num_emp(
    EXPORTING
      it_num_emp           =  it_num_emp   " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_num_emp_validated =  DATA(lt_num_emps)   " tabela de importação/exportação do número de colaborador
  ).

    LOOP AT lt_num_emps INTO DATA(ls_num_emp).

      lv_counter = 01.

      FREE: lt_infty27,
            ls_infty27.

      "lê linha infotipo 27 de acordo com o numero do colaborador
      CALL FUNCTION 'HR_READ_INFOTYPE'
        EXPORTING
          pernr     = ls_num_emp-num_emp
          infty     = '0027'
          begda     = sy-datum
          endda     = sy-datum
        IMPORTING
          subrc     = lv_subrc
        TABLES
          infty_tab = lt_infty27.

      IF lv_subrc EQ 0.

        READ TABLE lt_infty27 INTO ls_infty27 INDEX 1.

        IF sy-subrc EQ 0.
         "precorre ciclo 25 vezes
         WHILE lv_counter LE 25.

            FREE: ls_export.

            "define nome do campo que precisamos recolher o valor
            lv_fname = 'KST' && lv_counter.
            "lê o valor que o campo corresponde ao nome definido e guarda nuum field simbol
            ASSIGN COMPONENT lv_fname OF STRUCTURE ls_infty27 TO <fs_cc>.

            IF <fs_cc> IS ASSIGNED.

              IF <fs_cc> IS NOT INITIAL.

                ls_export-num_emp = ls_num_emp-num_emp.
                ls_export-cost_center = <fs_cc>.
                ls_export-updatedon = ls_infty27-aedtm.
                ls_export-updatedby = ls_infty27-uname.

                "adiciona estrutura na tabela de exportação
                APPEND ls_export TO et_cc_emp.

              ENDIF.

            ENDIF.

            ADD 1 TO lv_counter.

          ENDWHILE.

        ENDIF.

      ENDIF.

    ENDLOOP.

  endmethod.


  METHOD get_pep_emp.

    DATA: ls_export TYPE zah_s_pep_emp.

    DATA: lt_infty27 TYPE TABLE OF p0027,
          ls_infty27 TYPE  p0027.

    DATA: lt_info_proj TYPE TABLE OF zah_s_info_proj,
          ls_info_proj TYPE  zah_s_info_proj.

    DATA: lv_subrc TYPE sy-subrc.

    DATA: lv_fname   TYPE rollname,
          lv_counter TYPE numc2 VALUE 01.

    FIELD-SYMBOLS: <fs_pep> TYPE any.

    "metodo validar os numeros do colaborador importados
    "casa nao sejam importados nenhum o metodo retorna todos os colaboradores ativos
    zah_i_common_methods~validate_num_emp(
    EXPORTING
      it_num_emp           =  it_num_emp   " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_num_emp_validated =  DATA(lt_num_emps)   " tabela de importação/exportação do número de colaborador
  ).


    SELECT pspnr pspid post1
      INTO TABLE lt_info_proj
      FROM proj.



    LOOP AT lt_num_emps INTO DATA(ls_num_emp).

      lv_counter = 01.

      FREE: lt_infty27,
            ls_infty27,
            ls_info_proj.

      "lê linha infotipo 27 de acordo com o numero do colaborador
      CALL FUNCTION 'HR_READ_INFOTYPE'
        EXPORTING
          pernr     = ls_num_emp-num_emp
          infty     = '0027'
          begda     = sy-datum
          endda     = sy-datum
        IMPORTING
          subrc     = lv_subrc
        TABLES
          infty_tab = lt_infty27.

      IF lv_subrc EQ 0.

        READ TABLE lt_infty27 INTO ls_infty27 INDEX 1.
        "precorre ciclo 25 vezes
        IF sy-subrc EQ 0.

          WHILE lv_counter LE 25.

            FREE: ls_export.

            "define nome do campo que precisamos recolher o valor
            lv_fname = 'PSP' && lv_counter.
            "lê o valor que o campo corresponde ao nome definido e guarda nuum field simbol
            ASSIGN COMPONENT lv_fname OF STRUCTURE ls_infty27 TO <fs_pep>.

            IF <fs_pep> IS ASSIGNED.

              IF <fs_pep> IS NOT INITIAL.

                ls_export-num_emp = ls_num_emp-num_emp.
                ls_export-updatedon = ls_infty27-aedtm.
                ls_export-updatedby = ls_infty27-uname.

                READ TABLE lt_info_proj into ls_info_proj WITH KEY id_pep = <fs_pep>.

                IF ls_info_proj is NOT INITIAL.
                  "meter ifens para melhor display do pep
                  CONCATENATE ls_info_proj-pep(2) '-' ls_info_proj-pep+2(1) '-' ls_info_proj-pep+3(5) into data(lv_pep).

                ENDIF.

                ls_export-pep = lv_pep.



                "adiciona estrutura na tabela de exportação
                APPEND ls_export TO et_pep_emp.

              ENDIF.

            ENDIF.

            ADD 1 TO lv_counter.

          ENDWHILE.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
