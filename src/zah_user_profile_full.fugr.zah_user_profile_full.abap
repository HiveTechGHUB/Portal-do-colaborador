FUNCTION zah_user_profile_full.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IT_NUM_COL) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     VALUE(EXP_USER_PA0001) TYPE  ZAH_TT_PERFIL_PA0001_FULL
*"     VALUE(EXP_USER_PA0002) TYPE  ZAH_TT_PERFIL_PA0002_FULL
*"     VALUE(EXP_USER_PA0006) TYPE  ZAH_TT_PERFIL_PA0006_FULL
*"     VALUE(EXP_USER_PA0009) TYPE  ZAH_TT_PERFIL_PA0009_FULL
*"     VALUE(EXP_USER_PA0016) TYPE  ZAH_TT_PERFIL_PA0016_FULL
*"     VALUE(EXP_USER_PA0021) TYPE  ZAH_TT_PERFIL_PA0021_FULL
*"     VALUE(EXP_USER_PA0105) TYPE  ZAH_TT_PERFIL_PA0105_FULL
*"     VALUE(EXP_USER_PA0185) TYPE  ZAH_TT_PERFIL_PA0185_FULL
*"----------------------------------------------------------------------

  DATA: lr_user_profile TYPE REF TO zah_cl_user_profile_full.

  CREATE OBJECT lr_user_profile.

  lr_user_profile->read_all_methods(
    EXPORTING
      it_num_emp      = it_num_col    " tabela de importação/exportação do número de colaborador
    IMPORTING
      exp_user_pa0001 = exp_user_pa0001    " Estrutura para o perfil do colaborador
      exp_user_pa0002 = exp_user_pa0002    " Recolha de dados especificos para o infotipo 0002
      exp_user_pa0006 = exp_user_pa0006    " Recolha de dados especificos do infotipo 0006
      exp_user_pa0009 = exp_user_pa0009    " Recolha de dados especificos do infotipo 0009
      exp_user_pa0016 = exp_user_pa0016    " Recolha de dados especificos do infotipo 0016
      exp_user_pa0021 = exp_user_pa0021    " Recolha de dados especificos do infotipo 0021
      exp_user_pa0105 = exp_user_pa0105    " Recolha de dados especificos do infotipo 0021
      exp_user_pa0185 = exp_user_pa0185    " Recolha de dados especificos do infotipo 0185
  ).

ENDFUNCTION.
