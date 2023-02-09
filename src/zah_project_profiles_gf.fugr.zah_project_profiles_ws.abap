FUNCTION ZAH_PROJECT_PROFILES_WS.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_PROJECT_PROFILES) TYPE  ZAH_TT_PROJECT_PROFILES_LIST
*"----------------------------------------------------------------------

  DATA: lo_ZAH_CL_LISTS TYPE REF TO ZAH_CL_LISTS.

  CREATE OBJECT lo_zah_cl_lists.

  lo_zah_cl_lists->get_project_profiles(
    IMPORTING
      et_project_profiles =  ET_PROJECT_PROFILES  " tabela lista de perfis de projetos CATS
  ).






ENDFUNCTION.
