FUNCTION zah_abstence_types_ws.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(ET_ABSTENCE_TYPES_LIST) TYPE  ZAH_TT_ABSTENCE_TYPES_LIST
*"----------------------------------------------------------------------

  DATA: lo_zah_cl_lists TYPE REF TO zah_cl_lists.

  CREATE OBJECT lo_zah_cl_lists.

  lo_zah_cl_lists->get_abstence_types_list(
    IMPORTING
      et_abstence_types_list =  et_abstence_types_list  " tabela lista tipos de ausencia CATS
  ).


ENDFUNCTION.
