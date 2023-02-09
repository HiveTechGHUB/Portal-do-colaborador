FUNCTION zah_cont_ausencias.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_EMP) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     VALUE(ET_CONT_AUSENCIAS) TYPE  ZAH_TT_CONT_AUS_RETURN
*"----------------------------------------------------------------------

  DATA: lr_cont_ausencias TYPE REF TO zah_cl_cont_ausencias.

  CREATE OBJECT lr_cont_ausencias.

  lr_cont_ausencias->get_cont_ausencias(
    IMPORTING
      et_cont_ausencias = et_cont_ausencias    " Tabela para retorno dos contingentes de ausência
    CHANGING
      ct_num_emp        = it_num_emp    " tabela de importação/exportação do número de colaborador
  ).



ENDFUNCTION.
