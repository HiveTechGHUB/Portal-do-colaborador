"Name: \TY:CL_HRFORM_HRF02\ME:SET_SMARTFORM_PARAMETERS\SE:END\EI
ENHANCEMENT 0 ZAH_PORTAL_RECIBO_ENHANCEMENT.
*
  CONSTANTS: lc_langu_pt TYPE langu VALUE 'PT'.

  DATA: iv_num_emp TYPE pernr_d.

  FIELD-SYMBOLS: <lv_fdata> TYPE any.

  IMPORT iv_num_emp TO iv_num_emp FROM MEMORY ID 'ZAH_PAYROLL_EXT_TOOL_PERNR'.

  CHECK iv_num_emp is not INITIAL.

*se a linguagem não for PT vai dar um erro
  ME->FORMPROPS-SSF_CONTROL_PARAMETERS-langu = lc_langu_pt.

*exportar dados de pagamento
ASSIGN fdata->* TO <lv_fdata>.

EXPORT lv_fdata FROM <lv_fdata> TO MEMORY ID 'ZAH_VALORES_PAGAMENTO'.


ENDENHANCEMENT.
