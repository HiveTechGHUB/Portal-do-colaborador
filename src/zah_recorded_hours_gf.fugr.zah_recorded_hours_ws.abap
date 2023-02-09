FUNCTION zah_recorded_hours_ws.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_EMP) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     VALUE(ET_RECORDED_HOURS) TYPE  ZAH_TT_RECORDED_HOURS
*"----------------------------------------------------------------------


  DATA: lo_zah_cl_get_missing_hours TYPE REF TO zah_cl_get_missing_hours.

  CREATE OBJECT lo_zah_cl_get_missing_hours.

  "metodo com a logica do serviço
  lo_zah_cl_get_missing_hours->get_recorded_hours(
    EXPORTING
      it_num_emp        =  it_num_emp   " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_recorded_hours =  et_recorded_hours   " Tipo tabela recolher horas marcadas
  ).




ENDFUNCTION.
