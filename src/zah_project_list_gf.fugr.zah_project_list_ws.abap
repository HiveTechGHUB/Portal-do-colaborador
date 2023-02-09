FUNCTION ZAH_PROJECT_LIST_WS.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_PROJECT_LIST) TYPE  ZAH_TT_PROJECT_LIST
*"----------------------------------------------------------------------

  data: lo_ZAH_CL_LISTS TYPE REF TO ZAH_CL_LISTS.

  CREATE OBJECT lo_zah_cl_lists.

  lo_zah_cl_lists->get_project_list(
    IMPORTING
      et_project_list = ET_PROJECT_LIST    " Tabela lista de projetos CATS
  ).





ENDFUNCTION.
