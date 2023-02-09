"Name: \TY:CL_HRFORM_HRF02\ME:INIT_SMARTFORM_PARAMETERS\SE:END\EI
ENHANCEMENT 0 ZAH_PORTAL_RECIBO_ENHANCEMENT.

  DATA: iv_num_emp TYPE pernr_d.

  IMPORT iv_num_emp TO iv_num_emp FROM MEMORY ID 'ZAH_PAYROLL_EXT_TOOL_PERNR'.

  IF iv_num_emp IS NOT INITIAL.

    me->formprops-ssf_control_parameters-getotf    = abap_true.   " return OTF
    me->formprops-ssf_control_parameters-no_dialog = abap_true.   " print popup

  ENDIF.

ENDENHANCEMENT.
