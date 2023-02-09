FUNCTION zah_portal_dir.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_EMP) TYPE  ZAH_TT_NUM_EMP
*"     VALUE(IV_ANO) TYPE  PNPPABRJ
*"  EXPORTING
*"     VALUE(ET_DIR) TYPE  ZAH_TT_DIR_RETURN
*"----------------------------------------------------------------------

  DATA: lr_dir TYPE REF TO zah_cl_dir.

  CREATE OBJECT lr_dir.

  lr_dir->get_colab_dir(
    EXPORTING
      iv_ano     = iv_ano    " Ano cálculo folhas de pagamento p/determinação período
    IMPORTING
      et_dir     = et_dir    " Tabela para retorno da DIR
    CHANGING
      ct_num_emp = it_num_emp    " tabela de importação/exportação do número de colaborador
  ).



ENDFUNCTION.
