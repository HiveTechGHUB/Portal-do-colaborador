FUNCTION ZAH_PROJECT_TYPES_WS.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_PROJECT_TYPES) TYPE  ZAH_TT_PROJECT_TYPES_LIST
*"----------------------------------------------------------------------

  DATA: lo_ZAH_CL_LISTS TYPE REF TO ZAH_CL_LISTS.

  CREATE OBJECT lo_zah_cl_lists.

  lo_zah_cl_lists->get_project_types(
    IMPORTING
      et_project_types =  ET_PROJECT_TYPES   " Tabela lista de tipos de projetos CATS
  ).


ENDFUNCTION.
