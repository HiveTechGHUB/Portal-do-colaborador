interface ZAH_I_COMMON_METHODS
  public .


  methods GET_ALL_EMPLOYEE
    exporting
      value(ET_ALL_PERNR) type ZAH_TT_NUM_EMP .
  methods GET_BY_EMPLOYEE
    exporting
      !IT_NON_EXISTING_NUM_EMP type ZAH_TT_NUM_EMP
      !IT_NUM_EMP_NOT_ACTIVE type ZAH_TT_NUM_EMP
    changing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP .
  methods GET_COMPANY
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      value(ET_COMPANY) type ZAH_TT_COMPANY .
  methods VALIDATE_NUM_EMP
    importing
      !IT_NUM_EMP type ZAH_TT_NUM_EMP
    exporting
      !ET_NUM_EMP_VALIDATED type ZAH_TT_NUM_EMP .
endinterface.
