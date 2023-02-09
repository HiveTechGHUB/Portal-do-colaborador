FUNCTION ZAH_COST_CENTER_WS.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_COST_CENTER_LIST) TYPE  ZAH_TT_COST_CENTER_LIST
*"----------------------------------------------------------------------

  data: lo_ZAH_CL_LISTS type REF TO ZAH_CL_LISTS.

  create OBJECT lo_zah_cl_lists.

  lo_zah_cl_lists->get_cost_center_list(
    IMPORTING
      et_cost_center_list = ET_COST_CENTER_LIST  " tabela lista centros de custo CATS
  ).





ENDFUNCTION.
