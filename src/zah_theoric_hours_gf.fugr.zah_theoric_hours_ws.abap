FUNCTION ZAH_THEORIC_HOURS_WS.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_EMP) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     VALUE(ET_THEORIC_HOURS) TYPE  ZAH_TT_THEORIC_HOURS
*"----------------------------------------------------------------------

DATA:
        lo_zah_cl_get_missing_hours TYPE REF TO zah_cl_get_missing_hours.

  CREATE OBJECT lo_zah_cl_get_missing_hours.

  "metodo validar os numeros do colaborador importados
  "casa nao sejam importados nenhum o metodo retorna todos os colaboradores ativos
  lo_zah_cl_get_missing_hours->zah_i_common_methods~validate_num_emp(
    EXPORTING
      it_num_emp           =   IT_NUM_EMP  " tabela de importação/exportação do número de colaborador
    IMPORTING
      et_num_emp_validated =  data(lt_num_emps)   " tabela de importação/exportação do número de colaborador
  ).

  "recolhe horas teoricas dos colaboradores diarias
  lo_zah_cl_get_missing_hours->get_theoric_hours(
    EXPORTING
      it_num_emp       =  lt_num_emps " Nº pessoal
    IMPORTING
      et_theoric_hours =  ET_THEORIC_HOURS   " Horas
  ).



ENDFUNCTION.
