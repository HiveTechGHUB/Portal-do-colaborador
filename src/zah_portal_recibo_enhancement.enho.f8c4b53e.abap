"Name: \TY:CL_HRFORM_HRF02\ME:CLOSE_FORM\SE:END\EI
ENHANCEMENT 0 ZAH_PORTAL_RECIBO_ENHANCEMENT.
*
  DATA: iv_num_emp TYPE pernr_d.

*  FIELD-SYMBOLS: <lv_fdata> TYPE any.
*
*  ASSIGN fdata->* TO <lv_fdata>.

   IMPORT iv_num_emp TO iv_num_emp FROM MEMORY ID 'ZAH_PAYROLL_EXT_TOOL_PERNR'.

   CHECK iv_num_emp IS NOT INITIAL.

*exportar a tabela OTF
   export es_otfdata FROM ls_job_info-otfdata TO MEMORY ID 'ZAH_OTF_DATA'.

*expotar dados do pagamento
*   <lv_fdata> = me->fdata.

   FREE MEMORY ID 'ZAH_PAYROLL_EXT_TOOL_PERNR'.

*necessário para não mostrar o pop-up informativo
   LEAVE PROGRAM.


ENDENHANCEMENT.
