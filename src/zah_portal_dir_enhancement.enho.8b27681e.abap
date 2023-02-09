"Name: \PR:RPCIIDP0\IC:RPCIIDP0\SE:END\EI
ENHANCEMENT 0 ZAH_PORTAL_DIR_ENHANCEMENT.
*
  CONSTANTS: lc_no_dir_flag TYPE c value 'X'.

  DATA: ls_ucomm1 TYPE bal_s_cbuc,
        lv_num_emp TYPE pernr_d.

*importa o nº de colaborador
 IMPORT iv_num_emp TO lv_num_emp FROM MEMORY ID 'ZAH_PAYROLL_EXT_TOOL_PERNR'.

*se o numero de colaborador não for inicial e se tiver dados de payroll vai gerar e exportar o PDF da DIR
  IF p_ess_ex = abap_true AND lv_num_emp IS NOT INITIAL AND tax_data[] IS NOT INITIAL.
    ls_ucomm1-ucomm = '%EXT_PUSH1'.
    PERFORM button_press CHANGING ls_ucomm1.  "perform que gera e exporta a dir

*se não possuir dados de payroll
  ELSEIF tax_data[] is INITIAL.

    EXPORT lc_no_dir_flag to MEMORY ID 'ZAH_PAYROLL_NO_DIR_FLAG'.   "exporta a constante que indica que o colaborador não possui DIR

  ENDIF.

  FREE MEMORY ID 'ZAH_PAYROLL_EXT_TOOL_PERNR'.

ENDENHANCEMENT.
