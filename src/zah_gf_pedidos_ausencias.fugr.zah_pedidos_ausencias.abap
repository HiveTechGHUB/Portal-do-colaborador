FUNCTION zah_pedidos_ausencias.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_EMP) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     VALUE(EXP_PA2001) TYPE  ZAH_TT_INFTY_2001
*"----------------------------------------------------------------------

  DATA:lr_portal       TYPE REF TO zah_cl_portal_col,
       lt_p2001        TYPE TABLE OF p2001,

       lt_dados_pa2001 TYPE TABLE OF zah_s_infty_2001,
       wa_dados_pa2001 TYPE zah_s_infty_2001.

  CREATE OBJECT lr_portal.

  lr_portal->zah_i_common_methods~validate_num_emp(
    EXPORTING
      it_num_emp           = it_num_emp    " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_num_emp_validated = DATA(lt_validated_numbers)    " tabela de importação/exportação do número de colaborador
  ).

  SELECT * FROM t554t WHERE sprsl EQ 'P' INTO TABLE @DATA(lt_t554t).

  IF sy-subrc EQ 0.

    LOOP AT lt_validated_numbers INTO DATA(wa_validated_number).

      CALL FUNCTION 'HR_READ_INFOTYPE'
        EXPORTING
          pernr           = wa_validated_number-num_emp
          infty           = '2001'
          begda           = '18000101'
          endda           = '99991231'
        TABLES
          infty_tab       = lt_p2001
        EXCEPTIONS
          infty_not_found = 1
          OTHERS          = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

    ENDLOOP.

  ENDIF.

  LOOP AT lt_p2001 INTO DATA(wa_p2001).

    READ TABLE lt_t554t WITH KEY awart = wa_p2001-awart INTO DATA(wa_t554t).
    wa_dados_pa2001-num_colaborador = wa_p2001-pernr.
    wa_dados_pa2001-tipo_ausencia = wa_t554t-atext.
    wa_dados_pa2001-dia_incial = wa_p2001-begda.
    wa_dados_pa2001-dia_final = wa_p2001-endda.
    wa_dados_pa2001-hora_incial = wa_p2001-beguz.
    wa_dados_pa2001-hora_final = wa_p2001-enduz.

    APPEND wa_dados_pa2001 TO lt_dados_pa2001.

    CLEAR wa_p2001.

  ENDLOOP.

  exp_pa2001 = lt_dados_pa2001.

ENDFUNCTION.
