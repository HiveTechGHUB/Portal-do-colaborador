FUNCTION zah_rec_vencimento.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_EMP) TYPE  ZAH_TT_NUM_EMP
*"     VALUE(IV_ANO_RECIBO) TYPE  PNPPABRJ
*"     VALUE(IV_MES_RECIBO) TYPE  PNPPABRP
*"  EXPORTING
*"     VALUE(ET_RECIBO) TYPE  ZAH_TT_REC_VENCIMENTO
*"----------------------------------------------------------------------

  DATA: lr_recibo TYPE REF TO zah_cl_rec_ven.

  CREATE OBJECT lr_recibo
    EXPORTING
      iv_ano_recibo = iv_ano_recibo    " Ano cálculo folhas de pagamento p/determinação período
      iv_mes_recibo = iv_mes_recibo.    " Período proc.FlhPgto.p/determinação período

  lr_recibo->get_colab_recibo(
    IMPORTING
      et_recibo  = et_recibo     " Tabela de retorno do recibo de vencimento
    CHANGING
      ct_num_emp = it_num_emp    " tabela de importação/exportação do número de colaborador
  ).

ENDFUNCTION.
