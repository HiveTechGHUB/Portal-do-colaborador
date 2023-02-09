FUNCTION ZAH_PHOTO_EMP_DELTA_WS.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_EMP) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     VALUE(ET_PHOTO_EMP) TYPE  ZAH_TT_PHOTO_EMP
*"----------------------------------------------------------------------


DATA:
        lo_zah_cl_get_photo_emp TYPE REF TO zah_cl_get_photo_emp.

  CREATE OBJECT lo_zah_cl_get_photo_emp.

  lo_zah_cl_get_photo_emp->get_photos_delta(
    EXPORTING
      it_num_emp   =  it_num_emp  " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_photo_emp =   et_photo_emp  " Tipo de tabela para exportação fotos do colaborador
  ).



ENDFUNCTION.
