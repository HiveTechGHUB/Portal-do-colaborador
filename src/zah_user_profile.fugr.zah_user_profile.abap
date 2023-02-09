FUNCTION zah_user_profile.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_NUM_COL) TYPE  ZAH_TT_NUM_EMP
*"  EXPORTING
*"     VALUE(EXP_USER_PROFILES) TYPE  ZAH_TT_USER_PROFILE
*"----------------------------------------------------------------------

  DATA: lr_user_profile TYPE REF TO zah_cl_user_profile.

  CREATE OBJECT lr_user_profile.

  lr_user_profile->read_all_methods(
    EXPORTING
      it_num_emp       = it_num_col     " tabela com os número de colaborador
    IMPORTING
      exp_perfil_colab = exp_user_profiles "DATA(it_user_profiles)    " Estrutura para o perfil do colaborador
  ).

"////=========================================================="
"///                 Implementação é diferente
"//Descrição:
"/============================================================="

*  DATA: lr_classe TYPE REF TO zah_cl_user_teste.
*
*  CREATE OBJECT lr_classe.
*
*  lr_classe->read_all_methods(
*    EXPORTING
*      it_num_emp       = it_num_col    " tabela de importação/exportação do número de colaborador
*    IMPORTING
*      exp_perfil_colab = exp_user_profiles    " Estrutura para o perfil do colaborador
*  ).



ENDFUNCTION.
