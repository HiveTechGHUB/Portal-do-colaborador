FUNCTION ZAH_CATS_LISTS_WS.
*"--------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_PROJECT_LIST) TYPE  ZAH_TT_PROJECT_LIST
*"     VALUE(ET_COST_CENTER_LIST) TYPE  ZAH_TT_COST_CENTER_LIST
*"     VALUE(ET_ABSTENCE_TYPES_LIST) TYPE  ZAH_TT_ABSTENCE_TYPES_LIST
*"--------------------------------------------------------------------

data: lo_ZAH_CL_CATS_LISTS TYPE REF TO ZAH_CL_CATS_LISTS.

create OBJECT lo_ZAH_CL_CATS_LISTS.

lo_zah_cl_cats_lists->get_cats_lists(
  IMPORTING
    et_project_list        =  ET_PROJECT_LIST   " Tabela lista de projetos CATS
    et_cost_center_list    =  ET_COST_CENTER_LIST   " tabela lista centros de custo CATS
    et_abstence_types_list =  ET_ABSTENCE_TYPES_LIST   " tabela lista tipos de ausencia CATS
).




ENDFUNCTION.
